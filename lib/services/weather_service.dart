import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = 'http://api.weatherapi.com/v1/current.json';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    // fetch the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(
        await placemarkFromCoordinates(position.latitude, position.longitude));
    print(position.latitude);
    print(position.longitude);

    final response =
        await http.get(Uri.parse('$BASE_URL?q=$cityName&key=$apiKey'));
    // await http.get(Uri.parse('$BASE_URL?q=$cityName&key=$apiKey'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<String> getCurrentCity() async {
    // get permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // fetch the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // convert the location into a list of placemark objects
    List<Placemark> plamarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    // extract the city name from first placemark
    String? city = plamarks[0].locality;
    List<String>? words = city?.split(" ");
    String? firstWord = words?[1];

    return firstWord ?? "";
  }
}
