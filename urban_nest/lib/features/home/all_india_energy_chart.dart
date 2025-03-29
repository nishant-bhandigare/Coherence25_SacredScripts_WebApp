import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AllIndiaEnergyChart extends StatelessWidget {
  const AllIndiaEnergyChart({super.key});

  @override
  Widget build(BuildContext context) {
    // Process data
    final energyData = processEnergyData();
    final List<String> months = ['Oct-2024', 'Nov-2024', 'Dec-2024', 'Jan-2025', 'Feb-2025'];

    // Calculate totals for each month
    final Map<String, double> monthlyTotals = calculateMonthlyTotals(energyData, months);

    // Calculate percentage breakdown for the latest month
    final Map<String, double> latestMonthData = getMonthData(energyData, months.last);
    final double latestMonthTotal = monthlyTotals[months.last] ?? 0;
    final Map<String, double> latestMonthPercentages = {};
    latestMonthData.forEach((mode, value) {
      latestMonthPercentages[mode] = latestMonthTotal > 0 ? (value / latestMonthTotal) * 100 : 0;
    });

    // Calculate month-over-month change for the total
    final double currentTotal = monthlyTotals[months.last] ?? 0;
    final double previousTotal = monthlyTotals[months[months.length - 2]] ?? 0;
    final double totalPercentChange = previousTotal > 0 ? ((currentTotal - previousTotal) / previousTotal) * 100 : 0;

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
            Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "All India Energy Generation",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "FY 2024-2025",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Monthly total trends
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
                  maxY: 150,
                  lineBarsData: [
                    // Stacked area chart showing all energy types
                    _stackedLineChartBarData(
                      color: Colors.purple,
                      name: 'TOTAL',
                      months: months,
                      data: monthlyTotals,
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((touchedSpot) {
                          final month = months[touchedSpot.x.toInt()];
                          final monthData = getMonthData(energyData, month);

                          return LineTooltipItem(
                            '$month\n',
                            TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                text: 'Total: ${touchedSpot.y.toStringAsFixed(2)} BU\n',
                                style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: 'THERMAL: ${monthData['THERMAL']?.toStringAsFixed(2) ?? '0'} BU\n',
                                style: TextStyle(color: Colors.red),
                              ),
                              TextSpan(
                                text: 'HYDRO: ${monthData['HYDRO']?.toStringAsFixed(2) ?? '0'} BU\n',
                                style: TextStyle(color: Colors.green),
                              ),
                              TextSpan(
                                text: 'NUCLEAR: ${monthData['NUCLEAR']?.toStringAsFixed(2) ?? '0'} BU\n',
                                style: TextStyle(color: Colors.blue),
                              ),
                              TextSpan(
                                text: 'BHUTAN IMP: ${monthData['BHUTAN IMP']?.toStringAsFixed(2) ?? '0'} BU',
                                style: TextStyle(color: Colors.amber),
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

            SizedBox(height: 24),

            // Last month breakdown
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          months.last,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Total Generation",
                                  style: TextStyle(fontSize: 12, color: Colors.black54),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "${currentTotal.toStringAsFixed(2)} BU",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "vs Previous Month",
                                  style: TextStyle(fontSize: 12, color: Colors.black54),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "${totalPercentChange.toStringAsFixed(1)}% ${totalPercentChange >= 0 ? '↑' : '↓'}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: totalPercentChange >= 0 ? Colors.green : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            // Energy sources breakdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _energySourceCard(
                  "THERMAL",
                  latestMonthData['THERMAL'] ?? 0,
                  latestMonthPercentages['THERMAL'] ?? 0,
                  Colors.red,
                ),
                _energySourceCard(
                  "HYDRO",
                  latestMonthData['HYDRO'] ?? 0,
                  latestMonthPercentages['HYDRO'] ?? 0,
                  Colors.green,
                ),
                _energySourceCard(
                  "NUCLEAR",
                  latestMonthData['NUCLEAR'] ?? 0,
                  latestMonthPercentages['NUCLEAR'] ?? 0,
                  Colors.blue,
                ),
                _energySourceCard(
                  "BHUTAN IMP",
                  latestMonthData['BHUTAN IMP'] ?? 0,
                  latestMonthPercentages['BHUTAN IMP'] ?? 0,
                  Colors.amber,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Map<String, Map<String, double>> processEnergyData() {
    final jsonData = [
      {
        "ID": "270",
        "Month": "Oct-2024",
        "fy": "2024-2025",
        "mode": "HYDRO",
        "Region_State": "All India",
        "bus": "14.45588"
      },
      {
        "ID": "269",
        "Month": "Oct-2024",
        "fy": "2024-2025",
        "mode": "NUCLEAR",
        "Region_State": "All India",
        "bus": "4.76892"
      },
      {
        "ID": "268",
        "Month": "Oct-2024",
        "fy": "2024-2025",
        "mode": "THERMAL",
        "Region_State": "All India",
        "bus": "114.10172"
      },
      {
        "ID": "272",
        "Month": "Nov-2024",
        "fy": "2024-2025",
        "mode": "THERMAL",
        "Region_State": "All India",
        "bus": "104.23142"
      },
      {
        "ID": "273",
        "Month": "Nov-2024",
        "fy": "2024-2025",
        "mode": "NUCLEAR",
        "Region_State": "All India",
        "bus": "4.80977"
      },
      {
        "ID": "274",
        "Month": "Nov-2024",
        "fy": "2024-2025",
        "mode": "HYDRO",
        "Region_State": "All India",
        "bus": "8.630889999999999"
      },
      {
        "ID": "275",
        "Month": "Nov-2024",
        "fy": "2024-2025",
        "mode": "BHUTAN IMP",
        "Region_State": "All India",
        "bus": "0.1284"
      },
      {
        "ID": "279",
        "Month": "Dec-2024",
        "fy": "2024-2025",
        "mode": "BHUTAN IMP",
        "Region_State": "All India",
        "bus": "0.0246"
      },
      {
        "ID": "278",
        "Month": "Dec-2024",
        "fy": "2024-2025",
        "mode": "HYDRO",
        "Region_State": "All India",
        "bus": "7.753430000000001"
      },
      {
        "ID": "277",
        "Month": "Dec-2024",
        "fy": "2024-2025",
        "mode": "NUCLEAR",
        "Region_State": "All India",
        "bus": "5.1247"
      },
      {
        "ID": "276",
        "Month": "Dec-2024",
        "fy": "2024-2025",
        "mode": "THERMAL",
        "Region_State": "All India",
        "bus": "108.24152"
      },
      {
        "ID": "283",
        "Month": "Jan-2025",
        "fy": "2024-2025",
        "mode": "BHUTAN IMP",
        "Region_State": "All India",
        "bus": "0.05795"
      },
      {
        "ID": "282",
        "Month": "Jan-2025",
        "fy": "2024-2025",
        "mode": "HYDRO",
        "Region_State": "All India",
        "bus": "7.38805"
      },
      {
        "ID": "281",
        "Month": "Jan-2025",
        "fy": "2024-2025",
        "mode": "NUCLEAR",
        "Region_State": "All India",
        "bus": "4.77841"
      },
      {
        "ID": "280",
        "Month": "Jan-2025",
        "fy": "2024-2025",
        "mode": "THERMAL",
        "Region_State": "All India",
        "bus": "114.11224"
      },
      {
        "ID": "284",
        "Month": "Feb-2025",
        "fy": "2024-2025",
        "mode": "THERMAL",
        "Region_State": "All India",
        "bus": "110.40015"
      },
      {
        "ID": "285",
        "Month": "Feb-2025",
        "fy": "2024-2025",
        "mode": "NUCLEAR",
        "Region_State": "All India",
        "bus": "4.15334"
      },
      {
        "ID": "286",
        "Month": "Feb-2025",
        "fy": "2024-2025",
        "mode": "HYDRO",
        "Region_State": "All India",
        "bus": "6.970890000000001"
      },
      {
        "ID": "287",
        "Month": "Feb-2025",
        "fy": "2024-2025",
        "mode": "BHUTAN IMP",
        "Region_State": "All India",
        "bus": "0.07063"
      }
    ];

    // Initialize result structure
    Map<String, Map<String, double>> result = {
      'THERMAL': {},
      'HYDRO': {},
      'NUCLEAR': {},
      'BHUTAN IMP': {},
    };

    // Process data
    for (var item in jsonData) {
      final month = item['Month'] as String;
      final mode = item['mode'] as String;
      final busValue = double.parse(item['bus'] as String);

      if (result.containsKey(mode)) {
        result[mode]![month] = busValue;
      }
    }

    return result;
  }

  Map<String, double> getMonthData(Map<String, Map<String, double>> data, String month) {
    Map<String, double> result = {};

    data.forEach((mode, monthData) {
      if (monthData.containsKey(month)) {
        result[mode] = monthData[month]!;
      } else {
        result[mode] = 0.0;
      }
    });

    return result;
  }

  Map<String, double> calculateMonthlyTotals(Map<String, Map<String, double>> data, List<String> months) {
    Map<String, double> totals = {};

    for (var month in months) {
      double total = 0;
      data.forEach((mode, monthData) {
        if (monthData.containsKey(month)) {
          total += monthData[month]!;
        }
      });
      totals[month] = total;
    }

    return totals;
  }

  LineChartBarData _stackedLineChartBarData({
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
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: 5,
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

  Widget _energySourceCard(String title, double value, double percentage, Color color) {
    return Expanded(
      child: Card(
        elevation: 0,
        color: Colors.white.withOpacity(0.5),
        margin: EdgeInsets.symmetric(horizontal: 4),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                "${value.toStringAsFixed(1)} BU",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(
                "${percentage.toStringAsFixed(1)}%",
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
              SizedBox(height: 4),
              LinearProgressIndicator(
                value: percentage / 100,
                backgroundColor: Colors.grey.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}