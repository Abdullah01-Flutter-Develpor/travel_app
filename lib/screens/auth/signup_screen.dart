import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_app/component/app_button.dart';
import 'package:travel_app/component/app_colors.dart';
import 'package:travel_app/component/app_images.dart';
import 'package:travel_app/component/text_field.dart';
import 'package:travel_app/component/text_style.dart';
import 'package:travel_app/control_room/control_data.dart';
import 'package:travel_app/screens/auth/login_screen.dart';

import '../../uitlity/validatetion.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final DataController dataController = Get.put(DataController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final _key = GlobalKey<FormState>();
  bool obscuresText = true;

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
                const SizedBox(
                  height: 60,
                ),
                Image.asset(
                  appImages.newicon,
                  height: 230,
                ),
                const SizedBox(
                  height: 40,
                ),
                customTextField(
                  obscureText: false,
                  labelText: "Enter Name",
                  prefixIcon: const Icon(
                    Icons.person,
                    size: 24,
                  ),
                  validator: (value) {
                    return validateusername(value);
                  },
                  maxLines: 1,
                  Controller: nameController,
                ),
                const SizedBox(
                  height: 15,
                ),
                customTextField(
                  obscureText: false,
                  labelText: "Enter Email",
                  prefixIcon: const Icon(
                    Icons.email,
                    size: 23,
                  ),
                  validator: (value) {
                    return validateEmail(value, context);
                  },
                  Controller: emailController,
                ),
                const SizedBox(
                  height: 15,
                ),
                customTextField(
                  obscureText: obscuresText,
                  labelText: "Enter Password",
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    size: 23,
                  ),
                  maxLines: 1,
                  Controller: passwordController,
                  validator: (value) {
                    return validatePassword(value);
                  },
                  suffixIcon: InkWell(
                      onTap: () {
                        obscuresTexts();
                      },
                      child: Icon(
                        obscuresText ? Icons.visibility_off : Icons.visibility,
                        size: 20,
                      )),
                ),
                const SizedBox(
                  height: 15,
                ),
                const SizedBox(
                  height: 20,
                ),
                appButton(
                  title: "Register",
                  onPressed: () {
                    if (_key.currentState!.validate()) {
                      dataController.register(
                        context: context,
                        email: emailController.text.trim(),
                        name: nameController.text.trim(),
                        password: passwordController.text,
                      );
                    }
                  },
                  loading: dataController.isLoading.value,
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have a account?",
                      style: appTextstyle.normalText(fontSize: 16),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Sign in",
                          style: appTextstyle.normalText(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              Colors: appColors.blueColor),
                        )),
                  ],
                )),
                const SizedBox(
                  height: 20,
                ),
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
