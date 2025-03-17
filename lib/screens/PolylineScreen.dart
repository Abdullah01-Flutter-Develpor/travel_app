// ignore_for_file: unused_field

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';

import '../component/app_bar.dart';

class PolylineScreen extends StatefulWidget {
  final double? current_Latitude;
  final double? current_Longitude;
  final double? other_Latitude;
  final double? other_Longitude;
  const PolylineScreen(
      {super.key,
      this.current_Latitude,
      this.current_Longitude,
      this.other_Latitude,
      this.other_Longitude});

  @override
  State<PolylineScreen> createState() => _PolylineScreenState();
}

class _PolylineScreenState extends State<PolylineScreen> {
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  Location _locationController = Location();

  LatLng? _currentP = null;

  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    getLocationUpdates().then(
      (_) => {
        getPolylinePoints().then((coordinates) => {
              generatePolyLineFromPoints(coordinates),
            }),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        toolbarHeight: 90,
        automaticallyImplyLeading: false,
        title: appBar(
          latitude: widget.current_Latitude,
          longitude: widget.current_Longitude,
        ),
      ),
      body: _currentP == null
          ? const Center(
              child: Text("Loading..."),
            )
          : GoogleMap(
              onMapCreated: ((GoogleMapController controller) =>
                  _mapController.complete(controller)),
              initialCameraPosition: CameraPosition(
                target: LatLng(double.parse(widget.current_Latitude.toString()),
                    double.parse(widget.current_Longitude.toString())),
                zoom: 10,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId("_currentLocation"),
                  icon: BitmapDescriptor.defaultMarker,
                  position: _currentP!,
                ),
                Marker(
                  markerId: const MarkerId("_sourceLocation"),
                  icon: BitmapDescriptor.defaultMarker,
                  position: LatLng(
                      double.parse(widget.other_Latitude.toString()),
                      double.parse(widget.other_Longitude.toString())),
                ),
                Marker(
                  markerId: const MarkerId("_destionationLocation"),
                  icon: BitmapDescriptor.defaultMarker,
                  position: LatLng(
                      double.parse(widget.other_Latitude.toString()),
                      double.parse(widget.other_Longitude.toString())),
                ),
              },
              polylines: Set<Polyline>.of(polylines.values),
            ),
    );
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(
      target: pos,
      zoom: 13,
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(_newCameraPosition),
    );
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentP =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          _cameraToPosition(_currentP!);
        });
      }
    });
  }

  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineRequest request = PolylineRequest(
      origin: PointLatLng(double.parse(widget.current_Latitude.toString()),
          double.parse(widget.current_Longitude.toString())),
      destination: PointLatLng(double.parse(widget.other_Latitude.toString()),
          double.parse(widget.other_Longitude.toString())),
      mode: TravelMode.driving,
    );

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      request: request,
      googleApiKey:
          'AIzaSyAjUxyQFWaj3pGvgFnLNoL8sy0g2Q6EnAI', // Replace with your actual API key
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    return polylineCoordinates;
  }

  void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) async {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.black,
        points: polylineCoordinates,
        width: 5);
    setState(() {
      polylines[id] = polyline;
    });
  }
}
