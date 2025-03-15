import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_app/component/app_colors.dart';
import 'package:travel_app/component/text_style.dart';
import 'package:travel_app/screens/auth/login_screen.dart';

import '../../component/app_button.dart';
import '../../control_room/firebase_reference.dart';

class profileScreen extends StatefulWidget {
  const profileScreen({super.key});

  @override
  State<profileScreen> createState() => _profileScreenState();
}

class _profileScreenState extends State<profileScreen> {
  String? email, address, phone, cnic, districts, Date;
  String? name;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: appButton(
          title: "Logout",
          onPressed: () {
            Get.off(LoginScreen());
            FirebaseReference().auth.signOut();
          },
        ),
      ),
      backgroundColor: appColors.whiteColor,
      appBar: AppBar(
        backgroundColor: appColors.whiteColor,
        title: Text(
          "Profile",
          style: appTextstyle.normalText(fontSize: 25),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseReference()
              .userDetail
              .where("userId", isEqualTo: auth.currentUser!.uid.toString())
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  var data = snapshot.data!.docs[index];
                  return Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Center(
                          child: CircleAvatar(
                        child: Icon(
                          Icons.person,
                          size: 70,
                          color: appColors.blueColor,
                        ),
                        radius: 60,
                        backgroundColor: Colors.white,
                      )),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "${data['name']}",
                        style: appTextstyle.normalText(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text(
                        "${data['email']}",
                        style: appTextstyle.normalText(),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      ListTile(
                        leading: customContainer(Icons.person),
                        trailing: Icon(Icons.arrow_forward_ios_sharp),
                        title: Text(
                          "${data['name']}",
                          style: appTextstyle.normalText(),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        leading: customContainer(Icons.date_range),
                        trailing: Icon(Icons.arrow_forward_ios_sharp),
                        title: Text(
                          "${data['Date']}",
                          style: appTextstyle.normalText(),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  );
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              );
            }
          }),
    );
  }

  Widget customContainer(
    IconData? icon,
  ) {
    return Container(
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: appColors.blueColor,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 25,
        ));
  }
}
