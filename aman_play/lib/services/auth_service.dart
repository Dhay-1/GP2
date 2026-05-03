import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService extends GetxController {
  static AuthService get instance => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Observable for current user
  Rx<User?> currentUser = Rx<User?>(null);
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to auth state changes
    _auth.authStateChanges().listen((User? user) {
      currentUser.value = user;
    });
  }

  // Sign Up with Email and Password
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Create user account
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Update user profile with name
      await userCredential.user?.updateDisplayName(fullName);

      print("User registered successfully: ${userCredential.user?.email}");
      
      // Send verification email
      try {
        await userCredential.user?.sendEmailVerification();
        print("✅ Verification email sent to: ${userCredential.user?.email}");
      } catch (emailError) {
        print("❌ Error sending verification email: $emailError");
        errorMessage.value = "حساب تم إنشاؤه لكن فشل إرسال بريد التحقق: $emailError";
      }
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    } finally {
      isLoading.value = false;
    }
  }

  // Login with Email and Password
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      print("User logged in successfully: ${_auth.currentUser?.email}");
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    } finally {
      isLoading.value = false;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      isLoading.value = true;
      await _auth.signOut();
      currentUser.value = null;
      print("User signed out");
    } catch (e) {
      errorMessage.value = "Error signing out: $e";
    } finally {
      isLoading.value = false;
    }
  }

  // Reset Password
  Future<void> resetPassword({required String email}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _auth.sendPasswordResetEmail(email: email.trim());
      print("Password reset email sent to: $email");
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    } finally {
      isLoading.value = false;
    }
  }

  // Handle Firebase Auth Errors
  void _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        errorMessage.value = 'كلمة المرور ضعيفة جداً';
        break;
      case 'email-already-in-use':
        errorMessage.value = 'هذا البريد الإلكتروني مستخدم بالفعل';
        break;
      case 'invalid-email':
        errorMessage.value = 'البريد الإلكتروني غير صالح';
        break;
      case 'user-not-found':
        errorMessage.value = 'لم يتم العثور على المستخدم';
        break;
      case 'wrong-password':
        errorMessage.value = 'كلمة المرور غير صحيحة';
        break;
      case 'user-disabled':
        errorMessage.value = 'تم تعطيل هذا الحساب';
        break;
      case 'too-many-requests':
        errorMessage.value = 'محاولات كثيرة جداً، حاول لاحقاً';
        break;
      default:
        errorMessage.value = 'خطأ: ${e.message}';
    }
    print("Auth Error: ${e.code} - ${e.message}");
  }

  // Check if user's email is verified
  bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;

  // Get current user email (from observable or Firebase Auth)
  String? get userEmail => currentUser.value?.email ?? _auth.currentUser?.email;

  // Get current user name (from observable or Firebase Auth)
  String? get userName => currentUser.value?.displayName ?? _auth.currentUser?.displayName;

  // Resend verification email
  Future<void> resendVerificationEmail() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      if (_auth.currentUser != null) {
        print("Attempting to resend verification email to: ${_auth.currentUser?.email}");
        await _auth.currentUser!.sendEmailVerification();
        print("✅ Verification email resent successfully");
      } else {
        errorMessage.value = "لا يوجد مستخدم مسجل دخول";
        print("❌ No user logged in");
      }
    } catch (e) {
      errorMessage.value = "خطأ في إرسال البريد: $e";
      print("❌ Error resending email: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Reload user to check if email is verified
  Future<void> reloadUser() async {
    try {
      await _auth.currentUser?.reload();
      currentUser.value = _auth.currentUser;
      if (_auth.currentUser?.emailVerified == true) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .update({'isVerified': true});
      print("✅ Firestore isVerified updated to true");
    }
    } catch (e) {
      errorMessage.value = "خطأ في تحديث الحساب: $e";
    }
  }
}
