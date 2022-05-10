import 'package:e_commerce/controller/cart_controller.dart';
import 'package:e_commerce/controller/firebase_controller.dart';
import 'package:e_commerce/modals/book.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'addToCart_screen.dart';
import 'my_order_screen.dart';

class BookDetail extends StatefulWidget {
  final Book book;
  final bool isCart;
  var qty;

  BookDetail({Key? key, required this.book, required this.isCart, this.qty})
      : super(key: key);

  @override
  State<BookDetail> createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  var _razorpay = Razorpay();

  FirebaseController firebasecontroller = Get.find<FirebaseController>();
  CartController cartController = Get.find<CartController>();

  @override
  void initState() {
    // TODO: implement initState
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }


  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    Get.snackbar("success", "Pay ment succeeds",snackPosition: SnackPosition.BOTTOM,duration: Duration(seconds: 2));
    cartController.buyProduct(widget.book, widget.qty);
      cartController.removeCart(widget.book);
      Get.back();

  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    Get.snackbar("Payment fails",'Something want wrong',snackPosition: SnackPosition.BOTTOM,duration: Duration(seconds: 2));

  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
    Get.snackbar("Extrnal Wallet was selected", "${response}",snackPosition: SnackPosition.BOTTOM,duration: Duration(seconds: 2));

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear();
  }
  String name = "";
  String? email = '';
  @override
  Widget build(BuildContext context) {
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
                        onTap: () {
                          Get.to(MyOrderScreen());
                        },
                        leading: Icon(Icons.work),
                        title: Text("My Orders"),
                      ),
                      ListTile(
                        onTap: () {
                          firebasecontroller.logOut();
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
          title: Center(child: Text("Book Details")),
          actions: [
            Stack(
              children: [
                IconButton(
                    onPressed: () {
                      Get.to(AddToCartScreen());
                    },
                    icon: Icon(Icons.shopping_cart)),
                Obx(() {
                  return StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc(firebasecontroller.user)
                          .collection("Cart")
                          .snapshots(),
                      builder: (context, AsyncSnapshot snapshot) {
                        List count = [];
                        if (snapshot.hasData) {
                          for (var element in snapshot.data!.docs) {
                            count.add(Book.fromJson(element.data()));
                          }
                        }
                        return count.length == 0
                            ? Container()
                            : Positioned(
                                top: 3,
                                left: 3,
                                child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Colors.indigo,
                                        shape: BoxShape.circle),
                                    child: Text(
                                      "${(count.length)}",
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.white),
                                    )),
                              );
                      });
                }),
              ],
            )
          ],
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                        onTap: () => Get.back(),
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 25,
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        // width: double.infinity,
                        child: Text(
                          "${widget.book.title}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.indigoAccent,
                              fontSize: 24),
                          // maxLines: ,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Wrap(
                  children: widget.book.authors
                      .map((e) => e.isEmpty
                          ? SizedBox()
                          : Container(
                              margin: EdgeInsets.all(2),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              decoration: BoxDecoration(
                                  color: Colors.red.shade200,
                                  borderRadius: BorderRadius.circular(25)),
                              child: Text(
                                "$e",
                                style: TextStyle(
                                    color: Colors.red.shade600,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            ))
                      .toList(),
                ),
                SizedBox(
                  height: 10,
                ),
                Stack(children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 15),
                    height: MediaQuery.of(context).size.height / 1.95,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        // color: Colors.red.shade200,
                        borderRadius: BorderRadius.circular(25)),
                    child: widget.book.thumbnailUrl == null
                        ? Center(
                            child: Icon(
                            Icons.broken_image_outlined,
                            size: 80,
                          ))
                        : Image.network(
                            widget.book.thumbnailUrl.toString(),
                            fit: BoxFit.fill,
                          ),
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
                              "${(int.parse(widget.book.price) * 100 / int.parse(widget.book.MRP)).toStringAsFixed(0)}%",
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
                      "${widget.book.MRP}",
                      style: TextStyle(
                          color: Colors.black87,
                          decoration: TextDecoration.lineThrough),
                    ),
                  ],
                ),
                SizedBox(
                  height: 9,
                ),
                widget.isCart == true
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Price:",
                                style: TextStyle(
                                    color: Colors.black87, fontSize: 14),
                              ),
                              Text(
                                " ₹${widget.book.price}",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 18),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Quntity:",
                                style: TextStyle(
                                    color: Colors.black87, fontSize: 14),
                              ),
                              Text(
                                " ${widget.qty}",
                                style: TextStyle(
                                    color: Colors.redAccent, fontSize: 18),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Text(
                            "Price:",
                            style:
                                TextStyle(color: Colors.black87, fontSize: 14),
                          ),
                          Text(
                            " ₹${widget.book.price}",
                            style: TextStyle(color: Colors.red, fontSize: 18),
                          ),
                        ],
                      ),
                SizedBox(
                  height: 8,
                ),
                widget.isCart == true
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Total Amount:",
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                " ₹${int.parse(widget.book.price) * widget.qty}",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "You save:",
                                style: TextStyle(
                                    color: Colors.black87, fontSize: 14),
                              ),
                              Text(
                                " ₹${int.parse(widget.book.MRP) - int.parse(widget.book.price)}",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 15),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Text(
                            "You save:",
                            style:
                                TextStyle(color: Colors.black87, fontSize: 14),
                          ),
                          Text(
                            " ₹${int.parse(widget.book.MRP) - int.parse(widget.book.price)}",
                            style: TextStyle(color: Colors.red, fontSize: 18),
                          ),
                        ],
                      ),
                SizedBox(
                  height: 8,
                ),
                widget.isCart == true
                    ? GestureDetector(
                        onTap: () async {
                          print("name : $name , email : $email");
                          var options = {
                            'key': 'rzp_test_FzBmDEtXgnmbJK',
                            'amount': ((widget.qty*int.parse(widget.book.price))*100).toString(),
                            'name': '$name',
                            'description': '',
                            'prefill': {
                              'contact': '',
                              'email': '$email'
                            }
                          };
                          _razorpay.open(options);
                        },
                        child: Container(
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
                            "Buy Now",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          )),
                        ),
                      )
                    : StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("order")
                            .doc(firebasecontroller.user)
                            .collection("product")
                            .snapshots(),
                        builder: (context, AsyncSnapshot snapshot) {
                          List doc = [];
                          if (snapshot.hasData) {
                            snapshot.data.docs.forEach((field) {
                              String id = (field.data()! as Map)["isbn"];
                              doc.add(id);
                            });
                            print(doc);
                          }
                          return doc.contains(widget.book.isbn)
                              ? SizedBox()
                              : Column(
                                  children: [
                                    doc.contains(widget.book.isbn)?SizedBox():
                                    GestureDetector(
                                      onTap: () async {
                                        List productName = [];
                                        QuerySnapshot data =
                                            await FirebaseFirestore
                                                .instance
                                                .collection("users")
                                                .doc(firebasecontroller.user)
                                                .collection("Cart")
                                                .where("isbn",
                                                    isEqualTo: widget.book.isbn)
                                                .get();
                                        data.docs.forEach((field) {
                                          String id =
                                              (field.data()! as Map)["isbn"];
                                          productName.add(id);
                                        });
                                        print("productName $productName");
                                        if (productName.contains(widget.book.isbn)) {
                                          Get.snackbar("ALREADY ADDED",
                                              "You already add this product.",
                                              snackPosition:
                                                  SnackPosition.BOTTOM);
                                        } else {
                                          cartController.addProduct(widget.book);
                                        }
                                      },
                                      child: Container(
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
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18),
                                        )),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        var options = {
                                          'key': 'rzp_test_FzBmDEtXgnmbJK',
                                          'amount': ((int.parse(widget.book.price))*100).toString(),
                                          'name': '$name',
                                          'description': '',
                                          'prefill': {
                                            'contact': '',
                                            'email': '$email'
                                          }
                                        };
                                        _razorpay.open(options);
                                      },
                                      child: Container(
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
                                          "Buy Now",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18),
                                        )),
                                      ),
                                    )
                                  ],
                                );
                        }),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "About This Item",
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
                      SizedBox(
                        height: 5,
                      ),
                      Text("${widget.book.longDescription}",
                          style: TextStyle(
                              fontSize: 17,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo.shade300))
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
