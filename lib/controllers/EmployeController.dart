import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class EmployeController extends GetxController {
  final String apiUrl =
      'http://localhost:8080/employes'; // Base URL for employees

  var employes = [].obs; // List to store all employees
  var filteredEmployes =
      [].obs; // List to store filtered employees based on search query
  var employeDetails = {}.obs; // Store specific employee details
  var isLoading = false.obs; // To manage loading state for details
  var selectedEmploye = {}.obs; // To store a selected employee's details

  // Helper method to convert html.File to Uint8List
  Future<Uint8List> _convertFileToUint8List(html.File file) async {
    final reader = html.FileReader();
    reader.readAsArrayBuffer(file);
    await reader.onLoadEnd.first; // Wait for the file to finish loading
    return reader.result as Uint8List;
  }

  // Method to create a new employee (Web compatible)
  Future<http.StreamedResponse?> createEmploye({
    required String email,
    required String password,
    required String nom,
    required String departement,
    required html.File photo,
    required html.File diplome,
  }) async {
    try {
      Uint8List photoBytes = await _convertFileToUint8List(photo);
      Uint8List diplomeBytes = await _convertFileToUint8List(diplome);

      var request =
          http.MultipartRequest('POST', Uri.parse('$apiUrl/create/employe'))
            ..fields['email'] = email
            ..fields['password'] = password
            ..fields['nom'] = nom
            ..fields['departement'] = departement
            ..files.add(http.MultipartFile.fromBytes('photo', photoBytes,
                filename: photo.name))
            ..files.add(http.MultipartFile.fromBytes('diplome', diplomeBytes,
                filename: diplome.name));

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
        filteredEmployes.assignAll(data); // Set filtered list to all employees
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

  // Method to update an existing employee (Web compatible)
  Future<void> updateEmploye({
    required int id,
    required String email,
    required String nom,
    required String departement,
    required bool active,
    String? password, // Optional password
    html.File? photo, // Optional photo file
    html.File? diplome, // Optional diplome file
  }) async {
    try {
      var request =
          http.MultipartRequest('PUT', Uri.parse('$apiUrl/update/$id'))
            ..fields['email'] = email
            ..fields['nom'] = nom
            ..fields['departement'] = departement
            ..fields['password'] = password ?? ''
            ..fields['active'] = active.toString();

      // Handle photo file upload
      if (photo != null) {
        Uint8List photoBytes = await _convertFileToUint8List(photo);
        request.files.add(http.MultipartFile.fromBytes('photo', photoBytes,
            filename: photo.name));
      }

      // Handle diplome file upload
      if (diplome != null) {
        Uint8List diplomeBytes = await _convertFileToUint8List(diplome);
        request.files.add(http.MultipartFile.fromBytes('diplome', diplomeBytes,
            filename: diplome.name));
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
      filteredEmployes.assignAll(employes); // Show all employees if query is empty
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
