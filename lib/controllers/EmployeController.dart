import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'package:url_launcher/url_launcher.dart';
import 'package:webpfe/models/Specialite.dart';

class EmployeController extends GetxController {
  final String apiUrl =
      'http://localhost:8080/employes'; // Base URL for employees

  RxList employes = <Employe>[].obs; // List to store all employees
  RxList<Employe> filteredEmployes =
      <Employe>[].obs; // List to store filtered employees based on search query
  var employeDetails = Rxn<Employe>(); // Store specific employee details
  var isLoading = false.obs; // To manage loading state for details
  // var selectedEmploye =
  //     Rxn<Employe>(); // To store a selected employee's details

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
    required String prenom,
    required String specialite,
    required html.File photo,
    required html.File diplome,
  }) async {
    final box = GetStorage();
    String? token = box.read('token');
    try {
      Uint8List photoBytes = await _convertFileToUint8List(photo);
      Uint8List diplomeBytes = await _convertFileToUint8List(diplome);

      var request =
          http.MultipartRequest('POST', Uri.parse('$apiUrl/create/employe'))
            ..fields['email'] = email
            ..fields['password'] = password
            ..fields['nom'] = nom
            ..fields['prenom'] = prenom
            ..fields['nomSpecialite'] = specialite
            ..files.add(http.MultipartFile.fromBytes('photo', photoBytes,
                filename: photo.name))
            ..files.add(http.MultipartFile.fromBytes('diplome', diplomeBytes,
                filename: diplome.name))
            ..headers['Authorization'] = 'Bearer $token'; // Send photo as bytes

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
    final box = GetStorage();
    String? token = box.read('token');
    try {
      var response = await http.get(Uri.parse('$apiUrl/list'),
          headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        List<Employe> data =
            jsonData.map((item) => Employe.fromJson(item)).toList();
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
    final box = GetStorage();
    String? token = box.read('token');
    try {
      isLoading(true);
      var response = await http.get(Uri.parse('$apiUrl/Employe/$id'),
          headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        employeDetails.value = Employe.fromJson(json.decode(response.body));
      } else {
        Get.snackbar('Error', 'Employee not found');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }

  ///

  // Method to update an existing employee (Web compatible)
  Future<void> updateEmploye({
    required int id,
    required String email,
    required String prenom,
    required String nom,
    required String specialite,
    required bool active,
    String? password, // Optional password
    html.File? photo, // Optional photo file
    html.File? diplome, // Optional diplome file
  }) async {
    final box = GetStorage();
    String? token = box.read('token');
    print("id: $id, email: $email, nom: $nom, specialite: $specialite, active: $active, password: $password, photo: $photo, diplome: $diplome");
    

    try {
      var request =
          http.MultipartRequest('PUT', Uri.parse('$apiUrl/update/$id'))
            ..fields['email'] = email
            ..fields['nom'] = nom
            ..fields['prenom'] = prenom
            ..fields['nomSpecialite'] = specialite
            ..fields['password'] = password ?? ''
            ..fields['active'] = active.toString()
            ..headers['Authorization'] = 'Bearer $token';

      if (photo != null) {
        Uint8List photoBytes = await _convertFileToUint8List(photo);
        request.files.add(http.MultipartFile.fromBytes('photo', photoBytes,
            filename: photo.name));
      }
      if (diplome != null) {
        Uint8List diplomeBytes = await _convertFileToUint8List(diplome);
        request.files.add(http.MultipartFile.fromBytes('diplome', diplomeBytes,
            filename: diplome.name));
      }
      var response = await request.send();
      var responseBody = await http.Response.fromStream(response);

      print(responseBody.body);
      print(responseBody.body);
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
    final box = GetStorage();
    String? token = box.read('token');
    try {
      var response = await http.delete(Uri.parse('$apiUrl/delete/$id'),
          headers: {'Authorization': 'Bearer $token'});
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
  // void searchEmploye(String query) {
  //   if (query.isEmpty) {
  //     filteredEmployes
  //         .assignAll(employes); // Show all employees if query is empty
  //   } else {
  //     filteredEmployes.assignAll(employes.where((employe) {
  //       var name = employe['nom'].toLowerCase();
  //       var email = employe['email'].toLowerCase();
  //       var departement = employe['departement'].toLowerCase();
  //       return name.contains(query.toLowerCase()) ||
  //           email.contains(query.toLowerCase()) ||
  //           departement.contains(query.toLowerCase());
  //     }).toList());
  //   }
  // }

  // Method to open diplome in a new tab using URL launcher
  void openDiplome(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Error', 'Could not open diplome');
    }
  }
}

class Employe {
  final int id;
  final String nom;
  final String prenom;
  final String email;
  final String diplome;

  final Specialite specialite;
  final String photo;
  final bool active;

  Employe({
    required this.diplome,
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.active,
    required this.photo,
    required this.specialite,
  });

  // Factory constructor for parsing JSON
  factory Employe.fromJson(Map<String, dynamic> json) {
    return Employe(
      diplome: json['diplome'],
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      active: json['active'],
      photo: json['photo'],
      specialite: Specialite.fromJson(json['specialite']),
    );
  }

  // Convert Specialite to JSON
  Map<String, dynamic> toJson() {
    return {
      'diplome': diplome,
      'email': email,
      'active': active,
      'photo': photo,
      'nom': nom,
      'prenom': prenom,
      'specialite': specialite.toJson(),
      'id': id,
    };
  }
}
