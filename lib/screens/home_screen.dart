import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/controller/firebase_controller.dart';
import 'package:e_commerce/controller/listController.dart';
import 'package:e_commerce/modals/book.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bookDetail.dart';

class HomeScreen extends GetWidget<FirebaseController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ListController listController= Get.put<ListController>(ListController());
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
                                }
                                return Container(
                                  width: 100,
                                  child: image.isEmpty?Icon(Icons.person):Image.network(
                                    image,
                                    fit: BoxFit.fill,
                                  ),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white),
                                  padding: EdgeInsets.all(30),
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
            // IconButton(onPressed: (){
            //   controller.dataUpload();
            // }, icon: Icon(Icons.upload_file)),
            Stack(
              children: [
                Positioned(
                  top: 3,
                  left: 3,
                  child: Container(
                    padding: EdgeInsets.all(5),
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
          bottom:
          PreferredSize(preferredSize: Size(double.infinity,65),
            child:  Padding(
              padding: const EdgeInsets.only(right: 20.0,left: 20.0,bottom: 15.0,top:1),
              child: TextField(
                onChanged: (value){
                  listController.searchBook(value);
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Icon(Icons.search),
                  hintText: "Search here",
                  contentPadding: EdgeInsets.all(15),
                ),
              ),
            )
            ),),
        body: FutureBuilder<Object>(
            future: FirebaseFirestore.instance.collection("books").get(),
            builder: (context, AsyncSnapshot snapshot) {
              List<Book>? list;
              if (snapshot.hasData) {
                list = [];
                for (var element in snapshot.data.docs) {
                  list.add(Book.fromJson(element.data()));
                }
                listController.lists = list;
                listController.searching.value = list;
              }
              return list == null
                  ? Center(child: CircularProgressIndicator())
                  : Obx(() {
                      return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: listController.searching.value.length,
                          itemBuilder: (context, index) {
                            Book book = listController.searching.value[index];
                            return GestureDetector(
                              onTap: (){
                                Get.to(BookDetail(book: book));
                              },
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(20),
                                    color: Colors.white70,
                                    height: MediaQuery.of(context).size.height / 4,
                                    child: Row(
                                      children: [
                                        Container(
                                          height:
                                              MediaQuery.of(context).size.height / 5,
                                          width:
                                              MediaQuery.of(context).size.width / 4,
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
                                          child: Image.network(
                                            '${book.thumbnailUrl}',
                                            fit: BoxFit.fill,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Icon(Icons.broken_image_outlined),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 18),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  book.title,
                                                  maxLines: 2,
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
                                                        padding: EdgeInsets.all(7),
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: Colors.red),
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                                "${(int.parse((book.price)) * 100 / int.parse((book.MRP))).toStringAsFixed(0)}%",style: TextStyle(color: Colors.white),),
                                                            Text("off",style: TextStyle(color: Colors.white)),
                                                          ],
                                                        )),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "M.R.P.: ₹",
                                                              style: TextStyle(
                                                                  color: Colors.grey),
                                                            ),
                                                            Text(
                                                              "${book.MRP}",
                                                              style: TextStyle(
                                                                  color: Colors.grey,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough),
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
                                                              style: TextStyle(
                                                                  color: Colors.grey),
                                                            ),
                                                            Text(
                                                              "₹${book.price}",
                                                              style: TextStyle(
                                                                  color: Colors.red),
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
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 0, vertical: 15),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
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
                                                  Text(
                                                    "${book.pageCount}",
                                                    style:
                                                        TextStyle(color: Colors.grey),
                                                  )
                                                ],
                                              ),
                                              IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(
                                                    Icons.add_shopping_cart_sharp,
                                                    color: Colors.indigo,
                                                  ))
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
                              ),
                            );
                          },
                        );
                    }
                  );
            }),
      ),
    );
  }
}
