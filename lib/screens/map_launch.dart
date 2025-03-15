import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';

class MapLauncherService {
  Future<void> launchMaps(String cityName, BuildContext context) async {
    try {
      List<Location> locations = await locationFromAddress(cityName);

      if (locations.isNotEmpty) {
        double latitude = locations.first.latitude;
        double longitude = locations.first.longitude;

        final String googleMapsUrl =
            'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
        final String appleMapsUrl =
            'http://maps.apple.com/?ll=$latitude,$longitude';

        if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
          await launchUrl(Uri.parse(googleMapsUrl));
        } else if (await canLaunchUrl(Uri.parse(appleMapsUrl))) {
          await launchUrl(Uri.parse(appleMapsUrl));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not launch maps.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not find coordinates for $cityName.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error launching maps: $e')),
      );
    }
  }
}
