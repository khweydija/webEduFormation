import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateFController extends GetxController {
  final String apiUrl = 'http://localhost:8080/formateurs/update/';

  // Method to update a formateur by ID
  Future<void> updateFormateur({
    required int id,
    required String nom,
    required String email,
    required String password,
    required String specialite,
    required String departement,
    bool? active,
    String? photoPath, // This can be null if the photo is not updated
  }) async {
    try {
      var request = http.MultipartRequest('PUT', Uri.parse(apiUrl + id.toString()));

      // Adding the fields to the request
      request.fields['nom'] = nom;
      request.fields['email'] = email;
      request.fields['password'] = password;
      request.fields['specialite'] = specialite;
      request.fields['departement'] = departement;
      if (active != null) {
        request.fields['active'] = active.toString();
      }

      // Adding the photo file if it is not null
      if (photoPath != null) {
        request.files.add(await http.MultipartFile.fromPath('photo', photoPath));
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Formateur updated successfully');
      } else {
        var responseBody = await response.stream.bytesToString();
        Get.snackbar('Error', 'Failed to update formateur: $responseBody');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }
}
