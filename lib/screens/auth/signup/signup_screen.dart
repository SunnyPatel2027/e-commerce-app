import 'package:e_commerce/controller/firebase_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SignUpScreen extends GetWidget<FirebaseController> {
   SignUpScreen({Key? key}) : super(key: key);

   final _formkey = GlobalKey<FormState>();
  // final TextEditingController _email = TextEditingController();
  //  final TextEditingController _name = TextEditingController();
  //  final TextEditingController _password = TextEditingController();
  FirebaseController _firebaseController = Get.put(FirebaseController());
   @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(12),
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){},
                child: Container(
                  child: Icon(Icons.person_add,color: Colors.grey,size: 50,),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100)
                  ),
                  padding: EdgeInsets.all(30),
                ),
              ),
              SizedBox(height: 15,),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: TextFormField(
                  controller: _firebaseController.name,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: Icon(Icons.person),
                      hintText: "Name",
                      contentPadding: EdgeInsets.all(20)
                  ),
                  validator: (value) {
                    if (value.toString().isEmpty) {
                      return 'Enter name.';
                    } else
                      return null;
                  },
                  textInputAction: TextInputAction.next,
                ),
              ),
              SizedBox(height: 15,),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: TextFormField(
                  controller: _firebaseController.email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: Icon(Icons.person),
                      hintText: "Email",
                      contentPadding: EdgeInsets.all(20)
                  ),
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
              SizedBox(height: 15,),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: TextFormField(
                  controller: _firebaseController.password,
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

                  textInputAction: TextInputAction.next,
                ),
              ),
              SizedBox(height: 15,),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: Icon(Icons.lock_outline),
                      hintText: "Confirm Password",
                      contentPadding: EdgeInsets.all(20)
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value.toString().isEmpty) {
                      return 'Enter confirm password.';
                    } else if (value.toString()!=_firebaseController.password.text) {
                      return "Does not match password.";
                    } else
                      return null;
                  },
                  textInputAction: TextInputAction.done,
                ),
              ),
              SizedBox(height: 15,),
              ElevatedButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 25,vertical: 10)),
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                onPressed: (){
                  final validity =_formkey.currentState!.validate();
                  FocusScope.of(context).unfocus();
                  if(validity){
                    _firebaseController.createUser();
                  }
                },
                child: Text("Sign up",style: TextStyle(color: Colors.black),),)
            ],
          ),
        ),
      ),
    );
  }
}
