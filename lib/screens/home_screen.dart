import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/controller/firebase_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
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
                          FutureBuilder<SharedPreferences>(
                              future: SharedPreferences.getInstance(),
                              builder: (context, snapshot) {
                                String image = "";
                                if (snapshot.hasData) {
                                  final prefs = snapshot.data;
                                  image = prefs?.getString("imageURL") ?? "";
                                } else {
                                  image =
                                      "https://www.google.com/url?sa=i&url=https%3A%2F%2Fpixabay.com%2Fvectors%2Fblank-profile-picture-mystery-man-973460%2F&psig=AOvVaw08BxnnspnFPrJc5UaPZoOd&ust=1651401941406000&source=images&cd=vfe&ved=0CAwQjRxqFwoTCPCCj-PNu_cCFQAAAAAdAAAAABAO";
                                }
                                return Container(
                                  width: 100,
                                  child: Image.network(
                                    image,
                                    fit: BoxFit.fill,
                                  ),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white),
                                  padding: EdgeInsets.all(35),
                                );
                              }),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      FutureBuilder<SharedPreferences>(
                          future: SharedPreferences.getInstance(),
                          builder: (context, snapshot) {
                            String name = "";
                            if (snapshot.hasData) {
                              final prefs = snapshot.data;
                              name = prefs?.getString("username") ?? "";
                            }
                            return Text(
                              "$name",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            );
                          }),
                      SizedBox(
                        height: 10,
                      ),
                      FutureBuilder<SharedPreferences>(
                          future: SharedPreferences.getInstance(),
                          builder: (context, snapshot) {
                            String? email = '';
                            if (snapshot.hasData) {
                              final prefs = snapshot.data;
                              email = prefs?.getString("email") ?? "";
                              print(email);
                            }
                            return Text(
                              "$email",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            );
                          })
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
                        onTap: () {
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
          title: Center(child: Text("Book Store")),
          actions: [
            Stack(
              children: [
                Positioned(
                  top: 3,
                  left: 3,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.indigoAccent, shape: BoxShape.circle),
                    child: Text(
                      "3",
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                ),
                IconButton(onPressed: () {}, icon: Icon(Icons.shopping_cart))
              ],
            )
          ],
        ),
        body: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: 20,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  color: Colors.white70,
                  height: MediaQuery.of(context).size.height / 4,
                  child: Row(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 5,
                        width: MediaQuery.of(context).size.width / 4,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(17),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  spreadRadius: 0.1,
                                  offset: Offset(2, 2),
                                  blurRadius: 6)
                            ]),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 18),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Title",
                              style: TextStyle(
                                  fontSize: 17.5,
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red),
                                    child: Column(
                                      children: [
                                        Text("45%"),
                                        Text("off"),
                                      ],
                                    )),
                                SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "M.R.P.: ₹",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        Text(
                                          "775",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              decoration:
                                                  TextDecoration.lineThrough),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Price:",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        Text(
                                          "₹335",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(3.5),
                                  decoration: BoxDecoration(
                                      color: Colors.indigo,
                                      shape: BoxShape.circle),
                                ),
                                SizedBox(width: 4),
                                Text("420", style: TextStyle(color: Colors.grey),)
                              ],
                            ),
                            IconButton(onPressed: (){}, icon: Icon(Icons.add_shopping_cart_sharp,color: Colors.indigo,))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 0.75,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
