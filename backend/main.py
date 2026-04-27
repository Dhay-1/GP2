import static_ffmpeg
static_ffmpeg.add_paths()
# This includes the model implementation, audio and text preprocessing only. The API endpoints are defined at the end of the file.
import torch
import torch.nn as nn
import torch.nn.functional as F 
import numpy as np
import emoji
import re
import librosa
import io
import tempfile
from fastapi import FastAPI, File, UploadFile
from transformers import AutoTokenizer, AutoModel, pipeline
from arabert.preprocess import ArabertPreprocessor

# =================
# 1. INITIALIZATION
# =================

app = FastAPI()
device = torch.device("cpu") 
# Load Model
class SequentialHybridModel(nn.Module):
    def __init__(self, model_name, dropout_prob=0.5):
        super(SequentialHybridModel, self).__init__()

        # 1. AraBERT Layer
        self.arabert_layer = AutoModel.from_pretrained(model_name)

        # 2. Sentiment Layer
        self.sentiment_layer = nn.Linear(768, 64)

        # 3. CNN Layer
        self.cnn_layer = nn.Conv1d(832, 128, kernel_size=3, padding=1)

        # 4. Bi-LSTM Layer
        self.lstm_layer = nn.LSTM(128, 128, bidirectional=True, batch_first=True)

        # 5. GRU Layer
        self.gru_layer = nn.GRU(256, 128, batch_first=True)
        self.dropout = nn.Dropout(dropout_prob)

        # 6. Classification Layer
        self.classification_layer = nn.Linear(960, 2)

    def forward(self, input_ids, attention_mask):
        #BERT Processing
        bert_output = self.arabert_layer(input_ids=input_ids, attention_mask=attention_mask)
        bert_features = bert_output.last_hidden_state
        pooled_output = bert_output.pooler_output

        # Sentiment Processing
        sent_features = F.relu(self.sentiment_layer(pooled_output))
        sent_expand = sent_features.unsqueeze(1).expand(-1, bert_features.size(1), -1)
        combined = torch.cat((bert_features, sent_expand), dim=2)

        # CNN Processing
        cnn_input = combined.permute(0, 2, 1)
        cnn_features = F.relu(self.cnn_layer(cnn_input))
        cnn_output = cnn_features.permute(0, 2, 1)

        # Bi-LSTM needs [Batch, Seq, Channels]
        lstm_input = cnn_output.permute(0, 2, 1)
        lstm_out, _ = self.lstm_layer(lstm_input)

        # GRU processes the Bi-LSTM output
        gru_out, _ = self.gru_layer(lstm_out)
        gru_final = gru_out[:, -1, :] # Last hidden state

        # Final Fusion
        combined = torch.cat((pooled_output, sent_features, gru_final), dim=1)
        combined = self.dropout(combined)

        # Dense Layer
        prediction = self.classification_layer(combined)
        return prediction

# Processing Tools
prep_tool = ArabertPreprocessor(model_name="aubmindlab/bert-base-arabertv2")
asr_pipe = pipeline(
    "automatic-speech-recognition",
    model="openai/whisper-medium",
    chunk_length_s=30, 
    stride_length_s=5, 
    resume_download=True  
)
tokenizer = AutoTokenizer.from_pretrained("aubmindlab/bert-base-arabertv2", resume_download=True) 

# Load model weights
model = SequentialHybridModel(model_name="aubmindlab/bert-base-arabertv2")
model.load_state_dict(torch.load("AmanPlay_Model_Weights.pt", map_location=device))
model.eval()

# ==========================
# 2. PREPROCESSING FUNCTIONS
# ==========================

# 1} AUDIO PREPROCESSING
def transcribe_audio(audio_file):
    temp_audio_path = None
    # Create a temporary file to store the audio
    with tempfile.NamedTemporaryFile(delete=False, suffix=".wav") as temp_audio:
        temp_audio.write(audio_file)
        temp_audio_path = temp_audio.name
    try:
        # Load audio and convert bytes 
        audio, sr = librosa.load(io.BytesIO(audio_file), sr=16000)
        # Normalization
        audio = audio / (np.max(np.abs(audio)) + 1e-9)
        # Transcription
        result = asr_pipe(audio, generate_kwargs={"language": "arabic", "task": "transcribe"})
        return result["text"]
    finally:
        if  os.path.exists(temp_audio_path):
            os.remove(temp_audio_path)

#2} TEXT PREPROCESSING
# Emoji Conversion, Long spsces, tabs, new line Removal 
def basic_cleaning(text):
    if isinstance(text, str):
        # 1. emoji conversion
        text = emoji.demojize(text, delimiters=(" ", " "))

        # 2. clean up underscors and colons
        text = text.replace("_", " ").replace(":", "")

        # 3. strip and extra spaces removal
        text = text.strip()
        text = re.sub(r"\s+", " ", text)
        return text
    return ""

# full cleaning function (Basic cleaning + Normalization + Segmentation)
def full_clean(text: str):
    text = basic_cleaning(text)
    return prep_tool.preprocess(text)


# =============================
# 3. API ENDPOINTS (The Action)
# =============================

@app.post("/predict/audio")
async def predict_audio(file: UploadFile = File(...)):
    text_from_voice = ""
    # Step A: Preprocess & Transcribe the Audio 
    content = await file.read()
    text_from_voice = transcribe_audio(content)
    
    # Step B: Clean that text 
    cleaned_text = full_clean(text_from_voice)
    inputs = tokenizer(cleaned_text, return_tensors="pt", padding='max_length', truncation=True, max_length=128)

    # Step C: Feed to the Model
    with torch.no_grad():
        outputs = model(inputs['input_ids'], inputs['attention_mask'])
        probs = F.softmax(outputs, dim=1)
        confidence = probs[0][1].item()
    
    return {
        "is_bullying": confidence > 0.5,
        "confidence": confidence,
        "transcription": cleaned_text,
        "source": "audio" 
    }

@app.post("/predict/text")
async def predict_text(text: str):

    cleaned_text = full_clean(text)
    inputs = tokenizer(cleaned_text, return_tensors="pt", padding='max_length', truncation=True, max_length=128)
    
    with torch.no_grad():
        outputs = model(inputs['input_ids'], inputs['attention_mask'])
        probs = F.softmax(outputs, dim=1)
        confidence = probs[0][1].item()
        
    return {
        "is_bullying": confidence > 0.5,
        "confidence": confidence,
        "transcription": cleaned_text,
        "source": "text"
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=8000)
    