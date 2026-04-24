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
  CollectionReference get videosCollection => _firestore.collection('videos');
  CollectionReference get reportsCollection => _firestore.collection('reports');

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

  // Add a video report
  Future<void> addVideoReport({
    required String userId,
    required String videoUrl,
    required String description,
    required String category,
  }) async {
    try {
      await reportsCollection.add({
        'userId': userId,
        'videoUrl': videoUrl,
        'description': description,
        'category': category,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
      print("Video report added");
    } catch (e) {
      print("Error adding video report: $e");
    }
  }

  // Get all pending reports
  Stream<QuerySnapshot> getPendingReports() {
    return reportsCollection
        .where('status', isEqualTo: 'pending')
        .snapshots();
  }

  // Update report status
  Future<void> updateReportStatus(String reportId, String status) async {
    try {
      await reportsCollection.doc(reportId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      print("Report status updated to: $status");
    } catch (e) {
      print("Error updating report status: $e");
    }
  }
}