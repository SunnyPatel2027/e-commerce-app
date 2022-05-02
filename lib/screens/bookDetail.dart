import 'package:e_commerce/controller/firebase_controller.dart';
import 'package:e_commerce/modals/book.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookDetail extends StatelessWidget {
  final Book book;
   BookDetail( {Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseController controller = Get.find<FirebaseController>();
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: Container(
            child: ListView(
              children: [
                Container(
                  color: Colors.indigoAccent,
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
          backgroundColor: Colors.indigoAccent,
          title: Center(child: Text("Book Store")),
          actions: [
            Stack(
              children: [
                Positioned(
                  top: 3,
                  left: 3,
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        color: Colors.indigo, shape: BoxShape.circle),
                    child: Text(
                      "3",
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                ),
                IconButton(onPressed: () {}, icon: Icon(Icons.shopping_cart))
              ],
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  child: Text(
                    "${book.title}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigoAccent,
                        fontSize: 22),
                    // maxLines: ,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                      color: Colors.red.shade200,
                      borderRadius: BorderRadius.circular(25)),
                  child: Text(
                    "Even Rosten",
                    style: TextStyle(
                        color: Colors.red.shade600,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Stack(children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 15),
                    height: MediaQuery.of(context).size.height / 1.95,
                    decoration: BoxDecoration(
                        color: Colors.red.shade200,
                        borderRadius: BorderRadius.circular(25)),
                  ),
                  Positioned(
                    top: 0,
                    left: 10,
                    child: Container(
                        padding: EdgeInsets.all(7),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.red),
                        child: Column(
                          children: [
                            // ${(int.parse((book.price)) * 100 / int.parse((book.MRP))).toStringAsFixed(0)}
                            Text(
                              "45%",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text("off", style: TextStyle(color: Colors.white)),
                          ],
                        )),
                  ),
                ]),
                Row(
                  children: [
                    Text(
                      "M.R.P.: ₹",
                      style: TextStyle(color: Colors.black87),
                    ),
                    Text(
                      "500",
                      style: TextStyle(
                          color: Colors.black87,
                          decoration: TextDecoration.lineThrough),
                    ),
                  ],
                ),
                SizedBox(
                  height: 9,
                ),
                Row(
                  children: [
                    Text(
                      "Price:",
                      style: TextStyle(color: Colors.black87, fontSize: 14),
                    ),
                    Text(
                      " ₹250",
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Text(
                      "You save:",
                      style: TextStyle(color: Colors.black87, fontSize: 14),
                    ),
                    Text(
                      " ₹250",
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  height: 55,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                        Colors.yellow.shade200,
                        Colors.deepOrangeAccent
                      ])),
                  child: Center(
                      child: Text(
                    "Add to Cart",
                    style: TextStyle(fontWeight: FontWeight.w400),
                  )),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "About this Item",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 22),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  constraints: BoxConstraints(minHeight: 50),
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.5)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Description",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(height: 5,),
                      Text(
                          "This first book on the union of two rapidly growing approaches to programming--visual programming and object technology--provides a window on a subject of increasing commercial importance. It is an introduction and reference for cutting-edge developers, and for researchers, students, and enthusiasts interested in the design of visual OOP languages and environments.  Visual Object-Oriented Programming includes chapters on both emerging research and on a few classic systems, that together can help those who design visual object-oriented programming systems avoid some known pitfalls.",style: TextStyle(fontSize: 17,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,color: Colors.indigo.shade300))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
