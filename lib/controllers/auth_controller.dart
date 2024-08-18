// controllers/auth_controller.dart

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:webpfe/Services/auth_service.dart';
import 'package:webpfe/models/SignupModel.dart';
import 'package:webpfe/models/SignupResponse.dart';
import 'package:webpfe/models/login_request.dart';
import 'package:webpfe/models/login_response.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  final AuthService authService = Get.put(AuthService());


  Future<void> login(String email, String password) async {
    isLoading(true);
    try {
      LoginRequest loginRequest =
          LoginRequest(email: email, password: password);
      LoginResponse response = await authService.login(loginRequest);
      print('Login successful: ${response.token}');
      // Handle storing the token, userType, and userData as needed
    } catch (e) {
      // Handle error
      print('Login failed: $e');
    } finally {
      isLoading(false);
    }
  }


  Future<void> signup(String email, String password, String nom) async {
    isLoading(true);
    try {
      SignupModel signupModel =
          SignupModel(email: email, password: password, nom: nom);
      SignupResponse response = await authService.signup(signupModel);
      print('Signup successful: ${response.email}');
      if (response.success) {
        Get.snackbar('Success',
            'The registration process has been completed successfully');
      } else {
        Get.snackbar('Error', response.message ?? 'Signup failed');
      }
    } catch (e) {
      // Handle error
      print('Signup failed: $e');
      Get.snackbar('Error', 'Signup failed');
    } finally {
      isLoading(false);
    }
  }
}
