import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class EnergyChart extends StatelessWidget {
  const EnergyChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color.fromRGBO(225, 225, 254, 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _energyInfo('Requirement', '19,075 MW', Colors.blue),
                _energyInfo('Availability', '18,910 MW', Colors.green),
              ],
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  barGroups: _chartData(),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  alignment: BarChartAlignment.spaceAround,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text('Sikkim', style: TextStyle(fontWeight: FontWeight.bold)),
                              );
                            case 1:
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text('Andaman', style: TextStyle(fontWeight: FontWeight.bold)),
                              );
                            case 2:
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text('Eastern', style: TextStyle(fontWeight: FontWeight.bold)),
                              );
                            case 3:
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text('Arunachal', style: TextStyle(fontWeight: FontWeight.bold)),
                              );
                            default:
                              return Text('');
                          }
                        },
                      ),
                    ),
                  ),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      // tooltipBgColor: Colors.white.withOpacity(0.8),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        String state;
                        switch (group.x.toInt()) {
                          case 0:
                            state = 'Sikkim';
                            break;
                          case 1:
                            state = 'Andaman-Nicobar';
                            break;
                          case 2:
                            state = 'Eastern Region';
                            break;
                          case 3:
                            state = 'Arunachal Pradesh';
                            break;
                          default:
                            state = '';
                        }
                        return BarTooltipItem(
                          '$state\n',
                          const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: rodIndex == 0
                                  ? 'Requirement: ${rod.toY.toStringAsFixed(2)} MW'
                                  : 'Availability: ${rod.toY.toStringAsFixed(2)} MW',
                              style: TextStyle(
                                color: rodIndex == 0 ? Colors.blue : Colors.green,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                'Energy Data for May-2024',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _energyInfo(String title, String amount, Color dotColor) {
    return Row(
      children: [
        Icon(Icons.circle, size: 8, color: dotColor),
        SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: Colors.black54)),
            Text(
              amount,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  List<BarChartGroupData> _chartData() {
    final List<Map<String, dynamic>> energyData = [
      {
        "State": "Sikkim",
        "energy_requirement": 49.64,
        "energy_availability": 49.64,
        "Month": "May-2024"
      },
      {
        "State": "Andaman-Nicobar",
        "energy_requirement": 37.82,
        "energy_availability": 36.65,
        "Month": "May-2024"
      },
      {
        "State": "Eastern Region",
        "energy_requirement": 18802.02,
        "energy_availability": 18738.02,
        "Month": "May-2024"
      },
      {
        "State": "Arunachal Pradesh",
        "energy_requirement": 85.82,
        "energy_availability": 85.82,
        "Month": "May-2024"
      }
    ];

    // Scale down Eastern Region values to fit chart better (as they're much larger)
    final scaledEnergyData = energyData.map((data) {
      if (data["State"] == "Eastern Region") {
        return {
          ...data,
          "energy_requirement": data["energy_requirement"] / 100,
          "energy_availability": data["energy_availability"] / 100,
        };
      }
      return data;
    }).toList();

    return [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(toY: scaledEnergyData[0]["energy_requirement"].toDouble(), color: Colors.blue, width: 16),
          BarChartRodData(toY: scaledEnergyData[0]["energy_availability"].toDouble(), color: Colors.green, width: 16),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(toY: scaledEnergyData[1]["energy_requirement"].toDouble(), color: Colors.blue, width: 16),
          BarChartRodData(toY: scaledEnergyData[1]["energy_availability"].toDouble(), color: Colors.green, width: 16),
        ],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [
          BarChartRodData(toY: scaledEnergyData[2]["energy_requirement"].toDouble(), color: Colors.blue, width: 16),
          BarChartRodData(toY: scaledEnergyData[2]["energy_availability"].toDouble(), color: Colors.green, width: 16),
        ],
      ),
      BarChartGroupData(
        x: 3,
        barRods: [
          BarChartRodData(toY: scaledEnergyData[3]["energy_requirement"].toDouble(), color: Colors.blue, width: 16),
          BarChartRodData(toY: scaledEnergyData[3]["energy_availability"].toDouble(), color: Colors.green, width: 16),
        ],
      ),
    ];
  }
}