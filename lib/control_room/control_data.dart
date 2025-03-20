import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:travel_app/control_room/firebase_reference.dart';
import 'package:travel_app/routers/go_router.dart';
import 'package:travel_app/screens/HomeScreen.dart';
import 'package:travel_app/screens/auth/login_screen.dart';

import '../uitlity/CommanDialog.dart';
import '../uitlity/Sessions.dart';
import '../uitlity/Utils.dart';

class DataController extends GetxController {
  /// Firebase Reference
  FirebaseAuth auth = FirebaseAuth.instance;

  // Reactive variables
  final Rx<User?> firebaseUser = Rx<User?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    print("DataController onInit called");
    // Initialize user
    firebaseUser.value = auth.currentUser;

    // Listen for auth changes
    auth.authStateChanges().listen((User? user) {
      firebaseUser.value = user;
      print("Auth state changed: ${user?.uid ?? 'No user'}");

      // Update login status in shared preferences
      _updateLoginStatus(user != null);
    });
  }

  // Private method to update login status
  Future<void> _updateLoginStatus(bool isLoggedIn) async {
    try {
      await AppRouter.setLoggedIn(isLoggedIn);
    } catch (e) {
      print("Error updating login status: $e");
    }
  }

  Widget checkUser() {
    if (firebaseUser.value != null) {
      return HomeScreen();
    } else {
      return LoginScreen();
    }
  }

  Future<void> register({
    String? email,
    String? password,
    String? name,
    required BuildContext context,
  }) async {
    isLoading.value = true;
    CommanDialog.showLoading(context: context);

    try {
      final userCredential = await FirebaseReference()
          .auth
          .createUserWithEmailAndPassword(
              email: email.toString(), password: password.toString());

      SessionControler().userId = userCredential.user!.uid;

      await FirebaseReference().userDetail.doc(userCredential.user!.uid).set({
        'name': name.toString(),
        'email': email.toString(),
        'userId': userCredential.user!.uid,
        'Time': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        'Date':
            "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      });

      // Update login status
      await _updateLoginStatus(true);

      // Complete first launch
      await AppRouter.completeFirstLaunch();

      CommanDialog.hideLoading(context);
      isLoading.value = false;
      context.go('/'); // Use GoRouter
      Utils.toastMessage("Account Created Successfully", context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        CommanDialog.hideLoading(context);
        isLoading.value = false;
        Utils.toastMessage("Email already in use. Moving to login.", context);
        context.go('/login'); // Use GoRouter
      } else {
        handleAuthError(e, context);
      }
    } catch (e) {
      CommanDialog.hideLoading(context);
      isLoading.value = false;
      Utils.toastMessage(e.toString(), context);
      print("Registration error: $e");
    }
  }

  Future<void> login({
    String? email,
    String? password,
    required BuildContext context,
  }) async {
    isLoading.value = true;
    CommanDialog.showLoading(context: context);

    try {
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email.toString(),
        password: password.toString(),
      );

      SessionControler().userId = userCredential.user!.uid;

      // Update last login time
      await FirebaseReference()
          .userDetail
          .doc(userCredential.user!.uid)
          .update({
        'lastLogin': DateTime.now().millisecondsSinceEpoch,
      });

      // Update login status
      await _updateLoginStatus(true);

      CommanDialog.hideLoading(context);
      isLoading.value = false;
      context.go('/'); // Use GoRouter
    } on FirebaseAuthException catch (e) {
      handleAuthError(e, context);
    } catch (e) {
      CommanDialog.hideLoading(context);
      isLoading.value = false;
      Utils.toastMessage(e.toString(), context);
    }
  }

  Future<void> forgotPassword(String email, BuildContext context) async {
    isLoading.value = true;
    CommanDialog.showLoading(context: context);

    try {
      await auth.sendPasswordResetEmail(email: email);
      CommanDialog.hideLoading(context);
      isLoading.value = false;
      Utils.toastMessage("Password reset email sent", context);
    } on FirebaseAuthException catch (e) {
      handleAuthError(e, context);
    } catch (e) {
      CommanDialog.hideLoading(context);
      isLoading.value = false;
      Utils.toastMessage(e.toString(), context);
    }
  }

  void handleAuthError(FirebaseAuthException e, BuildContext context) {
    CommanDialog.hideLoading(context);
    isLoading.value = false;

    switch (e.code) {
      case 'weak-password':
        Utils.toastMessage("The password provided is too weak.", context);
        break;
      case 'email-already-in-use':
        Utils.toastMessage(
            "An account already exists for that email.", context);
        break;
      case 'user-not-found':
        Utils.toastMessage("No user found for that email.", context);
        break;
      case 'wrong-password':
        Utils.toastMessage("Incorrect password. Please try again.", context);
        break;
      case 'invalid-email':
        Utils.toastMessage("The email address is not valid.", context);
        break;
      case 'user-disabled':
        Utils.toastMessage("This user account has been disabled.", context);
        break;
      case 'too-many-requests':
        Utils.toastMessage("Too many requests. Try again later.", context);
        break;
      default:
        Utils.toastMessage("Authentication error: ${e.message}", context);
    }
  }

  /// Logout User
  Future<void> signOut(BuildContext context) async {
    try {
      isLoading.value = true;

      // Update login status before clearing session
      await _updateLoginStatus(false);

      await SessionControler().clear();
      await auth.signOut();

      isLoading.value = false;

      // Navigate to login screen
      context.go('/login'); // Use GoRouter
    } catch (e) {
      isLoading.value = false;
      Utils.toastMessage(e.toString(), context);
      print("Sign out error: $e");
    }
  }
}
