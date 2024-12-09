import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SalaryHistogram extends StatelessWidget {
  final Map<String, dynamic> data;

  const SalaryHistogram({Key? key, required this.data}) : super(key: key);

  Widget _buildStatistic(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<BarChartGroupData> barGroups = [];
    final counts = List<int>.from(data['counts']);
    final binEdges = List<double>.from(data['bin_edges']);
    final statistics = data['statistics'];

    for (int i = 0; i < counts.length; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: counts[i].toDouble(),
              color: Colors.blue.withOpacity(0.7),
              width: 20,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(5)),
            ),
          ],
        ),
      );
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 24.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Salary Distribution',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 450,
              child: Column(
                children: [
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatistic('Mean',
                              '\$${statistics['mean'].toStringAsFixed(0)}'),
                          _buildStatistic('Median',
                              '\$${statistics['median'].toStringAsFixed(0)}'),
                          _buildStatistic('Min',
                              '\$${statistics['min'].toStringAsFixed(0)}'),
                          _buildStatistic('Max',
                              '\$${statistics['max'].toStringAsFixed(0)}'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: counts.reduce((a, b) => a > b ? a : b) * 1.2,
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(fontSize: 10),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final int index = value.toInt();
                                if (index >= 0 && index < binEdges.length - 1) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Transform.rotate(
                                      angle: -0.5,
                                      child: Text(
                                        '\$${(binEdges[index] / 1000).toStringAsFixed(0)}k-'
                                        '\$${(binEdges[index + 1] / 1000).toStringAsFixed(0)}k',
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    ),
                                  );
                                }
                                return const Text('');
                              },
                            ),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval:
                              counts.reduce((a, b) => a > b ? a : b) / 5,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.grey.withOpacity(0.3),
                              strokeWidth: 1,
                            );
                          },
                        ),
                        barGroups: barGroups,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Salary Distribution (Number of Employees per Salary Range)',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
