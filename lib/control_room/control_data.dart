// ignore_for_file: unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:travel_app/control_room/firebase_reference.dart';
import 'package:travel_app/screens/HomeScreen.dart';
import 'package:travel_app/screens/auth/login_screen.dart';

import '../uitlity/CommanDialog.dart';
import '../uitlity/Sessions.dart';
import '../uitlity/Utils.dart';

class DataController extends GetxController {
  /// Firebase Reference

  FirebaseAuth auth = FirebaseAuth.instance;

  checkUser() {
    if (auth.currentUser != null) {
      return HomeScreen();
    } else {
      return LoginScreen();
    }
  }

  void register(
      {String? email, password, name, required BuildContext context}) async {
    CommanDialog.showLoading();
    try {
      final user = await FirebaseReference()
          .auth
          .createUserWithEmailAndPassword(
              email: email.toString(), password: password)
          .then((value) {
        SessionControler().userId = value.user!.uid.toString();
        // auth.currentUser!.sendEmailVerification();
        FirebaseReference().userDetail.doc(value.user!.uid).set({
          'name': name.toString(),
          'email': email.toString(),
          'userId': value.user!.uid.toString(),
          'Time': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
          'Date':
              "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
        }).then((value) {
          CommanDialog.hideLoading();
          Get.off(HomeScreen());
          Utils.toastMessage("Account Create Successfully", context);
        });
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        CommanDialog.hideLoading();

        Utils.toastMessage("Password Weak", context);
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        CommanDialog.hideLoading();

        Utils.toastMessage(
            "The account already exists on your device.", context);
        print('The account already exists for that email.');
      }
    } catch (e) {
      Utils.toastMessage(e.toString(), context);
      print(e);
    }
  }

  void login(
      {String? email, String? password, required BuildContext context}) async {
    CommanDialog.showLoading();

    try {
      final user = await auth
          .signInWithEmailAndPassword(
              email: email.toString(), password: password.toString())
          .then((value) {
        SessionControler().userId = value.user!.uid.toString();
        CommanDialog.hideLoading();
        Get.off(HomeScreen());
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        CommanDialog.hideLoading();
        Utils.toastMessage('No user found for that email.', context);
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        CommanDialog.hideLoading();
        Utils.toastMessage('Wrong password Please try again.', context);
        print('Wrong password provided for that user.');
      }
    }
  }

  void forgotPassword(String email, BuildContext context) {
    try {
      auth.sendPasswordResetEmail(email: email.toString()).then((value) {
        Get.back();
        Utils.toastMessage(
            'Forgot email has been send please check your email', context);
      });
    } catch (e) {
      Utils.toastMessage(e.toString(), context);
    }
  }

  /// Logout User
  void signOut() async {
    await auth.signOut();
  }
}
