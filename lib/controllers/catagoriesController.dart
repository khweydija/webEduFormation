import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CategorieController extends GetxController {
  final String apiUrl = 'http://localhost:8080/api/categories';
  var categories = [].obs;
  var categorieDetails = {}.obs;
  var isLoading = false.obs;

  // Fetch all categories from the backend
  Future<void> fetchCategories() async {
    isLoading(true);
    try {
      var response = await http.get(Uri.parse('$apiUrl/listAll'));
      if (response.statusCode == 200) {
        categories.assignAll(json.decode(response.body));
      } else {
        Get.snackbar('Error', 'Failed to load categories');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }

  // Fetch a single category by ID
  Future<void> getCategorieById(int id) async {
    isLoading(true);
    try {
      var response = await http.get(Uri.parse('$apiUrl/getbyId/$id'));
      if (response.statusCode == 200) {
        categorieDetails.value = json.decode(response.body); // Save details
      } else {
        Get.snackbar('Error', 'Category not found');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }

  // Update a category
  Future<void> updateCategorie(int id, String description, String designation) async {
    isLoading(true);
    try {
      var response = await http.put(
        Uri.parse('$apiUrl/update/$id'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'description': description,
          'designation': designation,
        }),
      );

      if (response.statusCode == 200) {
        fetchCategories(); // Refresh list after updating
        Get.snackbar('Success', 'Category updated successfully');
      } else if (response.statusCode == 409) {
        Get.snackbar('Error', 'Designation already exists');
      } else {
        Get.snackbar('Error', 'Failed to update category');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }

  // Delete a category
  Future<void> deleteCategorie(int id) async {
    isLoading(true);
    try {
      var response = await http.delete(Uri.parse('$apiUrl/delete/$id'));
      if (response.statusCode == 200) {
        fetchCategories(); // Refresh list after deletion
        Get.snackbar('Success', 'Category deleted successfully');
      } else {
        Get.snackbar('Error', 'Failed to delete category');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }

  // Create a new category
  Future<void> createCategorie(String description, String designation) async {
    isLoading(true);
    try {
      var response = await http.post(
        Uri.parse('$apiUrl/create'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'description': description,
          'designation': designation,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        fetchCategories(); // Refresh the categories list after creation
        Get.snackbar('Success', 'Category created successfully');
      } else if (response.statusCode == 409) {
        Get.snackbar('Error', 'Designation already exists');
      } else {
        Get.snackbar('Error', 'Failed to create category');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }

  // Search categories by description or designation
  Future<void> searchCategories(String query) async {
    isLoading(true);
    try {
      var response = await http.get(Uri.parse('$apiUrl/search?query=$query'));
      if (response.statusCode == 200) {
        categories.assignAll(json.decode(response.body));
      } else {
        Get.snackbar('Error', 'No categories found');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }
}
