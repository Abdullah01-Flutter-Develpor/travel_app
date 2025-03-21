// ignore_for_file: unused_local_variable, deprecated_member_use

import 'dart:math';
import 'package:banner_image/banner_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:longitude_and_latitude_calculator/longitude_and_latitude_calculator.dart';
import 'package:travel_app/component/app_colors.dart';
import 'package:travel_app/component/app_images.dart';
import 'package:travel_app/component/text_style.dart';
import 'package:travel_app/control_room/firebase_reference.dart';
import 'package:travel_app/control_room/google_map_controller.dart';
import 'package:travel_app/screens/UploadPage.dart';
import 'package:travel_app/screens/auth/profile_screen.dart';
import 'package:travel_app/screens/view_screen.dart';
import 'package:travel_app/search%20bar/widgets/search_bar_widgets.dart';
import 'package:travel_app/uitlity/Utils.dart';
import '../app_ui/grid_container1.dart';
import '../app_ui/grid_container2.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final googleController = Get.put(GoogleMapController());
  double? Kilometers;
  double? latitude;
  double? longitude;

  final myitems = [
    Image.asset(
      'assets/place2.jpeg',
      fit: BoxFit.cover,
    ),
    Image.asset(
      'assets/place2.jpeg',
      fit: BoxFit.cover,
    ),
    Image.asset(
      'assets/place2.jpeg',
      fit: BoxFit.cover,
    ),
    Image.asset(
      'assets/place2.jpeg',
      fit: BoxFit.cover,
    ),
    Image.asset(
      'assets/place2.jpeg',
      fit: BoxFit.cover,
    ),
  ];

  int myCurrentIndex = 0;
  bool Favorite = false;
  var searchName = "";
  List<DocumentSnapshot> documents = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3)).then((value) {
      FlutterNativeSplash.remove();
    });
    googleController.getCurrentLocation().then((value) async {
      latitude = double.parse(value.latitude.toString());
      longitude = double.parse(value.longitude.toString());
      setState(() {});
    });
    googleController.requestLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return onWillPopExitApp();
      },
      child: latitude == null
          ? Scaffold(body: Center(child: CircularProgressIndicator()))
          : Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ImageUploadScreen(),
                    ),
                  );
                },
              ),
              backgroundColor: appColors.whiteColor,
              appBar: AppBar(
                backgroundColor: appColors.blueColor,
                automaticallyImplyLeading: false,
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        backgroundImage: AssetImage(appImages.icon),
                      ),
                    ),
                  )
                ],
                title: Text(
                  "Tourista",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    shadows: [
                      // Added a subtle shadow
                      Shadow(
                        blurRadius: 2.0,
                        color: Colors.black.withOpacity(0.15),
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
                elevation: 2.0, // Added a subtle elevation
                // No changes to layout or movement
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      SearchBarWidget(),
                      SizedBox(height: 5),
                      searchName.isNotEmpty
                          ? SizedBox()
                          : Container(
                              height: 172,
                              child: StreamBuilder(
                                stream:
                                    FirebaseReference().travelPost.snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Container(
                                      child: ListView.builder(
                                        itemCount: 1,
                                        itemBuilder: (context, index) {
                                          var rm = Random().nextInt(3);
                                          return Column(
                                            children: [
                                              BannerImage(
                                                children: List.generate(
                                                  snapshot.data!.size,
                                                  (index) => CachedNetworkImage(
                                                    imageUrl: snapshot
                                                        .data!
                                                        .docs[index]['imageurl']
                                                            [rm]
                                                        .toString(),
                                                    fit: BoxFit.cover,
                                                    placeholder: (context,
                                                            url) =>
                                                        Center(
                                                            child:
                                                                CircularProgressIndicator()),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                  ),
                                                ),
                                                selectedIndicatorColor:
                                                    Colors.green,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemLength: snapshot.data!.size,
                                                fit: BoxFit.cover,
                                                padding: EdgeInsets.zero,
                                                aspectRatio: 2.2,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                autoPlay: true,
                                                duration: Duration(seconds: 1),
                                              )
                                            ],
                                          );
                                        },
                                      ),
                                    );
                                  } else {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                },
                              ),
                            ),
                      Align(
                        child: Text(
                          "  Discover",
                          style: appTextstyle.normalText(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              Colors: Colors.black54),
                        ),
                        alignment: Alignment.topLeft,
                      ),
                      Container(
                        height: 220,
                        child: StreamBuilder(
                          stream: FirebaseReference().travelPost.snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              documents = snapshot.data!.docs;
                              if (searchName.length > 0 || documents.isEmpty) {
                                documents = documents.where((element) {
                                  return element
                                      .get('name')
                                      .toString()
                                      .toLowerCase()
                                      .contains(searchName.toLowerCase());
                                }).toList();
                              }
                              return GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 1,
                                        crossAxisSpacing: 8,
                                        childAspectRatio: 1.3),
                                itemCount: documents.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  var data = snapshot.data!.docs[index];
                                  final images = snapshot.data!.docs
                                      .map((doc) => doc['imageurl'][index])
                                      .toList();
                                  return grid_container1(
                                    title: "${documents[index]['name']}",
                                    images:
                                        "${documents[index]['imageurl'][1]}",
                                    onPressed: () {
                                      var lonAndLatDistance =
                                          LonAndLatDistance();
                                      final double Kilometer =
                                          lonAndLatDistance.lonAndLatDistance(
                                              lat1: double.parse(
                                                  "${documents[index]['latitude']}"),
                                              lon1: double.parse(
                                                  "${documents[index]['longitude']}"),
                                              lat2: double.parse(
                                                  latitude.toString()),
                                              lon2: double.parse(
                                                  longitude.toString()),
                                              km: true);

                                      Kilometers = Kilometer;

                                      setState(() {});

                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => ViewScreen(
                                            weather: documents[index]['weather']
                                                .toString(),
                                            Kalometer: Kilometers,
                                            current_Latitude: double.parse(
                                                latitude.toString()),
                                            current_Longitude: double.parse(
                                                longitude.toString()),
                                            other_Latitude: double.parse(
                                                "${documents[index]['latitude']}"),
                                            other_Longitude: double.parse(
                                                "${documents[index]['longitude']}"),
                                            title:
                                                "${documents[index]['name']}",
                                            description:
                                                "${documents[index]['description']}",
                                            imageUrl: [
                                              "${documents[index]['imageurl'][0].toString()}"
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            } else {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Align(
                        child: Text(
                          "  Most Beautiful",
                          style: appTextstyle.normalText(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              Colors: Colors.black54),
                        ),
                        alignment: Alignment.topLeft,
                      ),
                      Container(
                        height: 220,
                        child: StreamBuilder(
                          stream: FirebaseReference().travelPost.snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              documents = snapshot.data!.docs;
                              if (searchName.length > 0 || documents.isEmpty) {
                                documents = documents.where((element) {
                                  return element
                                      .get('name')
                                      .toString()
                                      .toLowerCase()
                                      .contains(searchName.toLowerCase());
                                }).toList();
                              }
                              return GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 1,
                                        crossAxisSpacing: 10,
                                        childAspectRatio: 0.9),
                                itemCount: documents.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  var data = snapshot.data!.docs[index];
                                  return SingleChildScrollView(
                                    child: gridContainer2(
                                      onPressed: () {
                                        var lonAndLatDistance =
                                            LonAndLatDistance();
                                        final double Kilometer =
                                            lonAndLatDistance.lonAndLatDistance(
                                                lat1: double.parse(
                                                    "${documents[index]['latitude']}"),
                                                lon1: double.parse(
                                                    "${documents[index]['longitude']}"),
                                                lat2: double.parse(
                                                    latitude.toString()),
                                                lon2: double.parse(
                                                    longitude.toString()),
                                                km: true);

                                        Kilometers = Kilometer;

                                        setState(() {});

                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => ViewScreen(
                                              Kalometer: Kilometers,
                                              weather: documents[index]
                                                      ['weather']
                                                  .toString(),
                                              current_Latitude: double.parse(
                                                  latitude.toString()),
                                              current_Longitude: double.parse(
                                                  longitude.toString()),
                                              other_Latitude: double.parse(
                                                  "${documents[index]['latitude']}"),
                                              other_Longitude: double.parse(
                                                  "${documents[index]['longitude']}"),
                                              title:
                                                  "${documents[index]['name']}",
                                              description:
                                                  "${documents[index]['description']}",
                                              imageUrl: [
                                                "${documents[index]['imageurl']}",
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      title: "${documents[index]['name']}",
                                      images:
                                          "${documents[index]['imageurl'][2]}",
                                    ),
                                  );
                                },
                              );
                            } else {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
