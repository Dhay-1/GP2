import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class FirestoreService extends GetxController {
  static FirestoreService get instance => Get.find();

  late FirebaseFirestore _firestore;
  RxBool isInitialized = false.obs;

  @override
  void onInit() {
    super.onInit();
    _firestore = FirebaseFirestore.instance;
    isInitialized.value = true;
    print("Firestore initialized!");
  }

  // Collection references
  CollectionReference get usersCollection => _firestore.collection('users');

CollectionReference get detectionsCollection => _firestore.collection('detections');
  // Create a new user document
  Future<void> createUserDocument({
    required String uid,
    required String email,
    required String name,
  }) async {
    try {
      await usersCollection.doc(uid).set({
        'uid': uid,
        'email': email,
        'name': name,
        'createdAt': FieldValue.serverTimestamp(),
        'isVerified': false,
        'profileImage': null,
      });
      print("User document created for: $email");
    } catch (e) {
      print("Error creating user document: $e");
    }
  }

  // Get user data by UID
  Future<DocumentSnapshot?> getUserByUid(String uid) async {
    try {
      return await usersCollection.doc(uid).get();
    } catch (e) {
      print("Error getting user: $e");
      return null;
    }
  }

  // Update user data
  Future<void> updateUserData({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    try {
      await usersCollection.doc(uid).update(data);
      print("User data updated for: $uid");
    } catch (e) {
      print("Error updating user data: $e");
    }
  }

// Save bullying detection result
Future<void> saveDetectionResult({
  required String userEmail,
  required bool isBullying,
  required double confidence,
  required String transcription,
  required String source,
}) async {
  try {
    await detectionsCollection.add({
      'user_email': userEmail,
      'is_bullying': isBullying,
      'confidence': confidence,
      'transcription': transcription,
      'source': source,
      'createdAt': FieldValue.serverTimestamp(),
    });
    print("Detection saved to Firestore");
  } catch (e) {
    print("Error saving detection: $e");
  }
}
}