import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:neww/controllers/comman_dailog.dart';
import 'package:neww/view/landing.dart';
import 'package:neww/view/login.dart';

class AuthController extends GetxController {
  var userId;

  signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn(scopes: <String>["email"]).signIn();

    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // print(result);
    await FirebaseAuth.instance.signInWithCredential(credential);

    try {
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      print(userCredential);
    } catch (e) {}
    ;
  }

  Future<void> signUp(email, password, firstname, lastname) async {
    print('$email, $password');
    try {
      CommanDialog.showLoading();
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      print(userCredential);
      Get.back();
      try {
        CommanDialog.showLoading();
        var response = await FirebaseFirestore.instance.collection('userslist').add({
          'user_Id': userCredential.user!.uid,
          'first_name': firstname,
          'last_name': lastname,
          "password": password,
          'joinDate': DateTime.now().millisecondsSinceEpoch,
          'email': email
        });
        print("Firebase response1111 ${response.id}");
        CommanDialog.hideLoading();
        Get.back();
      } catch (exception) {
        CommanDialog.hideLoading();
        print("Error Saving Data at firestore $exception");
      }
    } on FirebaseAuthException catch (e) {
      Get.back();
      if (e.code == 'weak-password') {
        CommanDialog.showErrorDialog(description: "The password provided is too weak.");
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        CommanDialog.showErrorDialog(description: "The account already exists for that email.");
        print('The account already exists for that email.');
      }
    } catch (e) {
      Get.back();
      CommanDialog.hideLoading();
      CommanDialog.showErrorDialog(description: "Something Went Wrong");
      print(e);
    }
  }

  Future<void> login(email, password) async {
    print('$email, $password');
    try {
      CommanDialog.showLoading();
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.trim(), password: password);
      print(userCredential.user!.uid);
      userId = userCredential.user!.uid;
      CommanDialog.hideLoading();
      Get.off(() => const landing());
    } on FirebaseAuthException catch (e) {
      CommanDialog.hideLoading();
      if (e.code == 'user-not-found') {
        CommanDialog.showErrorDialog(description: "No user found for that email.");
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        CommanDialog.showErrorDialog(description: "Wrong password provided for that user.");
        print('Wrong password provided for that user.');
      }
    }
  }

  handleAuthState() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return landing();
        } else {
          return Login();
        }
      },
    );
  }

  signOutWithGoogle() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
