import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/controller/cart_controller.dart';
import 'package:e_commerce/controller/firebase_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modals/book.dart';

class MyOrderScreen extends StatelessWidget {
  MyOrderScreen({Key? key}) : super(key: key);
  final firebaseController = Get.find<FirebaseController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.indigoAccent,
            centerTitle: true,
            title: Text("My Orders"),
          ),
          body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("order")
                .doc(firebaseController.user)
                .collection("product")
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              List<Book>? order;
              if (snapshot.hasData) {
                order = [];
                for (var element in snapshot.data.docs) {
                  order.add(Book.fromJson(element.data()));
                }
              }
              return order == null
                  ? Container()
                  : Container(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: ListView.builder(
                      itemCount: order.length,
                      itemBuilder: (context, index) {
                        return OrderCartProducts(
                          product: order!.toList()[index],
                          index: index,
                        );
                      }),
                ),
              );
            },
          ),
        ));
  }
}

class OrderCartProducts extends StatelessWidget {
  final Book product;
  final int index;
   OrderCartProducts({Key? key, required this.product, required this.index,}) : super(key: key);
  final cartController = Get.find<CartController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      color: Colors.white10,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(17),
            child: Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 5,
              width: MediaQuery
                  .of(context)
                  .size
                  .width / 4,
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 0.1,
                    offset: Offset(2, 2),
                    blurRadius: 6)
              ]),
              child: Image.network(
                '${product.thumbnailUrl}',
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.broken_image_outlined),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding:
              EdgeInsets.only(right: 10, left: 10, top: 15, bottom: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.title,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 17.5,
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(onPressed: (){
                        cartController.cancelBuy(product.isbn,product.title);
                      }, icon: Icon(Icons.delete_forever_sharp,size: 30,color: Colors.redAccent,)),

                    ],
                  ),
                  SizedBox(height: 5,),
                  Text(
                   "Quntity: ${ product.quntity.toString()}",
                    style: TextStyle(
                        fontSize: 17.5,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8,),
                  Text(
                    "price: ${ product.price}",
                    style: TextStyle(
                        fontSize: 17.5,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Total Amount: ",
                        style: TextStyle(
                            fontSize: 17.5,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      Text("${(int.parse(product.price)).toString()}",style: TextStyle(
                          fontSize: 17.5,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold),),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

