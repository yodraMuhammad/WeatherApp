import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/services/weather_service.dart';

import '../models/weather_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key
  final _weatherService = WeatherService('adb07ae6b1be429a82f31338230211');
  Weather? _weather;
  String? _city;

  // fetch weather
  _fetchWeather() async {
    // get current city
    String cityName = await _weatherService.getCurrentCity();
    setState(() {
      _city = cityName;
    });
    print('City Name: ${cityName}');
    // get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }

    // any error
    catch (e) {
      print('Error: $e');
    }
  }

  // weather animation
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'sunny':
        return 'assets/sunny.json';
      case 'partly cloudy':
        return 'assets/cloudy.json';
      case 'cloudy':
        return 'assets/cloudy.json';
      case 'overcast':
        return 'assets/cloudy.json';
      case 'fog':
        return 'assets/cloudy.json';
      case 'patchy rain possible':
        return 'assets/rain.json';
      case 'clear':
        return 'assets/cloudy.json';
      default:
        return 'assets/sunny.json';
    }
  }

  // init state
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on),
            // city Name
            const SizedBox(
              height: 10,
            ),
            Text(_city ?? ""),
            Text(_weather?.cityName ?? "loading city.."),
            const SizedBox(
              height: 50,
            ),

            // animation
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
            const SizedBox(
              height: 40,
            ),
            // tempratur
            Text(
              '${_weather?.temperatur.round().toString() ?? 0}°C',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),

            // weather condition
            Text(_weather?.mainCondition ?? ""),
            // ElevatedButton(
            //   onPressed: () {
            //     // Aksi yang ingin dijalankan ketika tombol ditekan
            //     // Misalnya:
            //     print('Tombol ditekan!');
            //     _fetchWeather();
            //   },
            //   child: Text('Tekan Saya'), // Isi teks di dalam tombol
            // )
          ],
        ),
      ),
    );
  }
}
