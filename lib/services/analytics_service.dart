import 'package:http/http.dart' as http;
import 'dart:convert';

class AnalyticsService {
  final String baseUrl;
  final String token;

  AnalyticsService({required this.baseUrl, required this.token});

  Map<String, String> get _headers => {
        'Authorization': 'Bearer $token',
      };

  Future<Map<String, dynamic>> fetchCityData() async {
    final response = await http.post(
      Uri.parse('$baseUrl/analytics/by_city'),
      headers: _headers,
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> fetchAgeRangeData() async {
    final response = await http.post(
      Uri.parse('$baseUrl/analytics/by_age_range'),
      headers: _headers,
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> fetchSalaryHistogram() async {
    final response = await http.post(
      Uri.parse('$baseUrl/analytics/salary_histogram'),
      headers: _headers,
    );
    return json.decode(response.body);
  }
}
