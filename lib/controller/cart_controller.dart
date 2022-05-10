import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

import '../modals/book.dart';
import 'firebase_controller.dart';

class CartController extends GetxController {
  final firebaseController = Get.find<FirebaseController>();
  List totalAmount = [].obs;

  void buyProduct(Book product, qty) async {
    await FirebaseFirestore.instance
        .collection("order")
        .doc(firebaseController.user)
        .collection("product")
        .doc(product.isbn)
        .set({
      'isbn': product.isbn,
      'title': product.title,
      'thumbnailUrl': product.thumbnailUrl,
      'shortDescription': product.shortDescription,
      'longDescription': product.longDescription,
      'uid': firebaseController.user,
      'MRP': product.MRP,
      'price': product.price,
      'status': product.status,
      'authors': product.authors,
      'categories': product.categories,
      'quntity': qty ?? 1
    }).then((value) => Get.snackbar("Order Place Successfully",
            "You have order this ${product.title} product",
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2)));
  }

  void cancelBuy(isbn,name) async {
    await FirebaseFirestore.instance
        .collection("order")
        .doc(firebaseController.user)
        .collection("product")
        .doc(isbn)
        .delete().then((value) => Get.snackbar(
        "Cancel Order Successfully", "You have successfully cancle this ${name} product order",
        snackPosition: SnackPosition.BOTTOM, duration: Duration(seconds: 2)));
  }

  void addProduct(Book product) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseController.user)
        .collection("Cart")
        .doc(product.isbn)
        .set({
      'title': product.title,
      'isbn': product.isbn,
      'pageCount': product.pageCount,
      'thumbnailUrl': product.thumbnailUrl,
      'publishedDate': product.publishedDate,
      'shortDescription': product.shortDescription,
      'longDescription': product.longDescription,
      'status': product.status,
      'authors': product.authors,
      'categories': product.categories,
      'MRP': product.MRP,
      'price': product.price,
      'uid': firebaseController.user,
      'quntity': 1
    });
    Get.snackbar(
        "Product Added", "You have added the ${product.title} to the cart",
        snackPosition: SnackPosition.BOTTOM, duration: Duration(seconds: 2));
  }

  void increseQty(isbn, qty) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseController.user)
        .collection("Cart")
        .doc(isbn)
        .update({'quntity': qty++});
  }

  void removeCart(Book product) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseController.user)
        .collection("Cart")
        .doc(product.isbn)
        .delete();
    Get.snackbar(
        "Remove From Cart", "You have remove the ${product.title} to the cart",
        snackPosition: SnackPosition.BOTTOM, duration: Duration(seconds: 2));
  }
}
