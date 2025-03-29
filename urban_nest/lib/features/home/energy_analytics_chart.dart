import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class EnergyAnalyticsChart extends StatelessWidget {
  final List<Map<String, dynamic>> energyData;

  const EnergyAnalyticsChart({
    super.key,
    required this.energyData,
  });

  @override
  Widget build(BuildContext context) {
    // Filter out non-state entries (like "All India", "Eastern Region", etc.)
    final stateData = energyData.where((data) {
      final state = data["State"].toString().trim();
      return !state.contains("Region") && state != "All India";
    }).toList();

    // Calculate total demand and met values
    final totalDemand = stateData.fold<double>(
      0,
          (sum, item) => sum + double.parse(item["peak_demand"].toString()),
    );

    final totalMet = stateData.fold<double>(
      0,
          (sum, item) => sum + double.parse(item["peak_met"].toString()),
    );

    // Calculate deficit (demand - met)
    final deficit = totalDemand - totalMet;

    // Calculate percentages
    final metPercentage = (totalMet / totalDemand * 100).toStringAsFixed(1);
    final deficitPercentage = (deficit / totalDemand * 100).toStringAsFixed(1);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color.fromRGBO(225, 225, 254, 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Power Supply Analytics (June 2024)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _indicator(Colors.green, 'Demand Met (${metPercentage}%)'),
                const SizedBox(width: 10),
                _indicator(Colors.red, 'Deficit (${deficitPercentage}%)'),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 150,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: totalMet,
                      color: Colors.green,
                      radius: 40,
                      title: '${metPercentage}%',
                      titleStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    PieChartSectionData(
                      value: deficit,
                      color: Colors.red,
                      radius: 40,
                      title: '${deficitPercentage}%',
                      titleStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildStatsTable(stateData),
          ],
        ),
      ),
    );
  }

  Widget _indicator(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(text),
      ],
    );
  }

  Widget _buildStatsTable(List<Map<String, dynamic>> stateData) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white.withOpacity(0.7),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top States by Power Deficit',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
            },
            border: TableBorder.all(
              color: Colors.grey.shade300,
              width: 1,
              style: BorderStyle.solid,
            ),
            children: [
              const TableRow(
                decoration: BoxDecoration(color: Color(0xFFE6E6FA)),
                children: [
                  Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text('State', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text('Demand', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text('Met', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text('Deficit %', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              ..._getTopDeficitStates(stateData, 3).map((state) {
                final demand = double.parse(state["peak_demand"].toString());
                final met = double.parse(state["peak_met"].toString());
                final deficitPercent = ((demand - met) / demand * 100).toStringAsFixed(2);

                return TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(state["State"].toString().trim()),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(demand.toStringAsFixed(1)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(met.toStringAsFixed(1)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text('$deficitPercent%'),
                    ),
                  ],
                );
              }).toList(),
            ],
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getTopDeficitStates(List<Map<String, dynamic>> states, int count) {
    // Calculate deficit percentage for each state
    final statesWithDeficit = states.map((state) {
      final demand = double.parse(state["peak_demand"].toString());
      final met = double.parse(state["peak_met"].toString());
      final deficitPercent = (demand - met) / demand * 100;

      return {
        ...state,
        "deficit_percent": deficitPercent,
      };
    }).toList();

    // Sort by deficit percentage (descending)
    statesWithDeficit.sort((a, b) =>
        (b["deficit_percent"] as double).compareTo(a["deficit_percent"] as double)
    );

    // Return top states with deficit
    return statesWithDeficit.take(count).toList();
  }
}