import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/controller/firebase_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends GetWidget<FirebaseController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: Container(
            child: ListView(
              children: [
                Container(
                  color: Theme.of(context).primaryColor,
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white
                            ),
                            padding: EdgeInsets.all(35),
                          ),
                        ],
                      ),
                      SizedBox(height: 15,),
                         FutureBuilder<SharedPreferences>(
                           future: SharedPreferences.getInstance(),
                           builder: (context, snapshot) {
                             String name = "";
                             if(snapshot.hasData) {
                               final prefs = snapshot.data;
                               name = prefs?.getString("username")??"";
                             }
                             return Text("$name",style: TextStyle(color: Colors.white),);
                           }
                         ),
                      SizedBox(height: 10,),
                      FutureBuilder<SharedPreferences>(
                          future: SharedPreferences.getInstance(),
                        builder: (context, snapshot) {
                          String? email='';
                          if(snapshot.hasData){
                            final prefs = snapshot.data;
                            email = prefs?.getString("email")??"";
                            print(email);
                          }
                          return Text("$email",style: TextStyle(color: Colors.white),);
                        }
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.work),
                        title: Text("My Orders"),
                      ),
                      ListTile(
                        onTap: (){
                          controller.logOut();
                        },
                        leading: Icon(Icons.logout),
                        title: Text("Logout"),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        appBar: AppBar(

        ),
      ),
    );
  }
}
