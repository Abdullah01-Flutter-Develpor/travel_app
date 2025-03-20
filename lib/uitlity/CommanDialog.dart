import 'package:flutter/material.dart';

class CommanDialog {
  static void showLoading(
      {String title = "Loading...", required BuildContext context}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              height: 40,
              child: Row(
                children: [
                  SizedBox(width: 20),
                  Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                  SizedBox(width: 20),
                  Text(title),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void hideLoading(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      try {
        Navigator.of(context).pop();
      } catch (e) {
        print('Error popping dialog: $e');
      }
    } else {
      print('Cannot pop dialog: Navigator stack is empty.');
    }
  }

  static void showErrorDialog({
    required BuildContext context,
    String title = "Oops Error",
    String description = "Something went wrong",
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                SizedBox(height: 10),
                Text(
                  description,
                  style: TextStyle(fontSize: 16),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Okay"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
