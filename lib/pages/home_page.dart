import 'package:flutter/material.dart';
import '../services/analytics_service.dart';
import '../widgets/charts/age_pie_chart.dart';
import '../widgets/charts/city_treemap.dart';
import '../widgets/charts/salary_histogram.dart';
import '../widgets/profile_dialog.dart';
import 'login_page.dart';
import '../config/api_endpoints.dart';

class HomePage extends StatefulWidget {
  final String token;
  const HomePage({super.key, required this.token});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final AnalyticsService _analyticsService;
  Map<String, dynamic>? cityData;
  Map<String, dynamic>? ageRangeData;
  Map<String, dynamic>? salaryHistogramData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _analyticsService = AnalyticsService(
      baseUrl: ApiEndpoints.baseUrl,
      token: widget.token,
    );
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() => _isLoading = true);
    try {
      final cityResponse = await _analyticsService.fetchCityData();
      final ageResponse = await _analyticsService.fetchAgeRangeData();
      final salaryResponse = await _analyticsService.fetchSalaryHistogram();

      setState(() {
        cityData = cityResponse;
        ageRangeData = ageResponse;
        salaryHistogramData = salaryResponse;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handleProfile() async {
    final result = await showDialog(
      context: context,
      builder: (context) => ProfileDialog(token: widget.token),
    );

    if (result == 'deleted') {
      _handleLogout();
    } else if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _handleLogout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Data Analytics Dashboard',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
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
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Loading analytics data...',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: fetchData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (ageRangeData != null)
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
                                  child: AgePieChart(data: ageRangeData!),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (cityData != null) CityTreemap(data: cityData!),
                      if (salaryHistogramData != null)
                        SalaryHistogram(data: salaryHistogramData!),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
