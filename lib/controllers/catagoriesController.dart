import 'package:get/get.dart';
import 'package:webpfe/Services/CategoryService.dart';
import 'package:webpfe/models/Category.dart';

class CategoryController extends GetxController {
  final CategoryService _service = CategoryService();

  var categories = <Category>[].obs;
  var categoryDetails = Rxn<Category>();
  var isLoading = false.obs;

  Future<void> fetchCategories() async {
    isLoading(true);
    try {
      final fetchedCategories = await _service.fetchCategories();
      categories.assignAll(fetchedCategories);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load categories: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> getCategoryById(int id) async {
    isLoading(true);
    try {
      final fetchedCategory = await _service.getCategoryById(id);
      categoryDetails.value = fetchedCategory;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load category: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> createCategory(String description, String designation) async {
    isLoading(true);
    try {
      await _service.createCategory(description, designation);
      fetchCategories();
      // Get.snackbar('Success', 'Category created successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to create category: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateCategory(int id, String description, String designation) async {
    isLoading(true);
    try {
      await _service.updateCategory(id, description, designation);
      fetchCategories();
      // Get.snackbar('Success', 'Category updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update category: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteCategory(int id) async {
    isLoading(true);
    try {
      await _service.deleteCategory(id);
      fetchCategories();
      // Get.snackbar('Success', 'Category deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete category: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> searchCategories(String query) async {
    isLoading(true);
    try {
      final searchedCategories = await _service.searchCategories(query);
      categories.assignAll(searchedCategories);
    } catch (e) {
      Get.snackbar('Error', 'Failed to search categories: $e');
    } finally {
      isLoading(false);
    }
  }
}
