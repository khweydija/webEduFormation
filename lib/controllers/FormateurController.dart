import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FormateurController extends GetxController {
  final String apiUrl = 'http://localhost:8080/formateurs'; // Base URL for formateurs

  // List to store formateurs
  var formateurs = [].obs;
  var formateurDetails = {}.obs; // Store specific formateur details
  var isLoading = false.obs; // To manage loading state for details

  // Method to create a new formateur
  Future<void> createFormateur({
    required String email,
    required String password,
    required String nom,
    required String specialite,
    required String departement,
    required Uint8List photoBytes, // Updated to handle photo bytes for web
    required String photoFilename, // The filename for the photo
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$apiUrl/create/formateur'))
        ..fields['email'] = email
        ..fields['password'] = password
        ..fields['nom'] = nom
        ..fields['specialite'] = specialite
        ..fields['departement'] = departement
        ..files.add(http.MultipartFile.fromBytes('photo', photoBytes, filename: photoFilename)); // Send photo as bytes

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
  /////
  /// // Method to update an existing formateur with the possibility to update the image
  Future<void> updateFormateur({
    required int id,
    required String email,
    required String nom,
    required String specialite,
    required String departement,
    required bool active,
    String? password,
    File? photo, // Optional photo file
  }) async {
    try {
      var request = http.MultipartRequest('PUT', Uri.parse('$apiUrl/update/$id'))
        ..fields['email'] = email
        ..fields['nom'] = nom
        ..fields['specialite'] = specialite
        ..fields['departement'] = departement
        ..fields['active'] = active.toString();

      // If a new password is provided, update it
      if (password != null) {
        request.fields['password'] = password;
      }

      // If a new photo is selected, add it to the request
      if (photo != null) {
        request.files.add(await http.MultipartFile.fromPath('photo', photo.path));
      }

      var response = await request.send();
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Formateur updated successfully');
        fetchAllFormateurs(); // Refresh the list after update
      } else {
        Get.snackbar('Error', 'Failed to update formateur');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }
////////////
///
///
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
      var response = await http.get(Uri.parse('$apiUrl/Formateur/$id'));
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
