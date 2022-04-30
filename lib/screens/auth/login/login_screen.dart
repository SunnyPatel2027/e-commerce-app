import 'package:e_commerce/controller/firebase_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
class LoginScreen extends GetWidget<FirebaseController> {
   LoginScreen({Key? key}) : super(key: key);
  final _formkey = GlobalKey<FormState>();
  // final TextEditingController _email = TextEditingController();
  //  final TextEditingController _password = TextEditingController();
   FirebaseController _firebaseController = Get.put(FirebaseController());
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(12),
        // width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height,
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Login to your account",
                style: TextStyle(
                    color: Colors.red, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 20,),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: Icon(Icons.person),
                      hintText: "Email",
                      contentPadding: EdgeInsets.all(20)
                  ),
                  controller: _firebaseController.emailLog,
                  validator: (value) {
                    if (value.toString().isEmpty ||
                        !value.toString().contains("@gmail.com")) {
                      return 'email is not valid.';
                    } else
                      return null;
                  },
                  textInputAction: TextInputAction.next,
                ),
              ),
              SizedBox(height: 20,),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: TextFormField(
                  controller: _firebaseController.passwordLog,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: Icon(Icons.lock_outline),
                      hintText: "Password",
                      contentPadding: EdgeInsets.all(20)
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value.toString().isEmpty) {
                      return 'password is not valid.';
                    } else if (value.toString().length <= 6) {
                      return "Password is to small";
                    } else
                      return null;
                  },
                  textInputAction: TextInputAction.done,
                ),
              ),
              SizedBox(height: 25,),
              ElevatedButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 25,vertical: 10)),
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                onPressed: (){
                  controller.logIn();
                },
                child: Text("Log In",style: TextStyle(color: Colors.black),),)
            ],
          ),
        ),
      ),
    );
  }
}
