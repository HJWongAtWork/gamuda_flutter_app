import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class AnalyticsService {
  final String baseUrl;
  final BuildContext context;

  AnalyticsService({
    required this.baseUrl,
    required this.context,
  });

  // Get headers with current token
  Map<String, String> get _headers {
    final authService = Provider.of<AuthService>(context, listen: false);
    final token = authService.getCurrentToken();
    return {
      'Authorization': 'Bearer ${token ?? ''}',
      'Content-Type': 'application/json', // Add this if needed
    };
  }

  Future<Map<String, dynamic>> fetchCityData() async {
    final response = await http.post(
      Uri.parse('$baseUrl/analytics/by_city'),
      headers: _headers,
    );
    
    if (response.statusCode == 401) {
      throw Exception('Unauthorized access');
    }
    
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> fetchAgeRangeData() async {
    final response = await http.post(
      Uri.parse('$baseUrl/analytics/by_age_range'),
      headers: _headers,
    );
    
    if (response.statusCode == 401) {
      throw Exception('Unauthorized access');
    }
    
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> fetchSalaryHistogram() async {
    final response = await http.post(
      Uri.parse('$baseUrl/analytics/salary_histogram'),
      headers: _headers,
    );
    
    if (response.statusCode == 401) {
      throw Exception('Unauthorized access');
    }
    
    return json.decode(response.body);
  }
}