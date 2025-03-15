import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_app/component/app_colors.dart';
import 'package:travel_app/component/text_style.dart';

import 'PolylineScreen.dart';

class ViewScreen extends StatefulWidget {
  final String? Detail, date, title, description, weather;
  final double? current_Latitude;
  final double? current_Longitude;
  final double? other_Latitude;
  final double? other_Longitude;
  final double? Kalometer;
  final List<dynamic> imageUrl;
  const ViewScreen(
      {super.key,
      this.Detail,
      this.date,
      this.title,
      this.description,
      this.Kalometer,
      this.current_Latitude,
      this.current_Longitude,
      this.other_Latitude,
      this.other_Longitude,
      this.weather,
      required this.imageUrl});

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  @override
  void initState() {
    print("${widget.current_Latitude}"
        '>>>>>>>>>>>>'
        "Current Location >>>>>>>>>>>>>>>>>>>>>>>>>>>> "
        "${widget.current_Longitude}");

    print("${widget.other_Latitude}"
        '>>>>>>>>>>'
        "Another Location >>>>>>>>>>>>>>>>>>>>>>>>>>>>  "
        "${widget.other_Longitude}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.imageUrl.length,
              itemBuilder: (context, index) {
                print("${widget.imageUrl[index]}>>>>>>>>>>>>>>>>>>>>>.");
                print("${widget.imageUrl.length}>>>>>>>>>>>>>>>>>>>>>.");

                return CachedNetworkImage(
                  imageUrl: widget.imageUrl[index].toString(),
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      Center(child: Icon(Icons.error)),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 150,
                );
              },
            ),
          ),

          // GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1,childAspectRatio: 6/2),
          // scrollDirection: Axis.horizontal,itemBuilder: (context, index) {
          //
          // return  Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Container(height: 140,
          //
          //     child:  CachedNetworkImage(
          //     imageUrl: widget.imageUrl[index],
          //     fit: BoxFit.cover,
          //     placeholder: (context, url) => Center(child: CircularProgressIndicator()),
          //     errorWidget: (context, url, error) => Icon(Icons.error),
          //   ),
          //   ),
          // );
          //
          // },itemCount: widget.imageUrl.length,),

          buttonArrow(context),
          scroll(),
        ],
      ),
    ));
  }

  buttonArrow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          clipBehavior: Clip.hardEdge,
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  scroll() {
    return DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 1.0,
        minChildSize: 0.75,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 5,
                          width: 35,
                          color: Colors.black12,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title.toString(),
                        style: appTextstyle.normalText(
                            fontWeight: FontWeight.w500, fontSize: 30),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.to(PolylineScreen(
                                current_Latitude: widget.current_Latitude,
                                current_Longitude: widget.current_Longitude,
                                other_Latitude: widget.other_Latitude,
                                other_Longitude: widget.other_Longitude,
                              ));
                            },
                            child: CircleAvatar(
                                backgroundColor: appColors.blueColor,
                                child: Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.white,
                                  size: 30,
                                )),
                          ),
                          widget.Kalometer == Null
                              ? Text("data")
                              : Text(
                                  "${double.parse(widget.Kalometer.toString()).toStringAsFixed(0)} Km",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500)),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        trailing: Text("${widget.weather.toString()}°c",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500)),
                        leading: Text(
                          "Weather",
                          style: appTextstyle.normalText(
                              fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(widget.description.toString()),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  ingredients(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 10,
            backgroundColor: Color(0xFFE3FFF8),
            child: Icon(
              Icons.done,
              size: 15,
              color: Colors.green,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            "4 Eggs",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  steps(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(
            backgroundColor: Colors.green,
            radius: 12,
            child: Text("${index + 1}"),
          ),
          Column(
            children: [
              SizedBox(
                width: 270,
                child: Text(
                  "Your recipe has been uploaded, you can see it on your profile. Your recipe has been uploaded, you can see it on your",
                  maxLines: 3,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.green,
                      ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Image.asset(
                "assets/imges/Rectangle 219.png",
                height: 155,
                width: 270,
              )
            ],
          )
        ],
      ),
    );
  }
}

// child: CachedNetworkImage(
//
//   imageUrl: "${widget.imageUrl![index]}",
//   fit: BoxFit.cover,
//   placeholder: (context, url) => Center(child: CircularProgressIndicator()),
//   errorWidget: (context, url, error) => Icon(Icons.error),
// ),
