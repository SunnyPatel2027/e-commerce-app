import 'package:e_commerce/screens/auth/signup/signup_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SignUpScreen extends StatelessWidget {
   SignUpScreen({Key? key}) : super(key: key);

   final _formkey = GlobalKey<FormState>();
   var _name='';
   var _email= '';
   var _password='';
   var _confirmPass='';

   @override
  Widget build(BuildContext context) {

     final signupCtr = Get.put(SignupController());
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(12),
        width: MediaQuery.of(context).size.width,
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
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: Colors.white,
                    filled: true,
                    prefixIcon: Icon(Icons.person),
                    hintText: "Name",
                    contentPadding: EdgeInsets.all(20)
                ),
                key: ValueKey("name"),
                validator: (value) {
                  if (value.toString().isEmpty) {
                    return 'Enter name.';
                  } else
                    return null;
                },
                onSaved: (value){
                  _name = value!;
                },
                textInputAction: TextInputAction.next,
              ),
            ),
            SizedBox(height: 15,),
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
                key: ValueKey("email"),
                validator: (value) {
                  if (value.toString().isEmpty ||
                      !value.toString().contains("@gmail.com")) {
                    return 'email is not valid.';
                  } else
                    return null;
                },
                onSaved: (value){
                  _email = value!;
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
                    hintText: "Password",
                    contentPadding: EdgeInsets.all(20)
                ),
                key: ValueKey("passeord"),
                obscureText: true,
                validator: (value) {
                  if (value.toString().isEmpty) {
                    return 'password is not valid.';
                  } else if (value.toString().length <= 6) {
                    return "Password is to small";
                  } else
                    return null;
                },
                onSaved: (value){
                  _password = value!;
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
                key: ValueKey("confirm passeord"),
                obscureText: true,
                validator: (value) {
                  if (value.toString().isEmpty) {
                    return 'Enter confirm password.';
                  } else if (value.toString()!=_password) {
                    return "Does not match password.";
                  } else
                    return null;
                },
                onSaved: (value){
                  _confirmPass = value!;
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
                final validity = _formkey.currentState!.validate();
                if(validity){
                  _formkey.currentState!.save();
                  signupCtr.Signup(_email, _password, _name);
                }
              },
              child: Text("Sign up",style: TextStyle(color: Colors.black),),)
          ],
        ),
      ),
    );
  }
}
