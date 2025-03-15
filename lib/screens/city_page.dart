import 'package:flutter/material.dart';
import 'package:travel_app/screens/feature_widegt.dart/feature_list.dart';
import 'package:travel_app/screens/header_widgets.dart';
import 'package:travel_app/screens/map_launch.dart';
import 'package:travel_app/screens/review%20page/review%20making%20page/make_a_review_page_widget.dart';
import 'package:travel_app/screens/review%20page/review_page.dart';

class CityPage extends StatefulWidget {
  const CityPage({
    super.key,
    required this.cityName,
    required this.cityId,
    required this.onLocaleChanged,
  });

  final String cityName;
  final String cityId;
  final Function(Locale) onLocaleChanged;

  @override
  _CityPageState createState() => _CityPageState();
}

class _CityPageState extends State<CityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cityName), // Display the city name here
        actions: [
          DropdownButton<Locale>(
            value: Localizations.localeOf(context),
            items: const [
              DropdownMenuItem(value: Locale('en'), child: Text('English')),
              DropdownMenuItem(value: Locale('ur'), child: Text('اردو')),
            ],
            onChanged: (value) {
              if (value != null) {
                widget.onLocaleChanged(value);
              }
            },
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
                color: Colors.white,
              ),
              child: SizedBox(
                height: 150,
                child: HeaderWidgets(
                  cityName: widget.cityName, // Pass city name to HeaderWidgets
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: SizedBox(
                height: 80,
                width: 300,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          MapLauncherService()
                              .launchMaps(widget.cityName, context);
                        },
                        child: const Text('Open Map',
                            style: TextStyle(color: Colors.white)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                  content: MakeReviewPage(
                                cityId: widget.cityId,
                              ));
                            },
                          );
                        },
                        child: const Text(
                          'Add a Review',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
                color: Colors.white,
              ),
              child: SizedBox(
                height: 120,
                child: FeaturesList(
                  cityName: widget.cityName, // Pass city name to FeaturesList
                  cityId: widget.cityId, // Pass city ID to FeaturesList
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  color: Colors.white,
                ),
                child: ReviewPage(cityId: widget.cityId),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
