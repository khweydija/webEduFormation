import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:webpfe/models/Specialite.dart';

class SpecialiteService {
  final String apiUrl = 'http://localhost:8080/api/specialites';
  final box = GetStorage();

  // Fetch all specialities
  Future<List<Specialite>> fetchSpecialites() async {
    String? token = box.read('token');
    final response = await http.get(
      Uri.parse('$apiUrl/all'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final String decodedBody = utf8.decode(response.bodyBytes);

      final List<dynamic> data = json.decode(decodedBody);

      return data.map((item) => Specialite.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch specialities');
    }
  }

  // Get speciality by ID
  // Get speciality by ID
Future<Specialite> getSpecialiteById(int id) async {
  String? token = box.read('token');
  final response = await http.get(
    Uri.parse('$apiUrl/get/$id'),
    headers: {'Authorization': 'Bearer $token'},
  );

  if (response.statusCode == 200) {
    final String decodedBody = utf8.decode(response.bodyBytes); // Decode the response body
    return Specialite.fromJson(json.decode(decodedBody)); // Parse the JSON
  } else {
    throw Exception('Speciality not found');
  }
}


  // Create a speciality
  Future<void> createSpecialite(
      String nom, String description, String nomDepartement) async {
    String? token = box.read('token');
    final response = await http.post(
      Uri.parse('$apiUrl/create'),
      headers: {
        'Authorization': 'Bearer $token',
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        'nom': nom,
        'description': description,
        'nomDepartement': nomDepartement,
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to create speciality');
    }
  }

  // Update a speciality
  Future<void> updateSpecialite(
      int id, String nom, String description, String nomDepartement) async {
    String? token = box.read('token');
    final response = await http.put(
      Uri.parse('$apiUrl/update/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        'nom': nom,
        'description': description,
        'nomDepartement': nomDepartement,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update speciality');
    }
  }

  // Delete a speciality
  Future<void> deleteSpecialite(int id) async {
    String? token = box.read('token');
    final response = await http.delete(
      Uri.parse('$apiUrl/delete/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete speciality');
    }
  }

  // Fetch specialties by department ID
  Future<List<Specialite>> fetchSpecialitesByDepartement(
      int departementId) async {
    String? token = box.read('token');
    final response = await http.get(
      Uri.parse('$apiUrl/departement/$departementId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Specialite.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch specialties by department');
    }
  }
}
