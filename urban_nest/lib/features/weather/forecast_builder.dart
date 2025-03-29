import 'package:flutter/material.dart';
import 'package:weather/weather.dart';

class ForecastBuilder extends StatelessWidget {
  const ForecastBuilder({
    super.key,
    required this.forecast,
  });
  final List<Weather>? forecast;

  @override
  Widget build(BuildContext context) {
    if (forecast == null || forecast!.isEmpty) {
      return const Text('Forecast data not available');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: forecast!.map((weather) {
        return WeatherForecastDetail(weather: weather);
      }).toList(),
    );
  }
}

class WeatherForecastDetail extends StatelessWidget {
  const WeatherForecastDetail({
    super.key,
    required this.weather,
  });
  final Weather weather;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date: ${weather.date}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            Text('Weather: ${weather.weatherDescription}'),
            const SizedBox(height: 5.0),
            Text('Temperature: ${weather.temperature?.celsius}°C'),
            const SizedBox(height: 5.0),
            Text('Min Temperature: ${weather.tempMin?.celsius}°C'),
            const SizedBox(height: 5.0),
            Text('Max Temperature: ${weather.tempMax?.celsius}°C'),
            const SizedBox(height: 5.0),
            Text('Feels Like: ${weather.tempFeelsLike?.celsius}°C'),
            const SizedBox(height: 5.0),
            Text('Sunrise: ${weather.sunrise}',
                style: const TextStyle(fontStyle: FontStyle.italic)),
            const SizedBox(height: 5.0),
            Text('Sunset: ${weather.sunset}',
                style: const TextStyle(fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }
}
