import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils{

  static  toastMessage(String message, BuildContext context){

    Fluttertoast.showToast(
      msg: message ,
      backgroundColor: Colors.red,
      gravity: ToastGravity.TOP,
      toastLength: Toast.LENGTH_LONG,
      textColor: Colors.white,
    );

  }

// static void flushBarMessage(String message, BuildContext context){
//   showFlushbar(context: context,
//       flushbar: Flushbar(
//         flushbarPosition: FlushbarPosition.TOP,
//         forwardAnimationCurve: Curves.decelerate,
//         reverseAnimationCurve: Curves.easeInOut,
//         positionOffset: 20,
//         borderRadius: BorderRadius.circular(10),
//         icon: const Icon(Icons.check, color: Colors.green,),
//         margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
//         padding: const EdgeInsets.all(15),
//         message: message,
//         duration: Duration(seconds: 3),
//       )..show(context));}


}
DateTime? currentBackPressTime;
Future<bool> onWillPopExitApp() {
  DateTime now = DateTime.now();
  if (currentBackPressTime == null ||
      now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
    currentBackPressTime = now;
    Fluttertoast.showToast(msg: "Double tap to exit your app");
    return Future.value(false);
  }
  SystemNavigator.pop();
  return Future.value(false);
}