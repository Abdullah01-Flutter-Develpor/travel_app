// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:travel_app/screens/city%20page%20widgets/action%20button/action_button_row.dart';
import 'package:travel_app/screens/city%20page%20widgets/feature_review_section.dart';

class CityContent extends StatefulWidget {
  final String cityName;
  final String cityId;

  const CityContent({
    super.key,
    required this.cityName,
    required this.cityId,
  });

  @override
  State<CityContent> createState() => _CityContentState();
}

class _CityContentState extends State<CityContent> {
  final Completer<GoogleMapController> _controller = Completer();
  late CameraPosition _initialPosition;

  static const Map<String, LatLng> cityCoordinates = {
    'Islamabad': LatLng(33.6844, 73.0479),
    'Lahore': LatLng(31.5204, 74.3587),
    'Peshawar': LatLng(34.0151, 71.5249),
    'Murree': LatLng(33.9070, 73.3943),
    'Gilgit': LatLng(35.9208, 74.3144),
    'Skardu': LatLng(35.2927, 75.6312),
    'Swat': LatLng(34.7500, 72.3600),
    'Chitral': LatLng(35.8508, 71.7869),
    'Hunza': LatLng(36.3167, 74.6500),
    'Kumrat': LatLng(35.2000, 72.5333),
    'Kelash Valley': LatLng(35.7000, 71.6833),
    'Jahaz Banda': LatLng(34.7500, 72.3600), // Near Swat
    'Dhrush': LatLng(35.8508, 71.7869), // Near Chitral
    'Tirah Valley': LatLng(33.9000, 70.5000),
    'Kashmir': LatLng(34.0837, 74.7973),
    'Neelum Valley': LatLng(34.5833, 73.9167),
    'Kel': LatLng(35.7000, 71.6833), // Near Kelash Valley
  };

  @override
  void initState() {
    super.initState();
    _initialPosition = CameraPosition(
      target:
          cityCoordinates[widget.cityName] ?? const LatLng(33.6844, 73.0479),
      zoom: 12.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          _buildMapPreview(),
          ActionButtonsRow(cityName: widget.cityName, cityId: widget.cityId),
          FeaturesSection(cityName: widget.cityName, cityId: widget.cityId),
          ReviewsSection(cityId: widget.cityId),
        ],
      ),
    );
  }

  Widget _buildMapPreview() {
    return FutureBuilder<List<ConnectivityResult>>(
      future: Connectivity().checkConnectivity(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          final isConnected = snapshot.data!.any(
            (result) =>
                result == ConnectivityResult.wifi ||
                result == ConnectivityResult.mobile,
          );

          if (isConnected) {
            return GestureDetector(
              onTap: () => _openFullScreenMap(context),
              child: Hero(
                tag: 'mapPreviewHeroTag',
                child: Container(
                  height: 200,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: _initialPosition,
                        onMapCreated: (GoogleMapController controller) {
                          if (!_controller.isCompleted) {
                            _controller.complete(controller);
                          }
                        },
                        zoomControlsEnabled: false,
                        compassEnabled: false,
                        myLocationButtonEnabled: false,
                        markers: {
                          Marker(
                            markerId: MarkerId(widget.cityId),
                            position: _initialPosition.target,
                            infoWindow: InfoWindow(title: widget.cityName),
                          ),
                        },
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Tap to expand',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return _buildNoConnectionPlaceholder();
          }
        } else {
          return _buildNoConnectionPlaceholder();
        }
      },
    );
  }

  void _openFullScreenMap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenMap(
          cityName: widget.cityName,
          initialPosition: _initialPosition,
          cityId: widget.cityId,
        ),
      ),
    );
  }

  Widget _buildNoConnectionPlaceholder() {
    return Container(
      color: Colors.white,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text(
              'No internet connection',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class FullScreenMap extends StatelessWidget {
  final String cityName;
  final CameraPosition initialPosition;
  final String cityId;

  const FullScreenMap({
    super.key,
    required this.cityName,
    required this.initialPosition,
    required this.cityId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: initialPosition,
            zoomControlsEnabled: true,
            compassEnabled: true,
            myLocationButtonEnabled: true,
            markers: {
              Marker(
                markerId: MarkerId(cityId),
                position: initialPosition.target,
                infoWindow: InfoWindow(
                  title: cityName,
                  snippet: 'Explore $cityName',
                ),
              ),
            },
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FloatingActionButton.small(
                      heroTag: 'backButtonHeroTag',
                      backgroundColor: Colors.white,
                      child: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        cityName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    FloatingActionButton.small(
                      heroTag: 'locationButtonHeroTag',
                      backgroundColor: Colors.white,
                      child:
                          const Icon(Icons.my_location, color: Colors.black87),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
