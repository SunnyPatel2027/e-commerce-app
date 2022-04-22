import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class LoginScreen extends StatelessWidget {
   LoginScreen({Key? key}) : super(key: key);
  final _formkey = GlobalKey<FormState>();
  var _email='';
  var _password='';
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Expanded(
        child: Container(
          padding: EdgeInsets.all(12),
          // width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height,
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
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
                SizedBox(height: 20,),
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
                    textInputAction: TextInputAction.done,
                  ),
                ),
                SizedBox(height: 25,),
                ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 25,vertical: 10)),
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  onPressed: (){},
                  child: Text("Log In",style: TextStyle(color: Colors.black),),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
