import 'package:flutter/material.dart';
import 'package:urban_nest/features/weather/display.dart';
import 'package:urban_nest/features/weather/info.dart';
import 'package:urban_nest/features/weather/sunrise_sunset.dart';
import 'package:weather/weather.dart';

class WeatherDisplaySection extends StatelessWidget {
  final Weather? weather;

  const WeatherDisplaySection({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return DisplayWidget(
      temp: weather?.temperature?.celsius?.toInt() ?? 0,
      realFeel: weather?.tempFeelsLike?.celsius?.toInt() ?? 0,
    );
  }
}

class WeatherInfoSection extends StatelessWidget {
  final Weather? weather;

  const WeatherInfoSection({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return InfoBar(weather: weather);
  }
}

class WeatherSunSection extends StatelessWidget {
  final Weather? weather;

  const WeatherSunSection({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return SunriseSunset(weather: weather);
  }
}
