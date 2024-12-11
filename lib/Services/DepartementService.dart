import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:webpfe/models/Departement.dart';

class DepartementService {
  final String apiUrl = 'http://localhost:8080/api/departements';
  final box = GetStorage();

  Future<List<Departement>> fetchDepartements() async {
    String? token = box.read('token');
    final response = await http.get(
      Uri.parse('$apiUrl/all'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Departement.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch departements');
    }
  }

  Future<Departement> getDepartementById(int id) async {
    String? token = box.read('token');
    final response = await http.get(
      Uri.parse('$apiUrl/get/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return Departement.fromJson(json.decode(response.body));
    } else {
      throw Exception('Departement not found');
    }
  }

  Future<void> createDepartement(String nom, String description) async {
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
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to create departement');
    }
  }

  Future<void> updateDepartement(int id, String nom, String description) async {
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
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update departement');
    }
  }

  Future<void> deleteDepartement(int id) async {
    String? token = box.read('token');
    final response = await http.delete(
      Uri.parse('$apiUrl/delete/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete departement');
    }
  }
}
