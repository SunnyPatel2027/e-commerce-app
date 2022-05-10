import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/controller/cart_controller.dart';
import 'package:e_commerce/controller/firebase_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../modals/book.dart';
import 'bookDetail.dart';

class AddToCartScreen extends StatelessWidget {
  AddToCartScreen({Key? key}) : super(key: key);
  final cartController = Get.find<CartController>();
  final firebaseController = Get.find<FirebaseController>();

  @override
  Widget build(BuildContext context) {
    List totalAmount = [];
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        centerTitle: true,
        title: Text("Add to cart"),
      ),
      body: Obx(() {
        return StreamBuilder<Object>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(firebaseController.user)
                .collection("Cart")
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              List<Book>? products;
              if (snapshot.hasData) {
                products = [];
                for (var element in snapshot.data!.docs) {
                  products.add(Book.fromJson(element.data()));
                }
                ;
              }
              return products == null
                  ? Container()
                  : Column(
                      children: [
                        Expanded(
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: ListView.builder(
                                  itemCount: products.length,
                                  itemBuilder: (context, index) {
                                    return CartProductCard(
                                        controller: cartController,
                                        product: products!.toList()[index],
                                        index: index,
                                        totalAmount: totalAmount);
                                  }),
                            ),
                          ),
                        ),

                      ],
                    );
            });
      }),
    ));
  }
}

class CartProductCard extends StatefulWidget {
  final CartController controller;
  final Book product;
  final index;
  final List totalAmount;

  CartProductCard(
      {Key? key,
      required this.controller,
      required this.product,
      this.index,
      required this.totalAmount})
      : super(key: key);

  @override
  State<CartProductCard> createState() => _CartProductCardState();
}

class _CartProductCardState extends State<CartProductCard> {
  final cartController = Get.find<CartController>();

  final firebaseController = Get.find<FirebaseController>();

  @override
  Widget build(BuildContext context) {
    var qty = 1;
    bool isCart = true;
    var amount = widget.product.price;

    return GestureDetector(
      onTap: () {
        Get.to(BookDetail(book: widget.product, isCart: isCart, qty: qty));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        color: Colors.white70,
        height: MediaQuery.of(context).size.height / 4,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(17),
              child: Container(
                height: MediaQuery.of(context).size.height / 5,
                width: MediaQuery.of(context).size.width / 4,
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 0.1,
                      offset: Offset(2, 2),
                      blurRadius: 6)
                ]),
                child: Image.network(
                  '${widget.product.thumbnailUrl}',
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.title,
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: 17.5,
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Container(
                            padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.red),
                            child: Column(
                              children: [
                                Text(
                                  "${(int.parse((widget.product.price)) * 100 / int.parse((widget.product.MRP))).toStringAsFixed(0)}%",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text("off",
                                    style: TextStyle(color: Colors.white)),
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
                                  "${widget.product.MRP}",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
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
                                      "${widget.product.pageCount}",
                                      style: TextStyle(color: Colors.grey),
                                    )
                                  ],
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
                                  "₹${widget.product.price}",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    StatefulBuilder(
                      builder: (context, setState) => Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Amount :${qty * int.parse(widget.product.price)}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  qty++;
                                  amount = (qty*int.parse(widget.product.price)).toString();
                                  widget.totalAmount.add(amount);
                                });

                                cartController.increseQty(widget.product.isbn,
                                    widget.product.quntity);
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Icon(Icons.add_circle_outlined),
                              ),
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            Text(
                              "${qty}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (qty == 1) {
                                    qty = 1;
                                  } else {
                                    --qty;
                                  }

                                  amount = (qty*int.parse(widget.product.price)).toString();
                                  widget.totalAmount.add(amount);
                                });
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Icon(Icons.remove_circle_outlined),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () async {
                                cartController.removeCart(widget.product);
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child:
                                    Icon(Icons.remove_shopping_cart_outlined),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
