// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:travel_app/l10n/app_localizations.dart';
import 'package:travel_app/l10n/traslates_city.dart';
import 'package:travel_app/screens/city%20page%20widgets/action%20button/action_button_row.dart';
import 'package:travel_app/screens/city%20page%20widgets/feature_review_section.dart';
import 'package:travel_app/screens/city%20page%20widgets/full_screen_map.dart';

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
  bool _isConnected = false;
  bool _isCheckingConnectivity = true;
  bool _isMapLoaded = false;

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
    'Jahaz Banda': LatLng(34.7500, 72.3600),
    'Tirah Valley': LatLng(33.9000, 70.5000),
    'Kashmir': LatLng(34.0837, 74.7973),
    'Neelum Valley': LatLng(34.5833, 73.9167),
    'Kel': LatLng(35.7000, 71.6833),
  };

  // Stream subscription for connectivity changes
  StreamSubscription? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _initialPosition = CameraPosition(
      target:
          cityCoordinates[widget.cityName] ?? const LatLng(33.6844, 73.0479),
      zoom: 12.0,
    );
    _checkConnectivity();

    // Listen for connectivity changes
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _isConnected = result.contains(ConnectivityResult.wifi) ||
            result.contains(ConnectivityResult.mobile);
      });
    });
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  Future<void> _checkConnectivity() async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();

      setState(() {
        _isConnected = connectivityResult.contains(ConnectivityResult.wifi) ||
            connectivityResult.contains(ConnectivityResult.mobile);
        _isCheckingConnectivity = false;
      });
    } catch (e) {
      print('Error checking connectivity: $e');
      setState(() {
        _isConnected = false;
        _isCheckingConnectivity = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10),
          _isCheckingConnectivity
              ? const Center(child: CircularProgressIndicator())
              : _buildMapSection(),
          ActionButtonsRow(cityName: widget.cityName, cityId: widget.cityId),
          FeaturesSection(cityName: widget.cityName, cityId: widget.cityId),
          ReviewsSection(cityId: widget.cityId),
        ],
      ),
    );
  }

  Widget _buildMapSection() {
    if (_isConnected) {
      return _buildOnlineMap();
    } else if (_isMapLoaded) {
      return _buildOfflineMap();
    } else {
      return _buildNoConnectionNoCache();
    }
  }

  Widget _buildOnlineMap() {
    if (!_isMapLoaded) {
      setState(() {
        _isMapLoaded = true;
      });
    }
    return GestureDetector(
      onTap: () => _openFullScreenMap(context),
      child: Hero(
        tag: 'mapPreviewHeroTag',
        child: Container(
          height: 200,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    setState(() {
                      _isMapLoaded = true;
                    });
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
                cameraTargetBounds: CameraTargetBounds(
                  LatLngBounds(
                    southwest: LatLng(
                      _initialPosition.target.latitude - 0.05,
                      _initialPosition.target.longitude - 0.05,
                    ),
                    northeast: LatLng(
                      _initialPosition.target.latitude + 0.05,
                      _initialPosition.target.longitude + 0.05,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    AppLocalizations.of(context).tapToExpand,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    AppLocalizations.of(context).online,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOfflineMap() {
    return GestureDetector(
      onTap: () => _showOfflineMapDialog(),
      child: Container(
        height: 200,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              liteModeEnabled: true, // Use lite mode for offline maps
              mapToolbarEnabled: false,
              cameraTargetBounds: CameraTargetBounds(
                LatLngBounds(
                  southwest: LatLng(
                    _initialPosition.target.latitude - 0.05,
                    _initialPosition.target.longitude - 0.05,
                  ),
                  northeast: LatLng(
                    _initialPosition.target.latitude + 0.05,
                    _initialPosition.target.longitude + 0.05,
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.black.withOpacity(0.1),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  AppLocalizations.of(context).offlineMode,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wifi_off, size: 32),
                    const SizedBox(height: 8),
                    Text(
                      '${AppLocalizations.of(context).viewingSavedMapOf} ${getTranslatedCityName(context, widget.cityName)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppLocalizations.of(context)
                          .connectToInternetForFullFeatures,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoConnectionNoCache() {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
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
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.signal_wifi_off, size: 48, color: Colors.grey),
            const SizedBox(height: 8),
            Text(
              '${AppLocalizations.of(context).noMapAvailableFor} ${getTranslatedCityName(context, widget.cityName)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              AppLocalizations.of(context).connectToTheInternetToViewThisMap,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () async {
                setState(() {
                  _isCheckingConnectivity = true;
                });
                await _checkConnectivity();
              },
              icon: const Icon(Icons.refresh),
              label: Text(AppLocalizations.of(context).tryAgain),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOfflineMapDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).offlineMap),
        content: Text(
          '${AppLocalizations.of(context).youAreViewingASavedVersionOfThe} ${getTranslatedCityName(context, widget.cityName)} ${AppLocalizations.of(context).connectToInternetForFullFeatures}',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context).ok),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              setState(() {
                _isCheckingConnectivity = true;
              });
              await _checkConnectivity();
            },
            child: Text(AppLocalizations.of(context).checkConnection),
          ),
        ],
      ),
    );
  }

  void _openFullScreenMap(BuildContext context) {
    if (!_isConnected && !_isMapLoaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)
              .cannotOpenMapNoInternetConnectionOrSavedMapAvailable),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenMap(
          cityName: widget.cityName,
          initialPosition: _initialPosition,
          cityId: widget.cityId,
          isOfflineMode: !_isConnected,
        ),
      ),
    );
  }
}
