// services/auth_service.dart
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:webpfe/models/SignupModel.dart';
import 'package:webpfe/models/SignupResponse.dart';
import 'package:webpfe/models/login_request.dart';
import 'package:webpfe/models/login_response.dart';
import 'package:webpfe/AppRoutes.dart'; // Import your AppRoutes

class AuthService {
  final String baseUrl = 'http://localhost:8080/auth';

  Future<LoginResponse> login(LoginRequest loginRequest) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(loginRequest.toJson()),
    );

    if (response.statusCode == 200) {
      // Navigate to StatisticsPage after a successful login
      Get.offNamed(AppRoutes.statisticsPage);
      return LoginResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<SignupResponse> signup(SignupModel signupModel) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup/admin'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(signupModel.toJson()),
    );

    if (response.statusCode == 200) {
      Get.snackbar('Success', 'Registration successful');
      return SignupResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to signup');
    }
  }
}
