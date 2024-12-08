import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? cityData;
  Map<String, dynamic>? ageRangeData;
  Map<String, dynamic>? salaryHistogramData;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final baseUrl = 'http://localhost:8000';

    try {
      final cityResponse =
          await http.post(Uri.parse('$baseUrl/analytics/by_city'));
      final ageResponse =
          await http.post(Uri.parse('$baseUrl/analytics/by_age_range'));
      final salaryResponse =
          await http.post(Uri.parse('$baseUrl/analytics/salary_histogram'));

      setState(() {
        cityData = json.decode(cityResponse.body);
        ageRangeData = json.decode(ageResponse.body);
        salaryHistogramData = json.decode(salaryResponse.body);
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void _handleProfile() {
    // Empty profile function
  }

  void _handleLogout() {
    // Empty logout function
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Data Analytics Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.grey[100],
        elevation: 2,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'profile':
                  _handleProfile();
                  break;
                case 'refresh':
                  fetchData();
                  break;
                case 'logout':
                  _handleLogout();
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person, color: Colors.grey),
                    SizedBox(width: 8),
                    Text('Profile'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'refresh',
                child: Row(
                  children: [
                    Icon(Icons.refresh, color: Colors.grey),
                    SizedBox(width: 8),
                    Text('Refresh'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.grey),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 24.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Users by Age Range',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 300,
                        child: _buildAgePieChart(),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 24.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Users by City',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 400,
                        child: _buildCityTreemap(),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
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
                        child: _buildSalaryHistogram(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAgePieChart() {
    if (ageRangeData == null)
      return const Center(child: CircularProgressIndicator());

    List<PieChartSectionData> sections = [];
    int colorIndex = 0;
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
    ];

    ageRangeData!.forEach((range, data) {
      sections.add(
        PieChartSectionData(
          value: data['count'].toDouble(),
          title: '$range\n${data['count']}',
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

  Widget _buildCityTreemap() {
    if (cityData == null)
      return const Center(child: CircularProgressIndicator());

    final sortedCities = cityData!.entries.toList()
      ..sort((a, b) => (b.value['id'] as num).compareTo(a.value['id'] as num));

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: sortedCities.map((entry) {
              final proportion = (entry.value['id'] as num).toDouble() /
                  (sortedCities[0].value['id'] as num).toDouble();
              final double bubbleSize = (120.0 * proportion).clamp(60.0, 120.0);

              return SizedBox(
                width: bubbleSize,
                height: bubbleSize,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.primaries[sortedCities.indexOf(entry) %
                            Colors.primaries.length]
                        .withOpacity(0.8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${entry.key}: ${entry.value['id']} users\n'
                              'Avg Salary: \$${(entry.value['salary'] as num).round()}\n'
                              'Avg Age: ${(entry.value['age'] as num).round()}',
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(bubbleSize / 2),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              entry.key,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: bubbleSize * 0.12,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: bubbleSize * 0.05),
                            Text(
                              '${entry.value['id']} users',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: bubbleSize * 0.1,
                              ),
                            ),
                            Text(
                              '\$${(entry.value['salary'] as num).round()}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: bubbleSize * 0.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildSalaryHistogram() {
    if (salaryHistogramData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final List<BarChartGroupData> barGroups = [];
    final counts = List<int>.from(salaryHistogramData!['counts']);
    final binEdges = List<double>.from(salaryHistogramData!['bin_edges']);
    final statistics = salaryHistogramData!['statistics'];

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

    return Column(
      children: [
        Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatistic(
                    'Mean', '\$${statistics['mean'].toStringAsFixed(0)}'),
                _buildStatistic(
                    'Median', '\$${statistics['median'].toStringAsFixed(0)}'),
                _buildStatistic(
                    'Min', '\$${statistics['min'].toStringAsFixed(0)}'),
                _buildStatistic(
                    'Max', '\$${statistics['max'].toStringAsFixed(0)}'),
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
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: counts.reduce((a, b) => a > b ? a : b) / 5,
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
    );
  }

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
}
