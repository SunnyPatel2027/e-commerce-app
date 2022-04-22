import 'package:e_commerce/screens/auth/signup/signup_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../login/login_screen.dart';
import 'login/login_screen.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: Text("Book Store"),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.lock),
                text: "Login",
              ),
              Tab(
                icon: Icon(Icons.person),
                text: "Register",
              )
            ],
            indicatorColor: Colors.red,
            indicatorWeight: 5,
          ),
        ),
        body: TabBarView(children: [
          LoginScreen(),
          SignUpScreen(),

        ]),
      ),
    );
  }
}
