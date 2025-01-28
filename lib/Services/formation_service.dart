import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:webpfe/models/Formation.dart';

class FormationService extends GetxService {
  final String baseUrl = 'http://localhost:8080/api/formation';


  // New method to fetch the list of formations
  Future<List<Formation>> fetchFormationList() async {
    final box = GetStorage();
    String? token = box.read('token');

    final response = await http.get(
      Uri.parse('$baseUrl/list'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final String decodedBody = utf8.decode(response.bodyBytes);
      List<dynamic> jsonResponse = jsonDecode(decodedBody);

      // Parse each item into a Formation object
      return jsonResponse.map((data) => Formation.fromJson(data)).toList();
    } else {
      print('Failed to fetch formations: ${response.statusCode}, ${response.body}');
      throw Exception('Failed to fetch formations');
    }
  }
}
