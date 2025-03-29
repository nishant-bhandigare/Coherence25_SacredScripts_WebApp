import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:urban_nest/keys.dart';
import 'package:weather/weather.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationService {
  // Cached data storage
  static Position? _cachedPosition;
  static Weather? _cachedWeather;
  static List<Weather>? _cachedForecast;
  static int? _cachedAQI;

  // Timestamp for cached data to manage cache expiration
  static DateTime? _positionCacheTime;
  static DateTime? _weatherCacheTime;
  static DateTime? _forecastCacheTime;
  static DateTime? _aqiCacheTime;

  // Cache duration (15 minutes)
  static const Duration _cacheDuration = Duration(minutes: 15);

  // Clear all cached data
  static void clearCache() {
    _cachedPosition = null;
    _cachedWeather = null;
    _cachedForecast = null;
    _cachedAQI = null;
    _positionCacheTime = null;
    _weatherCacheTime = null;
    _forecastCacheTime = null;
    _aqiCacheTime = null;
  }

  // Get current position
  static Future<Position?> getCurrentPosition(BuildContext context) async {
    // Return cached position if valid
    if (_cachedPosition != null && _isCacheValid(_positionCacheTime)) {
      return _cachedPosition;
    }

    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled.')),
      );
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied')),
        );
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permissions are permanently denied')),
      );
      return null;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    try {
      final position = await Geolocator.getCurrentPosition();
      _cachedPosition = position;
      _positionCacheTime = DateTime.now();
      return position;
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  // Get current weather
  static Future<Weather?> getWeather(double latitude, double longitude) async {
    // Return cached weather if valid and coordinates match
    if (_cachedWeather != null &&
        _isCacheValid(_weatherCacheTime) &&
        _checkCoordinatesMatch(_cachedWeather, latitude, longitude)) {
      return _cachedWeather;
    }

    final WeatherFactory ws = WeatherFactory(open_weather_map_api_key);

    try {
      final weather = await ws.currentWeatherByLocation(latitude, longitude);
      _cachedWeather = weather;
      _weatherCacheTime = DateTime.now();
      return weather;
    } catch (e) {
      print('Error fetching weather: $e');
      return null;
    }
  }

  // Get daily forecast
  static Future<List<Weather>?> getDailyForecast(double latitude, double longitude) async {
    // Return cached forecast if valid and coordinates match
    if (_cachedForecast != null &&
        _isCacheValid(_forecastCacheTime) &&
        _checkCoordinatesMatch(_cachedWeather, latitude, longitude)) {
      return _cachedForecast;
    }

    final WeatherFactory ws = WeatherFactory(open_weather_map_api_key);

    try {
      final forecast = await ws.fiveDayForecastByLocation(latitude, longitude);
      _cachedForecast = forecast;
      _forecastCacheTime = DateTime.now();
      return forecast;
    } catch (e) {
      print('Error fetching forecast: $e');
      return null;
    }
  }

  // Existing AirQualityIndex method remains the same...
  // Air Quality Index method
  static Future<int?> getAirQualityIndex(double latitude, double longitude) async {
    // Return cached AQI if valid and coordinates match
    if (_cachedAQI != null &&
        _isCacheValid(_aqiCacheTime) &&
        _checkCoordinatesMatch(_cachedWeather, latitude, longitude)) {
      return _cachedAQI;
    }

    const String apiKey = open_weather_map_api_key;
    final url = Uri.parse(
        'http://api.openweathermap.org/data/2.5/air_pollution?lat=$latitude&lon=$longitude&appid=$apiKey'
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Check if the list is not empty
        if (data['list'] != null && data['list'].isNotEmpty) {
          // Extract and cache AQI
          final aqi = data['list'][0]['main']['aqi'];

          _cachedAQI = aqi;
          _aqiCacheTime = DateTime.now();

          return aqi;
        } else {
          print('AQI data list is empty');
          return null;
        }
      } else {
        print('Failed to load AQI data: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching AQI: $e');
      return null;
    }
  }

  // Helper method to check if cache is valid
  static bool _isCacheValid(DateTime? cacheTime) {
    return cacheTime != null &&
        DateTime.now().difference(cacheTime) < _cacheDuration;
  }

  // Helper method to check if coordinates match
  static bool _checkCoordinatesMatch(dynamic cachedData, double latitude, double longitude) {
    if (cachedData == null) return false;

    // For Weather objects
    if (cachedData is Weather) {
      return cachedData.latitude != null &&
          cachedData.longitude != null &&
          (cachedData.latitude! - latitude).abs() < 0.01 &&
          (cachedData.longitude! - longitude).abs() < 0.01;
    }

    // For other types, return false
    return false;
  }
}