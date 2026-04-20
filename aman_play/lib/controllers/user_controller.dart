import 'package:get/get.dart';

class UserController extends GetxController {
 
 var userName = "وجد الخميس".obs;
 var userEmail = "user1234@gmail.com".obs;
 var userPhone = "0512345678".obs;

 void updateUserData(String name, String email, String phone){
  userName.value = name;
  userEmail.value = email;
  userPhone.value = phone;
 }
}