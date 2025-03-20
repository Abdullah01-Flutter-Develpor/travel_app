// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_app/l10n/app_localizations.dart';

class FullScreenMap extends StatelessWidget {
  final String cityName;
  final CameraPosition initialPosition;
  final String cityId;
  final bool isOfflineMode;

  const FullScreenMap({
    super.key,
    required this.cityName,
    required this.initialPosition,
    required this.cityId,
    this.isOfflineMode = false,
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
            myLocationButtonEnabled: !isOfflineMode,
            liteModeEnabled: isOfflineMode,
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
            cameraTargetBounds: CameraTargetBounds(
              LatLngBounds(
                southwest: LatLng(
                  initialPosition.target.latitude - 0.05,
                  initialPosition.target.longitude - 0.05,
                ),
                northeast: LatLng(
                  initialPosition.target.latitude + 0.05,
                  initialPosition.target.longitude + 0.05,
                ),
              ),
            ),
          ),
          if (isOfflineMode)
            Container(
              color: Colors.black.withOpacity(0.1),
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
                      child: Row(
                        children: [
                          Text(
                            cityName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (isOfflineMode) ...[
                            const SizedBox(width: 8),
                            const Icon(Icons.wifi_off,
                                size: 16, color: Colors.orange),
                          ],
                        ],
                      ),
                    ),
                    FloatingActionButton.small(
                      heroTag: 'locationButtonHeroTag',
                      backgroundColor: Colors.white,
                      child: const Icon(
                        Icons.my_location,
                        color: Colors.black87,
                      ),
                      onPressed: isOfflineMode
                          ? () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(AppLocalizations.of(context)
                                      .locationServicesUnavailableInOfflineMode),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          : () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isOfflineMode)
            Positioned(
              top: 80,
              left: 0,
              right: 0,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 32),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)
                            .youAreViewingASavedMapSomeFeaturesMayBeLimited,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
