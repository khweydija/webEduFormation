import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart'; // For opening URLs

class EmployeController extends GetxController {
  final String apiUrl =
      'http://localhost:8080/employes'; // Base URL for employees

  var employes = [].obs; // List to store all employees
  var filteredEmployes =
      [].obs; // List to store filtered employees based on search query
  var employeDetails = {}.obs; // Store specific employee details
  var isLoading = false.obs; // To manage loading state for details
  var selectedEmploye = {}.obs; // To store a selected employee's details

  // Method to create a new employee
  Future<http.StreamedResponse?> createEmploye({
    required String email,
    required String password,
    required String nom,
    required String departement,
    required Uint8List photoBytes,
    required String photoFilename,
    required Uint8List diplomeBytes,
    required String diplomeFilename,
  }) async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('$apiUrl/create/employe'))
            ..fields['email'] = email
            ..fields['password'] = password
            ..fields['nom'] = nom
            ..fields['departement'] = departement
            ..files.add(http.MultipartFile.fromBytes('photo', photoBytes,
                filename: photoFilename))
            ..files.add(http.MultipartFile.fromBytes('diplome', diplomeBytes,
                filename: diplomeFilename));

      var response = await request.send();
      return response;
    } catch (e) {
      print("Error during employee creation: $e");
      Get.snackbar('Error', 'An error occurred: $e');
      return null;
    }
  }

  // Method to fetch all employees (useful for initial loading)
  Future<void> fetchAllEmployes() async {
    try {
      var response = await http.get(Uri.parse('$apiUrl/list'));
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        employes.assignAll(data);
        filteredEmployes
            .assignAll(data); // Initially set filtered list to all employees
      } else {
        Get.snackbar('Error', 'Failed to load employees');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }

  // Method to fetch details of a specific employee by ID
  Future<void> getEmployeById(int id) async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse('$apiUrl/Employe/$id'));
      if (response.statusCode == 200) {
        selectedEmploye.value = json.decode(response.body);
      } else {
        Get.snackbar('Error', 'Employee not found');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }

  // Method to update an existing employee with the possibility to update the image and diplome
  Future<void> updateEmploye({
    required int id,
    required String email,
    required String nom,
    required String departement,
    required bool active,
    String? password, // Optional password
    File? photo, // Optional photo file
    File? diplome, // Optional diplome file
  }) async {
    try {
      var request =
          http.MultipartRequest('PUT', Uri.parse('$apiUrl/update/$id'))
            ..fields['email'] = email
            ..fields['nom'] = nom
            ..fields['departement'] = departement
            ..fields['password'] = "hhhhhh"
            ..fields['active'] = active.toString();

      // Send file without worrying about the filename
      if (photo != null) {
        request.files
            .add(await http.MultipartFile.fromPath('photo', photo.path));
      }

      if (diplome != null) {
        request.files
            .add(await http.MultipartFile.fromPath('diplome', diplome.path));
      }

      var response = await request.send();
      var responseBody = await http.Response.fromStream(response);
      print(responseBody.body); // Print the response body

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Employee updated successfully');
        fetchAllEmployes(); // Refresh the employee list after update
      } else {
        Get.snackbar('Error', 'Failed to update employee');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }

  // Method to delete an employee by ID
  Future<void> deleteEmploye(int id) async {
    try {
      var response = await http.delete(Uri.parse('$apiUrl/delete/$id'));
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Employee deleted successfully');
        fetchAllEmployes(); // Refresh list after deletion
      } else {
        Get.snackbar('Error', 'Failed to delete employee');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }

  // Search employees by query (name, email, or department)
  void searchEmploye(String query) {
    if (query.isEmpty) {
      filteredEmployes
          .assignAll(employes); // Show all employees if query is empty
    } else {
      filteredEmployes.assignAll(employes.where((employe) {
        var name = employe['nom'].toLowerCase();
        var email = employe['email'].toLowerCase();
        var departement = employe['departement'].toLowerCase();
        return name.contains(query.toLowerCase()) ||
            email.contains(query.toLowerCase()) ||
            departement.contains(query.toLowerCase());
      }).toList());
    }
  }

  // Method to open diplome in a new tab using URL launcher
  void openDiplome(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Error', 'Could not open diplome');
    }
  }
}
