import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:travel_app/screens/city%20page%20widgets/weather%20/weather_data.dart';

class WeatherService {
  static const String _baseUrl = 'https://api.weatherapi.com/v1';
  static const String _apiKey = '98b820288a9b49c3a50161729251603';

  Future<WeatherData?> getWeatherForCity(String cityName) async {
    final url = '$_baseUrl/current.json?key=$_apiKey&q=$cityName';
    debugPrint('Request URL: $url');

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw http.ClientException('Failed to load weather data');
      }

      final jsonData = jsonDecode(response.body);
      if (jsonData == null ||
          jsonData['location'] == null ||
          jsonData['current'] == null) {
        throw Exception('Invalid API response');
      }

      return WeatherData.fromJson(jsonData);
    } on SocketException {
      debugPrint('No internet connection.');
      return null; // Return null instead of throwing an exception
    } on http.ClientException catch (e) {
      debugPrint('Error fetching weather data: ${e.message}');
      return null;
    } catch (e) {
      debugPrint('Unexpected error occurred: $e');
      return null;
    }
  }
}
