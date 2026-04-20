import 'package:aman_play/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

 
 class ProfilePage extends StatelessWidget {
   ProfilePage({super.key});
  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Directionality(textDirection: TextDirection.rtl,
    child: Scaffold(
      
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF81D4C2), Color(0xFF2CB69A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            
            child: IconButton(
            icon: const Icon(Icons.arrow_forward, color: Colors.white),
             onPressed: () => Get.back(),
            
            ),
            
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.75,
                width: double.infinity,
                decoration: const BoxDecoration( 
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),

                child: SingleChildScrollView(
                  child: Column(
                  children: [ 
                  const SizedBox(height: 80),
                  Obx(() => Text(
                    userController.userName.value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF006D5B),
                    ),
                  )),
                  const SizedBox(height: 30),

                  _buildSectionCard("معلومات الحساب", [
                    Obx(() => _buildInfoTile("البريد الإلكتروني", userController.userEmail.value)),
                    _buildInfoTile("كلمة المرور", "************", isPassword: true),
                  ]),

                  const SizedBox(height: 20),

                  _buildSectionCard("المعلومات الشخصية", [
                    Obx(() => _buildInfoTile("الاسم الكامل", userController.userName.value)),
                    Obx(() => _buildInfoTile("رقم الهاتف", userController.userPhone.value)),
                  ]),
                  const SizedBox(height: 40),

                      ],
                    ),
                ),
              ),
             ),

             Positioned(
            top: MediaQuery.of(context).size.height * 0.18,
            left: MediaQuery.of(context).size.width * 0.5 - 60,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: const CircleAvatar(
                radius: 55,
                backgroundColor: Color(0xFFE0E0E0),
                child: Icon(Icons.person, size: 70, color: Color(0xFF00BFA5)),
              ),
            ),
          ),
             
        ],
      ),
    ),
    ); 
  }

  Widget _buildSectionCard(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Text(
              title, 
              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00BFA5)),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 2,
            color: const Color(0xFFF5F5F5),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(children: children),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildInfoTile(String label, String value, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            
            children: [
              if (isPassword) const Icon(Icons.visibility_off_outlined, size: 18, color: Colors.grey),
              const SizedBox(width: 5),
              Text(
                label, 
                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF006D5B)),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            value, 
            
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }
 }