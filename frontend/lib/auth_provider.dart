import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class User {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
    );
  }
}

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  String? _token;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _token != null && _token!.isNotEmpty;

  // Use localhost for web target
  final String baseUrl = 'http://localhost:5000/api/v1';

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<bool> signUp({
    required String fullName,
    required String email,
    required String password,
    String phoneNumber = '',
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullName': fullName,
          'email': email,
          'password': password,
          'phoneNumber': phoneNumber,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data['status'] == 'success') {
        _setLoading(false);
        return true;
      } else {
        _setError(data['message'] ?? 'Sign up failed');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Network error: Unable to connect to server');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        _token = data['data']['token'];
        _currentUser = User.fromJson(data['data']['user']);
        _setLoading(false);
        return true;
      } else {
        _setError(data['message'] ?? 'Login failed');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Network error: Unable to connect to server');
      _setLoading(false);
      return false;
    }
  }

  void logout() {
    _token = null;
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }
}
