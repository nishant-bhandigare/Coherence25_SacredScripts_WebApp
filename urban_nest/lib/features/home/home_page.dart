// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:urban_nest/features/home/all_india_energy_chart.dart';
// import 'package:urban_nest/features/home/energy_analytics_chart.dart';
// import 'package:urban_nest/features/home/energy_generation.dart';
// import 'package:urban_nest/features/shared/theme_switch.dart';
// import 'package:urban_nest/features/weather/location_service.dart';
// import 'package:urban_nest/features/weather/weather_widgets.dart';
// import 'package:weather/weather.dart';
// import 'package:fl_chart/fl_chart.dart';
//
// import '../../theme_notifier.dart';
// import 'power_supply_chart.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   Weather? _weather;
//   List<Weather>? _forecast;
//   bool _isLoading = true;
//   String _errorMessage = '';
//
//   final List<Map<String, dynamic>> energyData = [
//     {
//       "ID": "4198",
//       "Month": "Jun-2024",
//       "State": " West Bengal",
//       "peak_demand": "12187.3895084",
//       "peak_met": "12187.3895084",
//       "fy": "2024-2025"
//     },
//     {
//       "ID": "4199",
//       "Month": "Jun-2024",
//       "State": " Sikkim",
//       "peak_demand": "98.96259156562499",
//       "peak_met": "98.876075",
//       "fy": "2024-2025"
//     },
//     {
//       "ID": "4200",
//       "Month": "Jun-2024",
//       "State": " Andaman- Nicobar #",
//       "peak_demand": "63.4",
//       "peak_met": "61",
//       "fy": "2024-2025"
//     },
//     {
//       "ID": "4201",
//       "Month": "Jun-2024",
//       "State": " Eastern Region",
//       "peak_demand": "31488.17495296468",
//       "peak_met": "31399.15241858726",
//       "fy": "2024-2025"
//     },
//     {
//       "ID": "4202",
//       "Month": "Jun-2024",
//       "State": " Arunachal Pradesh",
//       "peak_demand": "170",
//       "peak_met": "170",
//       "fy": "2024-2025"
//     },
//     {
//       "ID": "4203",
//       "Month": "Jun-2024",
//       "State": " Assam",
//       "peak_demand": "2392.442",
//       "peak_met": "2386",
//       "fy": "2024-2025"
//     },
//     {
//       "ID": "4204",
//       "Month": "Jun-2024",
//       "State": " Manipur",
//       "peak_demand": "225.405",
//       "peak_met": "225",
//       "fy": "2024-2025"
//     },
//     {
//       "ID": "4205",
//       "Month": "Jun-2024",
//       "State": " Meghalaya",
//       "peak_demand": "330",
//       "peak_met": "330",
//       "fy": "2024-2025"
//     },
//     {
//       "ID": "4206",
//       "Month": "Jun-2024",
//       "State": " Mizoram",
//       "peak_demand": "126",
//       "peak_met": "126",
//       "fy": "2024-2025"
//     },
//     {
//       "ID": "4207",
//       "Month": "Jun-2024",
//       "State": " Nagaland",
//       "peak_demand": "184",
//       "peak_met": "184",
//       "fy": "2024-2025"
//     },
//     {
//       "ID": "4208",
//       "Month": "Jun-2024",
//       "State": " Tripura *",
//       "peak_demand": "353",
//       "peak_met": "353",
//       "fy": "2024-2025"
//     },
//     {
//       "ID": "4209",
//       "Month": "Jun-2024",
//       "State": " North-Eastern Region",
//       "peak_demand": "3579",
//       "peak_met": "3579",
//       "fy": "2024-2025"
//     },
//     {
//       "ID": "4210",
//       "Month": "Jun-2024",
//       "State": " All India",
//       "peak_demand": "244529.3285274517",
//       "peak_met": "244520.2995605469",
//       "fy": "2024-2025"
//     }
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeWeatherData();
//   }
//
//   Future<void> _initializeWeatherData() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = '';
//     });
//
//     try {
//       final position = await LocationService.getCurrentPosition(context);
//       if (position != null) {
//         final weather = await LocationService.getWeather(position.latitude, position.longitude);
//         final forecast = await LocationService.getDailyForecast(position.latitude, position.longitude);
//
//         setState(() {
//           _weather = weather;
//           _forecast = forecast;
//           _isLoading = false;
//         });
//       } else {
//         setState(() {
//           _errorMessage = 'Unable to retrieve location. Please check your location settings.';
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Error fetching weather data: ${e.toString()}';
//         _isLoading = false;
//       });
//       print('Error initializing data: $e');
//     }
//   }
//
//   Future<void> _refreshWeatherData() async {
//     // Clear existing cache
//     LocationService.clearCache();
//
//     // Re-initialize weather data
//     await _initializeWeatherData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final themeData = Provider.of<ThemeNotifier>(context).getTheme();
//     return Scaffold(
//       backgroundColor: themeData.colorScheme.surface,
//       body: RefreshIndicator(
//         onRefresh: _refreshWeatherData,
//         child: SingleChildScrollView(
//           physics: const AlwaysScrollableScrollPhysics(),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Header(),
//                 const SizedBox(height: 20),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Experience Your Summer in",
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//                     ),
//                     Text(
//                       "Vasai",
//                       style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//
//                 // Error handling
//                 if (_isLoading)
//                   const Center(child: CircularProgressIndicator()),
//
//                 if (_errorMessage.isNotEmpty)
//                   Center(
//                     child: Column(
//                       children: [
//                         Text(
//                           _errorMessage,
//                           style: const TextStyle(color: Colors.red),
//                           textAlign: TextAlign.center,
//                         ),
//                         const SizedBox(height: 10),
//                         ElevatedButton(
//                           onPressed: _initializeWeatherData,
//                           child: const Text('Retry'),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                 if (!_isLoading && _errorMessage.isEmpty) ...[
//                   WeatherDisplaySection(
//                     weather: _weather,
//                   ),
//                   const SizedBox(height: 20),
//                   WeatherInfoSection(
//                     weather: _weather,
//                   ),
//                   const SizedBox(height: 20),
//                   // const AnalyticsChart(),
//                   EnergyAnalyticsChart(energyData: energyData),
//                   const SizedBox(height: 20),
//                   // const IncomeChart(),
//                   // const SizedBox(height: 20),
//                   // CommerceChart(),
//                   EnergyGenerationChart(),
//                   const SizedBox(height: 20),
//                   AllIndiaEnergyChart(),
//                   const SizedBox(height: 20),
//                   EnergyChart(),
//                   const SizedBox(height: 20),
//                   ThemeSwitch(),
//                   const SizedBox(height: 60),
//                 ],
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class Header extends StatelessWidget{
//   const Header({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         const Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Welcome back',
//             ),
//             Text(
//               'Hi, Thomas',
//               style: TextStyle(
//                 fontSize: 30,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//         CircleAvatar(
//           maxRadius: 25,
//           backgroundColor: Colors.deepPurple.shade100,
//           child: Image.asset(
//             'assets/images/avatar.png',
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class AnalyticsChart extends StatelessWidget {
//   const AnalyticsChart({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           color: Color.fromRGBO(225, 225, 254, 0.5),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Analytics',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 16),
//             Row(
//               children: [
//                 _indicator(Colors.black, 'Left'),
//                 SizedBox(width: 10),
//                 _indicator(Colors.purple.shade200, 'In progress', isStriped: true),
//                 SizedBox(width: 10),
//                 _indicator(Colors.green, 'Done'),
//               ],
//             ),
//             SizedBox(height: 16),
//             SizedBox(
//               height: 150,
//               child: PieChart(
//                 PieChartData(
//                   sections: _chartSections(),
//                   centerSpaceRadius: 40,
//                   sectionsSpace: 2,
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _indicator(Color color, String text, {bool isStriped = false}) {
//     return Row(
//       children: [
//         Container(
//           width: 12,
//           height: 12,
//           decoration: BoxDecoration(
//             color: isStriped ? Colors.transparent : color,
//             border: isStriped ? Border.all(color: color, width: 2) : null,
//             shape: BoxShape.circle,
//           ),
//         ),
//         SizedBox(width: 4),
//         Text(text),
//       ],
//     );
//   }
//
//   List<PieChartSectionData> _chartSections() {
//     return [
//       PieChartSectionData(
//         value: 21,
//         color: Colors.black,
//         radius: 40,
//         title: '21%',
//         titleStyle: TextStyle(color: Colors.white, fontSize: 12),
//       ),
//       PieChartSectionData(
//         value: 34,
//         color: Colors.purple.shade200,
//         radius: 40,
//         title: '34%',
//         titleStyle: TextStyle(color: Colors.black, fontSize: 12),
//       ),
//       PieChartSectionData(
//         value: 45,
//         color: Colors.green,
//         radius: 40,
//         title: '45%',
//         titleStyle: TextStyle(color: Colors.black, fontSize: 12),
//       ),
//     ];
//   }
// }
//
// class IncomeChart extends StatelessWidget {
//   const IncomeChart({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         color: Color.fromRGBO(225, 225, 254, 0.5),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _incomeInfo('Total income', '\$18,657.00', Colors.black),
//                 _incomeInfo('Weekly income', '\$13,657.00', Colors.grey),
//               ],
//             ),
//             SizedBox(height: 16),
//             SizedBox(
//               height: 200,
//               child: BarChart(
//                 BarChartData(
//                   barGroups: _chartData(),
//                   borderData: FlBorderData(show: false),
//                   gridData: FlGridData(show: false),
//                   titlesData: FlTitlesData(
//                     leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                     rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                     topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                     bottomTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         getTitlesWidget: (value, meta) {
//                           switch (value.toInt()) {
//                             case 0:
//                               return Text('May');
//                             case 1:
//                               return Text('June');
//                             case 2:
//                               return Text('July');
//                             case 3:
//                               return Text('August');
//                             default:
//                               return Text('');
//                           }
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _incomeInfo(String title, String amount, Color dotColor) {
//     return Row(
//       children: [
//         Icon(Icons.circle, size: 8, color: dotColor),
//         SizedBox(width: 6),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(title, style: TextStyle(color: Colors.black54)),
//             Text(
//               amount,
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   List<BarChartGroupData> _chartData() {
//     return [
//       BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 10, color: Colors.black, width: 20)]),
//       BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 6, color: Colors.black54, width: 20)]),
//       BarChartGroupData(x: 2, barRods: [
//         BarChartRodData(toY: 15, color: Colors.purple.shade200, width: 20),
//         BarChartRodData(toY: 6.3, color: Colors.black45, width: 20),
//       ]),
//       BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 9, color: Colors.black, width: 20)]),
//     ];
//   }
// }
//
// class CommerceChart extends StatelessWidget {
//   const CommerceChart({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//         color: Color.fromRGBO(225, 225, 254, 0.5),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Commerce",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             SizedBox(
//               height: 200,
//               child: LineChart(
//                 LineChartData(
//                   gridData: FlGridData(show: false),
//                   titlesData: FlTitlesData(show: false),
//                   borderData: FlBorderData(show: false),
//                   minX: 0,
//                   maxX: 6,
//                   minY: 0,
//                   maxY: 1000,
//                   lineBarsData: [
//                     _lineChartBarData(
//                       color: Colors.blue,
//                       values: [800, 750, 600, 500, 900, 950, 700],
//                     ),
//                     _lineChartBarData(
//                       color: Colors.lightBlue,
//                       values: [700, 690, 500, 400, 850, 900, 650],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _statCard("Active user", "16k", Colors.blue, "32% ↑"),
//                 _statCard("New", "256", Colors.lightBlue, "48% ↑"),
//                 _statCard("Cancelled", "80", Colors.red, "12% ↓"),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   LineChartBarData _lineChartBarData({required Color color, required List<double> values}) {
//     return LineChartBarData(
//       spots: List.generate(values.length, (index) => FlSpot(index.toDouble(), values[index])),
//       isCurved: true,
//       // colors: [color],
//       barWidth: 3,
//       isStrokeCapRound: true,
//       belowBarData: BarAreaData(show: false),
//     );
//   }
//
//   Widget _statCard(String title, String value, Color color, String change) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             Icon(Icons.circle, color: color, size: 12),
//             SizedBox(width: 5),
//             Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
//           ],
//         ),
//         SizedBox(height: 5),
//         Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//         Text(change, style: TextStyle(fontSize: 14, color: color)),
//       ],
//     );
//   }
// }
//
//

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urban_nest/features/home/all_india_energy_chart.dart';
import 'package:urban_nest/features/home/energy_analytics_chart.dart';
import 'package:urban_nest/features/home/energy_generation.dart';
import 'package:urban_nest/features/shared/theme_switch.dart';
import 'package:urban_nest/features/weather/location_service.dart';
import 'package:urban_nest/features/weather/weather_widgets.dart';
import 'package:weather/weather.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../theme_notifier.dart';
import 'power_supply_chart.dart';
import 'package:urban_nest/responsive_layout.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Weather? _weather;
  List<Weather>? _forecast;
  bool _isLoading = true;
  String _errorMessage = '';

  final List<Map<String, dynamic>> energyData = [
    {
      "ID": "4198",
      "Month": "Jun-2024",
      "State": " West Bengal",
      "peak_demand": "12187.3895084",
      "peak_met": "12187.3895084",
      "fy": "2024-2025"
    },
    {
      "ID": "4199",
      "Month": "Jun-2024",
      "State": " Sikkim",
      "peak_demand": "98.96259156562499",
      "peak_met": "98.876075",
      "fy": "2024-2025"
    },
    {
      "ID": "4200",
      "Month": "Jun-2024",
      "State": " Andaman- Nicobar #",
      "peak_demand": "63.4",
      "peak_met": "61",
      "fy": "2024-2025"
    },
    {
      "ID": "4201",
      "Month": "Jun-2024",
      "State": " Eastern Region",
      "peak_demand": "31488.17495296468",
      "peak_met": "31399.15241858726",
      "fy": "2024-2025"
    },
    {
      "ID": "4202",
      "Month": "Jun-2024",
      "State": " Arunachal Pradesh",
      "peak_demand": "170",
      "peak_met": "170",
      "fy": "2024-2025"
    },
    {
      "ID": "4203",
      "Month": "Jun-2024",
      "State": " Assam",
      "peak_demand": "2392.442",
      "peak_met": "2386",
      "fy": "2024-2025"
    },
    {
      "ID": "4204",
      "Month": "Jun-2024",
      "State": " Manipur",
      "peak_demand": "225.405",
      "peak_met": "225",
      "fy": "2024-2025"
    },
    {
      "ID": "4205",
      "Month": "Jun-2024",
      "State": " Meghalaya",
      "peak_demand": "330",
      "peak_met": "330",
      "fy": "2024-2025"
    },
    {
      "ID": "4206",
      "Month": "Jun-2024",
      "State": " Mizoram",
      "peak_demand": "126",
      "peak_met": "126",
      "fy": "2024-2025"
    },
    {
      "ID": "4207",
      "Month": "Jun-2024",
      "State": " Nagaland",
      "peak_demand": "184",
      "peak_met": "184",
      "fy": "2024-2025"
    },
    {
      "ID": "4208",
      "Month": "Jun-2024",
      "State": " Tripura *",
      "peak_demand": "353",
      "peak_met": "353",
      "fy": "2024-2025"
    },
    {
      "ID": "4209",
      "Month": "Jun-2024",
      "State": " North-Eastern Region",
      "peak_demand": "3579",
      "peak_met": "3579",
      "fy": "2024-2025"
    },
    {
      "ID": "4210",
      "Month": "Jun-2024",
      "State": " All India",
      "peak_demand": "244529.3285274517",
      "peak_met": "244520.2995605469",
      "fy": "2024-2025"
    }
  ];

  @override
  void initState() {
    super.initState();
    _initializeWeatherData();
  }

  Future<void> _initializeWeatherData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final position = await LocationService.getCurrentPosition(context);
      if (position != null) {
        final weather = await LocationService.getWeather(position.latitude, position.longitude);
        final forecast = await LocationService.getDailyForecast(position.latitude, position.longitude);

        setState(() {
          _weather = weather;
          _forecast = forecast;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Unable to retrieve location. Please check your location settings.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching weather data: ${e.toString()}';
        _isLoading = false;
      });
      print('Error initializing data: $e');
    }
  }

  Future<void> _refreshWeatherData() async {
    // Clear existing cache
    LocationService.clearCache();

    // Re-initialize weather data
    await _initializeWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Provider.of<ThemeNotifier>(context).getTheme();
    return Scaffold(
      backgroundColor: themeData.colorScheme.surface,
      body: RefreshIndicator(
        onRefresh: _refreshWeatherData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: ResponsiveLayout.isMobile(context) ? 16 : 30,
                vertical: ResponsiveLayout.isMobile(context) ? 40 : 60
            ),
            child: ResponsiveLayout(
              mobile: _buildMobileLayout(),
              tablet: _buildTabletLayout(),
              desktop: _buildDesktopLayout(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Header(),
        const SizedBox(height: 20),
        _buildLocationSection(),
        const SizedBox(height: 20),
        _buildContentSection(),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Header(),
        const SizedBox(height: 20),
        _buildLocationSection(),
        const SizedBox(height: 20),
        _buildTabletContentSection(),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Header(),
        const SizedBox(height: 30),
        _buildLocationSection(),
        const SizedBox(height: 30),
        _buildDesktopContentSection(),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Experience Your Summer in",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        Text(
          "Vasai",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildContentSection() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return _buildErrorWidget();
    }

    return Column(
      children: [
        WeatherDisplaySection(weather: _weather),
        const SizedBox(height: 20),
        WeatherInfoSection(weather: _weather),
        const SizedBox(height: 20),
        EnergyAnalyticsChart(energyData: energyData),
        const SizedBox(height: 20),
        EnergyGenerationChart(),
        const SizedBox(height: 20),
        AllIndiaEnergyChart(),
        const SizedBox(height: 20),
        EnergyChart(),
        const SizedBox(height: 20),
        ThemeSwitch(),
        const SizedBox(height: 60),
      ],
    );
  }

  Widget _buildTabletContentSection() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return _buildErrorWidget();
    }

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: WeatherDisplaySection(weather: _weather),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 1,
              child: WeatherInfoSection(weather: _weather),
            ),
          ],
        ),
        const SizedBox(height: 20),
        EnergyAnalyticsChart(energyData: energyData),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: EnergyGenerationChart(),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: AllIndiaEnergyChart(),
            ),
          ],
        ),
        const SizedBox(height: 20),
        EnergyChart(),
        const SizedBox(height: 20),
        ThemeSwitch(),
        const SizedBox(height: 60),
      ],
    );
  }

  Widget _buildDesktopContentSection() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return _buildErrorWidget();
    }

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: WeatherDisplaySection(weather: _weather),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 1,
              child: WeatherInfoSection(weather: _weather),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 2,
              child: EnergyAnalyticsChart(energyData: energyData),
            ),
          ],
        ),
        const SizedBox(height: 30),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: EnergyGenerationChart(),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: AllIndiaEnergyChart(),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: EnergyChart(),
            ),
          ],
        ),
        const SizedBox(height: 30),
        Align(
          alignment: Alignment.centerRight,
          child: ThemeSwitch(),
        ),
        const SizedBox(height: 60),
      ],
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        children: [
          Text(
            _errorMessage,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _initializeWeatherData,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = ResponsiveLayout.isMobile(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back',
              style: TextStyle(fontSize: isMobile ? 14 : 16),
            ),
            Text(
              'Hi, Thomas',
              style: TextStyle(
                fontSize: isMobile ? 24 : 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        CircleAvatar(
          maxRadius: isMobile ? 20 : 25,
          backgroundColor: Colors.deepPurple.shade100,
          child: Image.asset(
            'assets/images/avatar.png',
          ),
        ),
      ],
    );
  }
}