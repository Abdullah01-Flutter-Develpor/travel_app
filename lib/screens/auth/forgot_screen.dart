import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_app/component/app_button.dart';
import 'package:travel_app/component/app_colors.dart';
import 'package:travel_app/component/app_images.dart';
import 'package:travel_app/component/text_field.dart';
import 'package:travel_app/control_room/control_data.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final DataController dataController = Get.put(DataController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscuresText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.whiteColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              Image.asset(appImages.logo),
              Text(
                "Forgot Your Password",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 20,
              ),
              customTextField(
                obscureText: false,
                labelText: "Enter Email",
                prefixIcon: Icon(
                  Icons.email,
                  size: 23,
                ),
                Controller: emailController,
              ),
              SizedBox(
                height: 20,
              ),
              appButton(
                title: "Forgot",
                onPressed: () {
                  dataController.forgotPassword(
                      emailController.text.toString(), context);
                },
                loading: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  obscuresTexts() {
    obscuresText = !obscuresText;
    setState(() {});
  }
}
