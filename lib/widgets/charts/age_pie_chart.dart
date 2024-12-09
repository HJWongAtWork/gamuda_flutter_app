import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AgePieChart extends StatelessWidget {
  final Map<String, dynamic> data;

  const AgePieChart({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> sections = [];
    int colorIndex = 0;
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
    ];

    data.forEach((range, rangeData) {
      sections.add(
        PieChartSectionData(
          value: rangeData['count'].toDouble(),
          title: '$range\n${rangeData['count']}',
          color: colors[colorIndex % colors.length],
          radius: 100,
          titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
        ),
      );
      colorIndex++;
    });

    return PieChart(
      PieChartData(
        sections: sections,
        sectionsSpace: 2,
        centerSpaceRadius: 40,
      ),
    );
  }
}
