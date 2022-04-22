import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  void Signup(email, password, name) async {
    final auth = FirebaseAuth.instance;
    UserCredential credential;
    try {
      credential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      String uid = credential.user!.uid;
      await FirebaseFirestore.instance.collection("user").doc(uid).set({
        'username':name,
        'email':email
      });
    }catch(e){
      Fluttertoast.showToast(msg: "$e");
    }
  }
}