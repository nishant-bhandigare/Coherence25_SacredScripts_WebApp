import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:urban_nest/features/weather/location_service.dart';

class InfoBar extends StatefulWidget {
  const InfoBar({super.key, required this.weather});
  final Weather? weather;

  @override
  State<InfoBar> createState() => _InfoBarState();
}

class _InfoBarState extends State<InfoBar> {
  int? _aqi;

  @override
  void initState() {
    super.initState();
    _fetchAQI();
  }

  Future<void> _fetchAQI() async {
    if (widget.weather != null) {
      try {
        final aqi = await LocationService.getAirQualityIndex(
            widget.weather!.latitude!,
            widget.weather!.longitude!
        );

        if (mounted) {
          setState(() {
            _aqi = aqi;
          });
        }
      } catch (e) {
        print('AQI Fetch Error: $e');
        if (mounted) {
          setState(() {
            _aqi = null;
          });
        }
      }
    }
  }

  String _getAQIDescription(int? aqi) {
    if (aqi == null) return 'N/A';
    switch (aqi) {
      case 1:
        return 'Good';
      case 2:
        return 'Fair';
      case 3:
        return 'Moderate';
      case 4:
        return 'Poor';
      case 5:
        return 'Very Poor';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: InfoBarItem(
                icon: Icons.wind_power_rounded,
                label: "Wind",
                data: "${widget.weather?.windSpeed.toString()} km/hr" ?? "0.0 km/hr",
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: InfoBarItem(
                icon: Icons.air_rounded,
                label: "AQI",
                data: _getAQIDescription(_aqi),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: InfoBarItem(
                icon: Icons.thermostat_rounded,
                label: "Min ~ Max",
                data:
                "${widget.weather?.tempMin?.celsius?.toInt()} ~ ${widget.weather?.tempMax?.celsius?.toInt()} °C" ??
                    "0 ~ 0 °C",
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: InfoBarItem(
                icon: Icons.thermostat_rounded,
                label: "Pressure",
                data: "${widget.weather?.pressure?.toInt()} hPa" ?? "0.0 hPa",
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// The InfoBarItem class remains the same as in the previous implementation
class InfoBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String data;

  const InfoBarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color.fromRGBO(225, 225, 254, 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 28,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            data,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}