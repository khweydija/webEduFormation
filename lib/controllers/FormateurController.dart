import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';

class FormateurController extends GetxController {
  final String apiUrl = 'http://localhost:8080/formateurs'; // Base URL for formateurs

  var formateurs = [].obs; // List to store formateurs
  var formateurDetails = {}.obs; // Store specific formateur details
  var isLoading = false.obs; // To manage loading state for details

  // Method to create a new formateur
  Future<void> createFormateur({
    required String email,
    required String password,
    required String nom,
    required String specialite,
    required String departement,
    required Uint8List photoBytes, // Handle photo bytes for web
    required String photoFilename, // Filename for the photo
  }) async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('$apiUrl/create/formateur'))
            ..fields['email'] = email
            ..fields['password'] = password
            ..fields['nom'] = nom
            ..fields['specialite'] = specialite
            ..fields['departement'] = departement
            ..files.add(http.MultipartFile.fromBytes('photo', photoBytes,
                filename: photoFilename, contentType: MediaType('image', 'jpeg'))); // Send photo as bytes

      var response = await request.send();
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Formateur created successfully');
        fetchAllFormateurs(); // Refresh the list after creation
      } else {
        Get.snackbar('Error', 'Failed to create formateur');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }

  // Method to update an existing formateur
  Future<void> updateFormateur({
    required int id,
    required String nom,
    required String email,
    required String specialite,
    required String departement,
    required bool active,
    Uint8List? photoBytes, // Optionally update the photo
    String? photoFilename,
  }) async {
    try {
      var request =
          http.MultipartRequest('PUT', Uri.parse('$apiUrl/update/$id'))
            ..fields['nom'] = nom
            ..fields['email'] = email
            ..fields['specialite'] = specialite
            ..fields['departement'] = departement
            ..fields['active'] = active.toString();

      // Add photo if it's provided
      if (photoBytes != null && photoFilename != null) {
        request.files.add(http.MultipartFile.fromBytes('photo', photoBytes,
            filename: photoFilename, contentType: MediaType('image', 'jpeg')));
      }

      var response = await request.send();
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Formateur updated successfully');
        fetchAllFormateurs(); // Refresh the list after updating
      } else {
        Get.snackbar('Error', 'Failed to update formateur');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }

  // Method to delete a formateur by ID
  Future<void> deleteFormateur(int id) async {
    try {
      var response = await http.delete(Uri.parse('$apiUrl/delete/$id'));
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Formateur deleted successfully');
        fetchAllFormateurs(); // Refresh the list after deletion
      } else {
        Get.snackbar('Error', 'Failed to delete formateur');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }

  // Method to fetch all formateurs
  Future<void> fetchAllFormateurs() async {
    try {
      var response = await http.get(Uri.parse('$apiUrl/list'));
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        formateurs.assignAll(data); // Update the list of formateurs
      } else {
        Get.snackbar('Error', 'Failed to load formateurs');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }

  // Method to fetch details of a specific formateur by ID
  Future<void> getFormateurDetails(int id) async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse('$apiUrl/formateur/$id'));
      if (response.statusCode == 200) {
        formateurDetails.value = json.decode(response.body);
      } else {
        Get.snackbar('Error', 'Formateur not found');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }
}
