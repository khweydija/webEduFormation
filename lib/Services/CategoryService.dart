import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:webpfe/models/Category.dart';

class CategoryService {
  final String apiUrl = 'http://localhost:8080/api/categories';
  final box = GetStorage();

  Future<List<Category>> fetchCategories() async {
    String? token = box.read('token');
    final response = await http.get(
      Uri.parse('$apiUrl/listAll'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Category.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch categories');
    }
  }

  Future<Category> getCategoryById(int id) async {
    String? token = box.read('token');
    final response = await http.get(
      Uri.parse('$apiUrl/getbyId/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return Category.fromJson(json.decode(response.body));
    } else {
      throw Exception('Category not found');
    }
  }

  Future<void> createCategory(String description, String designation) async {
    String? token = box.read('token');
    final response = await http.post(
      Uri.parse('$apiUrl/create'),
      headers: {
        'Authorization': 'Bearer $token',
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        'description': description,
        'designation': designation,
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to create category');
    }
  }

  Future<void> updateCategory(
      int id, String description, String designation) async {
    String? token = box.read('token');
    final response = await http.put(
      Uri.parse('$apiUrl/update/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        'description': description,
        'designation': designation,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update category');
    }
  }

  Future<void> deleteCategory(int id) async {
    String? token = box.read('token');
    final response = await http.delete(
      Uri.parse('$apiUrl/delete/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete category');
    }
  }

  Future<List<Category>> searchCategories(String query) async {
    String? token = box.read('token');
    final response = await http.get(
      Uri.parse('$apiUrl/search?query=$query'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Category.fromJson(item)).toList();
    } else {
      throw Exception('No categories found');
    }
  }
}
