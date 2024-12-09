import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService with ChangeNotifier {
  String? _token;
  bool _isLoading = false;

  // Getters
  String? get token => _token;
  bool get isLoading => _isLoading;

  // Local authentication
  Future<String> signInWithLocal(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8000/login'),
        body: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        _token = json.decode(response.body)['access_token'];
        notifyListeners();
        return _token!;
      }
      throw Exception(json.decode(response.body)['detail']);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sign out
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      _token = null;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Check if user is signed in
  bool isSignedIn() {
    return _token != null;
  }

  // Get current auth token
  String? getCurrentToken() {
    return _token;
  }

  // Refresh token if needed (you might want to implement token refresh with your backend)
  Future<String?> refreshToken() async {
    // Implement token refresh logic here if needed
    return _token;
  }
}
