// ignore_for_file: deprecated_member_use

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/screens/city%20page%20widgets/weather%20/city_weather_data.dart';

class CityHeader extends StatelessWidget {
  final String cityName;
  final String imageUrl;

  const CityHeader({
    super.key,
    required this.cityName,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Container(
      height: screenSize.height * 0.4,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imageUrl),
          fit: BoxFit.cover,
        ),
        gradient: LinearGradient(
          colors: [
            theme.primaryColor.withOpacity(0.5),
            theme.primaryColor.withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 16,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cityName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 2),
                        blurRadius: 8,
                        color: Color.fromARGB(150, 0, 0, 0),
                      ),
                    ],
                  ),
                ),
                _buildLocationTag(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationTag() {
    return FutureBuilder<List<ConnectivityResult>>(
      future: Connectivity().checkConnectivity(),
      builder: (context, snapshot) {
        bool hasInternet = snapshot.hasData &&
            snapshot.data!.isNotEmpty &&
            snapshot.data!.first != ConnectivityResult.none;

        return Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.location_on,
                size: 16,
                color: Colors.white,
              ),
              const SizedBox(width: 4),
              hasInternet
                  ? CityTemperature(cityName: cityName)
                  : const Text(
                      "No internet",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
            ],
          ),
        );
      },
    );
  }
}
