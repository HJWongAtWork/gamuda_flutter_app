import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import '../config/api_endpoints.dart';

class AuthService with ChangeNotifier {
  String? _token;
  bool _isLoading = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb
        ? '1070221102883-tujj6lig8863tslrepp5d3gpep9s9v5q.apps.googleusercontent.com'
        : null,
    scopes: [
      'email',
      'profile',
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );

  // Getters
  String? get token => _token;
  bool get isLoading => _isLoading;

  // Google Sign In
  Future<String?> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Use either ID token or access token
      final token = googleAuth.idToken ?? googleAuth.accessToken;
      if (token == null) {
        print('Error: No token received from Google');
        return null;
      }

      // Send token directly to callback endpoint
      final callbackResponse = await http.post(
        Uri.parse('${ApiEndpoints.auth.googleCallback}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'token': token,
          'token_type':
              googleAuth.idToken != null ? 'id_token' : 'access_token',
          'provider': 'google',
          'email': googleUser.email,
          'name': googleUser.displayName,
        }),
      );

      if (callbackResponse.statusCode == 200) {
        final responseData = json.decode(callbackResponse.body);
        _token = responseData['access_token'];
        notifyListeners();
        return _token;
      } else {
        print('Error: Backend returned ${callbackResponse.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Local authentication
  Future<String> signInWithLocal(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.auth.login),
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
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
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

  // Update token
  Future<void> updateToken(String newToken) async {
    _token = newToken;
    notifyListeners();
  }

  // Refresh token
  Future<String?> refreshToken() async {
    return _token;
  }
}
