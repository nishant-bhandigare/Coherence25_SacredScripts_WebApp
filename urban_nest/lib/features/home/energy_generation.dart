import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:urban_nest/features/home/energy_generation_data.dart';

class EnergyGenerationChart extends StatelessWidget {
  const EnergyGenerationChart({super.key});

  @override
  Widget build(BuildContext context) {
    // Process data by mode and month
    final Map<String, Map<String, double>> data = processData();
    final List<String> months = ['Oct-2024', 'Nov-2024', 'Dec-2024', 'Jan-2025', 'Feb-2025'];

    // Calculate totals and changes for stats
    final Map<String, double> latestMonthData = getLatestMonthData(data, months.last);
    final Map<String, double> previousMonthData = getLatestMonthData(data, months[months.length - 2]);
    final Map<String, double> percentChanges = calculatePercentChanges(latestMonthData, previousMonthData);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Color.fromRGBO(225, 225, 254, 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Energy Generation (BU)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 25,
                    verticalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withOpacity(0.3),
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withOpacity(0.3),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < months.length) {
                            final monthLabel = months[value.toInt()].split('-')[0];
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                monthLabel,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            );
                          }
                          return Text('');
                        },
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 25,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 10,
                            ),
                          );
                        },
                        reservedSize: 30,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  ),
                  minX: 0,
                  maxX: months.length - 1.0,
                  minY: 0,
                  maxY: 120,
                  lineBarsData: [
                    _lineChartBarData(
                      color: Colors.red,
                      name: 'THERMAL',
                      months: months,
                      data: data['THERMAL']!,
                    ),
                    _lineChartBarData(
                      color: Colors.green,
                      name: 'HYDRO',
                      months: months,
                      data: data['HYDRO']!,
                    ),
                    _lineChartBarData(
                      color: Colors.purple,
                      name: 'NUCLEAR',
                      months: months,
                      data: data['NUCLEAR']!,
                    ),
                    _lineChartBarData(
                      color: Colors.blue,
                      name: 'BHUTAN IMP',
                      months: months,
                      data: data['BHUTAN IMP']!,
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((touchedSpot) {
                          final mode = touchedSpot.bar.color == Colors.red ? 'THERMAL' :
                          touchedSpot.bar.color == Colors.green ? 'HYDRO' :
                          touchedSpot.bar.color == Colors.purple ? 'NUCLEAR' : 'BHUTAN IMP';
                          final month = months[touchedSpot.x.toInt()];
                          return LineTooltipItem(
                            '$mode\n',
                            TextStyle(color: touchedSpot.bar.color, fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                text: '${touchedSpot.y.toStringAsFixed(2)} BU',
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
                              ),
                              TextSpan(
                                text: '\n$month',
                                style: TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _statCard("THERMAL", "${latestMonthData['THERMAL']?.toStringAsFixed(1) ?? 'N/A'} BU",
                    Colors.red, "${percentChanges['THERMAL']?.toStringAsFixed(1) ?? 'N/A'}% ${percentChanges['THERMAL']! >= 0 ? '↑' : '↓'}"),
                _statCard("HYDRO", "${latestMonthData['HYDRO']?.toStringAsFixed(1) ?? 'N/A'} BU",
                    Colors.green, "${percentChanges['HYDRO']?.toStringAsFixed(1) ?? 'N/A'}% ${percentChanges['HYDRO']! >= 0 ? '↑' : '↓'}"),
                _statCard("NUCLEAR", "${latestMonthData['NUCLEAR']?.toStringAsFixed(1) ?? 'N/A'} BU",
                    Colors.purple, "${percentChanges['NUCLEAR']?.toStringAsFixed(1) ?? 'N/A'}% ${percentChanges['NUCLEAR']! >= 0 ? '↑' : '↓'}"),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Map<String, double> getLatestMonthData(Map<String, Map<String, double>> data, String month) {
    Map<String, double> result = {};

    data.forEach((mode, monthData) {
      if (monthData.containsKey(month)) {
        result[mode] = monthData[month]!;
      } else {
        result[mode] = 0.0; // Default value if data is missing
      }
    });

    return result;
  }

  Map<String, double> calculatePercentChanges(
      Map<String, double> current, Map<String, double> previous) {
    Map<String, double> changes = {};

    current.forEach((mode, value) {
      if (previous.containsKey(mode) && previous[mode]! > 0) {
        changes[mode] = ((value - previous[mode]!) / previous[mode]!) * 100;
      } else {
        changes[mode] = 0.0; // Default if no previous data
      }
    });

    return changes;
  }

  LineChartBarData _lineChartBarData({
    required Color color,
    required String name,
    required List<String> months,
    required Map<String, double> data
  }) {
    return LineChartBarData(
      spots: List.generate(months.length, (index) {
        final month = months[index];
        return FlSpot(index.toDouble(), data[month] ?? 0);
      }),
      isCurved: true,
      color: color,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: 4,
            color: color,
            strokeWidth: 1,
            strokeColor: Colors.white,
          );
        },
      ),
      belowBarData: BarAreaData(
        show: true,
        color: color.withOpacity(0.2),
      ),
    );
  }

  Widget _statCard(String title, String value, Color color, String change) {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.circle, color: color, size: 12),
            SizedBox(width: 5),
            Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
        SizedBox(height: 5),
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(change, style: TextStyle(
            fontSize: 14,
            color: change.contains('↑') ? Colors.green : Colors.red
        )),
      ],
    );
  }
}