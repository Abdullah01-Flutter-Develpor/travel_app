// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/screens/city%20page%20widgets/weather%20/weather_data.dart';
import 'package:travel_app/screens/city%20page%20widgets/weather%20/weather_service.dart';

class CityTemperature extends StatefulWidget {
  final String cityName;

  const CityTemperature({super.key, required this.cityName});

  @override
  _CityTemperatureState createState() => _CityTemperatureState();
}

class _CityTemperatureState extends State<CityTemperature> {
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  WeatherData? _weatherData;
  final WeatherService _weatherService = WeatherService();
  final Connectivity _connectivity = Connectivity();

  // The subscription now listens to a List of ConnectivityResult
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    // Listen for connectivity changes
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((resultList) {
      if (resultList.isNotEmpty) {
        // We only care about the first result in the list
        final result = resultList.first;
        if (result != ConnectivityResult.none) {
          _fetchWeatherData(); // Retry fetching data when connectivity is restored
        }
      }
    });
    _fetchWeatherData(); // Fetch weather data when the widget is initialized
  }

  @override
  void dispose() {
    _connectivitySubscription
        .cancel(); // Don't forget to cancel the subscription
    super.dispose();
  }

  Future<void> _fetchWeatherData() async {
    if (!mounted) return;

    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'No internet connection. Please check your network.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final weatherData =
          await _weatherService.getWeatherForCity(widget.cityName);

      if (!mounted) return;

      if (weatherData == null) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = 'No internet connection. Please check your network.';
        });
      } else {
        setState(() {
          _weatherData = weatherData;
          _isLoading = false;
          _hasError = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return _buildLoadingIndicator();
    } else if (_hasError) {
      return _buildErrorMessage();
    } else if (_weatherData != null) {
      return _buildWeatherData();
    } else {
      return const SizedBox
          .shrink(); // Return empty widget instead of unknown state text
    }
  }

  Widget _buildLoadingIndicator() {
    return const SizedBox(
      height: 24,
      width: 24,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.cloud_off, // Better icon for network issues
            color: Colors.white70,
            size: 18,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              _errorMessage.contains("No internet")
                  ? "Offline"
                  : "Weather unavailable",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 6),
          InkWell(
            onTap: _fetchWeatherData, // Retry fetching the weather data
            child: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(Icons.refresh, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherData() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${_weatherData!.temperature.round()}°C',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          _weatherData!.condition,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
