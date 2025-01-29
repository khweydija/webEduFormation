import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:webpfe/models/Departement.dart';
import 'package:webpfe/models/Specialite.dart';

class FormateurController extends GetxController {
  final String apiUrl =
      'http://localhost:8080/formateurs'; // Base URL for formateurs

  RxList<Formateur> formateurs = <Formateur>[]
      .obs; // List to store formateurs = [].obs; // List to store formateurs
  var formateurDetails = Rxn<Formateur>(); // Store specific formateur details
  var isLoading = false.obs; // To manage loading state for details

  // Method to create a new formateur
  Future<void> createFormateur({
    required String email,
    required String password,
    required String nom,
    required String prenom,
    required String specialite,
    required Uint8List photoBytes, // Handle photo bytes for web
    required String photoFilename, // Filename for the photo
  }) async {
    final box = GetStorage();
    String? token = box.read('token');
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('$apiUrl/create/formateur'))
            ..fields['email'] = email
            ..fields['password'] = password
            ..fields['prenom'] = prenom
            ..fields['nom'] = nom
            ..fields['specialite'] = specialite
            ..files.add(http.MultipartFile.fromBytes('photo', photoBytes,
                filename: photoFilename,
                contentType: MediaType('image', 'jpeg')))
            ..headers['Authorization'] = 'Bearer $token'; // Send photo as bytes

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
    required String prenom,
    required String email,
    required String specialite,
    required bool active,
    Uint8List? photoBytes, // Optionally update the photo
    String? photoFilename,
  }) async {
    final box = GetStorage();
    String? token = box.read('token');
    try {
      var request =
          http.MultipartRequest('PUT', Uri.parse('$apiUrl/update/$id'))
            ..fields['nom'] = nom
            ..fields['prenom'] = prenom
            ..fields['email'] = email
            ..fields['specialite'] = specialite
            ..fields['active'] = active.toString()
            ..headers['Authorization'] = 'Bearer $token';

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
    final box = GetStorage();
    String? token = box.read('token');
    try {
      var response = await http.delete(Uri.parse('$apiUrl/delete/$id'),
          headers: {'Authorization': 'Bearer $token'});
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

  RxList<Formateur> filteredFormateurs =
      <Formateur>[].obs; // For filtered results

  @override
  void onInit() {
    super.onInit();
    fetchAllFormateurs();
  }

  // Fetch all formateurs
  Future<void> fetchAllFormateurs() async {
    final box = GetStorage();
    String? token = box.read('token');
    try {
      isLoading(true);
      var response = await http.get(Uri.parse('$apiUrl/list'),
          headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        List<Formateur> data =
            jsonData.map((item) => Formateur.fromJson(item)).toList();
        formateurs.assignAll(data);
        filteredFormateurs.assignAll(data); // Initialize filtered list
      } else {
        Get.snackbar('Error', 'Failed to load formateurs');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }

  // Filter formateurs by name
  void filterFormateurs(String query) {
    if (query.isEmpty) {
      filteredFormateurs.assignAll(formateurs); // Reset filter
    } else {
      filteredFormateurs.assignAll(
        formateurs
            .where((formateur) =>
                formateur.nom.toLowerCase().contains(query.toLowerCase()) ||
                formateur.prenom.toLowerCase().contains(query.toLowerCase()))
            .toList(),
      );
    }
  }

  // Method to fetch details of a specific formateur by ID
  Future<void> getFormateurDetails(int id) async {
    final box = GetStorage();
    String? token = box.read('token');
    try {
      isLoading(true);
      var response = await http.get(
        Uri.parse('$apiUrl/Formateur/$id'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        // Parse JSON response to Formateur object
        formateurDetails.value = Formateur.fromJson(json.decode(response.body));
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

class Formateur {
  final int id;
  final String nom;
  final String prenom;

  final String email;
  final Specialite specialite;
  final String photo;
  final bool active;

  Formateur({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.active,
    required this.photo,
    required this.specialite,
  });

  // Factory constructor for parsing JSON
  factory Formateur.fromJson(Map<String, dynamic> json) {
    return Formateur(
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
