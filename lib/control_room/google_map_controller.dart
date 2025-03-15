// ignore_for_file: unused_element

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class GoogleMapController extends GetxController {
  double? latitude;
  double? longitude;
  double? Kilometers;

  /// setState value
  @override
  void onInit() {
    super.onInit();
    // TotalKilometerLocation();
    // getCurrentLocation().then((value) {
    //   latitude = value.latitude;
    //   longitude = value.longitude;
    // });
  }

  /// Location Permission User
  Future<void> requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print(status.isGranted);
    } else {
      print(status.isDenied);
    }
  }

  /// Get User Current Location
  Future<Position> getCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print("error" + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _convertCoordinatesToAddress(
      double latitude, double longitude, String? _address) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];

      _address = "${place.locality}, ${place.postalCode}, ${place.country}";
    } catch (e) {
      _address = "Error: $e";
    }
  }

  /// Kilometer total location
  // TotalKilometerLocation({double? latitudes,longitudes}){
  //   var lonAndLatDistance = LonAndLatDistance();
  //   final double Kilometer = lonAndLatDistance.lonAndLatDistance(
  //       lat1: double.parse(latitude.toString()),
  //       lon1: double.parse(longitude.toString()),
  //       lat2: longitudes,
  //       lon2: longitudes,
  //       km: true);
  //   Kilometers = Kilometer;
  // }
}
