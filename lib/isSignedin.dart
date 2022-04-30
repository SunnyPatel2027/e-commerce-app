import 'package:e_commerce/controller/firebase_controller.dart';
import 'package:e_commerce/screens/auth/auth_screen.dart';
import 'package:e_commerce/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class IsSignedIn extends GetWidget<FirebaseController> {
  const IsSignedIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Get
          .find<FirebaseController>()
          .user != null ? HomeScreen() : AuthScreen();
    });
  }
}
