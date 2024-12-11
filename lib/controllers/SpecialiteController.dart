import 'package:get/get.dart';
import 'package:webpfe/Services/SpecialiteService.dart';
import 'package:webpfe/models/Specialite.dart';


class SpecialiteController extends GetxController {
  final SpecialiteService _service = SpecialiteService();

  var specialites = <Specialite>[].obs;
  var specialiteDetails = Rxn<Specialite>();
  var isLoading = false.obs;

  // Fetch all specialities
  Future<void> fetchSpecialites() async {
    isLoading(true);
    try {
      final fetchedSpecialites = await _service.fetchSpecialites();
      specialites.assignAll(fetchedSpecialites);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load specialities: $e');
    } finally {
      isLoading(false);
    }
  }

  // Get speciality by ID
  Future<void> getSpecialiteById(int id) async {
    isLoading(true);
    try {
      final fetchedSpecialite = await _service.getSpecialiteById(id);
      specialiteDetails.value = fetchedSpecialite;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load speciality: $e');
    } finally {
      isLoading(false);
    }
  }

  // Create a speciality
  Future<void> createSpecialite(String nom, String description, String nomDepartement) async {
    isLoading(true);
    try {
      await _service.createSpecialite(nom, description, nomDepartement);
      fetchSpecialites();
      Get.snackbar('Success', 'Speciality created successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to create speciality: $e');
    } finally {
      isLoading(false);
    }
  }

  // Update a speciality
  Future<void> updateSpecialite(
      int id, String nom, String description, String nomDepartement) async {
    isLoading(true);
    try {
      await _service.updateSpecialite(id, nom, description, nomDepartement);
      fetchSpecialites();
      Get.snackbar('Success', 'Speciality updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update speciality: $e');
    } finally {
      isLoading(false);
    }
  }

  // Delete a speciality
  Future<void> deleteSpecialite(int id) async {
    isLoading(true);
    try {
      await _service.deleteSpecialite(id);
      fetchSpecialites();
      Get.snackbar('Success', 'Speciality deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete speciality: $e');
    } finally {
      isLoading(false);
    }
  }
}
