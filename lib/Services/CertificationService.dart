import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:webpfe/models/Certification.dart';

class CertificationService {
  final String apiUrl = 'http://localhost:8080/api/certifications';
  final box = GetStorage();

  Future<List<Certification>> fetchCertifications() async {
    String? token = box.read('token');
    final response = await http.get(
      Uri.parse('$apiUrl/all'),
      headers: {'Authorization': 'Bearer $token'},
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Certification.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch certifications');
    }
  }

  Future<Certification> getCertificationById(int id) async {
    String? token = box.read('token');
    final response = await http.get(
      Uri.parse('$apiUrl/getbyid/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return Certification.fromJson(json.decode(response.body));
    } else {
      throw Exception('Certification not found');
    }
  }

  Future<void> createCertification(Certification certification) async {
    String? token = box.read('token');
    final response = await http.post(
      Uri.parse('$apiUrl/create'),
      headers: {
        'Authorization': 'Bearer $token',
        "Content-Type": "application/json",
      },
      body: jsonEncode(certification.toJson()),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to create certification');
    }
  }

  Future<void> updateCertification(Certification certification) async {
    String? token = box.read('token');
    final response = await http.put(
      Uri.parse('$apiUrl/update/${certification.id}'),
      headers: {
        'Authorization': 'Bearer $token',
        "Content-Type": "application/json",
      },
      body: jsonEncode(certification.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update certification');
    }
  }

  Future<void> deleteCertification(int id) async {
    String? token = box.read('token');
    final response = await http.delete(
      Uri.parse('$apiUrl/delete/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete certification');
    }
  }
}
