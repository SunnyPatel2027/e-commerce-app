import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/screens/auth/auth_screen.dart';
import 'package:e_commerce/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../books.dart';

class FirebaseController extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  late final TextEditingController email = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController emailLog = TextEditingController();
  final TextEditingController passwordLog = TextEditingController();
  Rxn<XFile?> photo = Rxn<XFile?>();

  Rxn<User> _firebaseUser = Rxn<User>();
  String downloadURL = '';

  String? get user => _firebaseUser.value?.uid;

  @override
  // ignore: must_call_super
  void onInit() {
    _firebaseUser.bindStream(_auth.authStateChanges());
  }

  void dataUpload() async{
    for(var item in books){
      var price = 200+Random().nextInt(1000);
      var mrp =Random().nextInt(price)+price;
      await FirebaseFirestore.instance.collection("books").doc(item["isbn"]).set({
        'title' : item["title"],
        'pageCount' : item["pageCount"],
        'publishedDate' : item["publishedDate"]["date"],
        'thumbnailUrl' : item["thumbnailUrl"],
        'shortDescription' : item["shortDescription"],
        'longDescription' : item["longDescription"],
        'status' : item["status"],
        'authors' : item["authors"],
        'categories' : item["categories"],
        'price' : price.toString(),
        'MRP' : mrp.toString(),
        "isbn" : item['isbn']
      });
      print("Data Upload Successfully.");
    }
  }



  void createUser() async {
    await _auth
        .createUserWithEmailAndPassword(
            email: email.text, password: password.text)
        .then((value) async {
      String? uid = _auth.currentUser?.uid;
      print(uid);
      if(photo.value != null) {
        final strongRef = FirebaseStorage.instance.ref().child("$uid.png");
        await strongRef.putFile(File(photo.value!.path));
        downloadURL = await strongRef.getDownloadURL();
      }
      await FirebaseFirestore.instance.collection("users").doc(uid).set({
        'username': name.text,
        'email': email.text,
        'uid': uid.toString(),
        'imageURL': downloadURL
      });

      await getUserDetails();
      Get.offAll(HomeScreen());
      email.text = '';
      password.text = '';
      name.text = '';
    }).catchError(
            (e) => Get.snackbar("Error while create account.", e.message));

    // await getUserDetails();
  }

  void logIn() async {
    await _auth
        .signInWithEmailAndPassword(
            email: emailLog.text, password: passwordLog.text)
        .then((value) async {
      Get.offAll(HomeScreen());
      await getUserDetails();
      emailLog.text = '';
      passwordLog.text = '';
    }).catchError((e) => Get.snackbar("Error while LogIn.", e.message));
  }

  void logOut() async {
    await _auth.signOut().then((value) => Get.offAll(AuthScreen()));
  }

  Future<void> getUserDetails() async {
    String? uid = _auth.currentUser?.uid;
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    print(uid);
    Map data = snapshot.data() as Map;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("username", data["username"]);
    await prefs.setString("email", data["email"]);
    await prefs.setString("imageURL", data["imageURL"]);
  }
}
