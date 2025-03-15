// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travel_app/component/app_button.dart';
import 'package:travel_app/component/app_colors.dart';
import 'package:travel_app/component/app_images.dart';
import 'package:travel_app/component/text_field.dart';
import 'package:travel_app/component/text_style.dart';
import 'package:travel_app/control_room/control_data.dart';
import 'package:travel_app/screens/auth/signup_screen.dart';
import 'package:travel_app/uitlity/validatetion.dart';

import 'forgot_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final DataController dataController = Get.put(DataController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _key = GlobalKey<FormState>();
  bool obscuresText = true;
  bool _isLoading = false;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 3)).then((value) {
      FlutterNativeSplash.remove();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.whiteColor,
      body: Form(
        key: _key,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 60,
                ),
                Image.asset(
                  appImages.newicon,
                  height: 240,
                ),
                SizedBox(
                  height: 40,
                ),
                customTextField(
                  obscureText: false,
                  labelText: "Enter Email",
                  validator: (value) {
                    return validateEmail(value, context);
                  },
                  prefixIcon: Icon(
                    Icons.email,
                    size: 23,
                  ),
                  Controller: emailController,
                ),
                SizedBox(
                  height: 15,
                ),
                customTextField(
                  obscureText: obscuresText,
                  labelText: "Enter Password",
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    size: 23,
                  ),
                  Controller: passwordController,
                  validator: (value) {
                    return validatePassword(value);
                  },
                  maxLines: 1,
                  suffixIcon: InkWell(
                      onTap: () {
                        obscuresTexts();
                      },
                      child: Icon(
                        obscuresText ? Icons.visibility_off : Icons.visibility,
                        size: 20,
                      )),
                ),
                SizedBox(
                  height: 8,
                ),
                Align(
                  child: InkWell(
                      onTap: () {
                        Get.to(ForgotScreen());
                      },
                      child: Text(
                        'Forgot Password?',
                        style: appTextstyle.normalText(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            Colors: appColors.blueColor),
                      )),
                  alignment: Alignment.centerRight,
                ),
                SizedBox(
                  height: 20,
                ),
                appButton(
                  title: "Sign in",
                  onPressed: () async {
                    if (_key.currentState!.validate()) {
                      return dataController.login(
                          context: context,
                          email: emailController.text.toString(),
                          password: passwordController.text);
                    }
                  },
                  loading: false,
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: GoogleFonts.alata(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 15),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    InkWell(
                        onTap: () {
                          Get.to(SignupScreen());
                        },
                        child: Text(
                          "Register",
                          style: GoogleFonts.alata(
                              fontWeight: FontWeight.bold,
                              color: appColors.blueColor,
                              fontSize: 15),
                        )),
                  ],
                )),
              ],
            ),
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
