import 'package:get/get.dart';
import 'package:webpfe/Services/SpecialiteService.dart';
import 'package:webpfe/models/Specialite.dart';


class SpecialiteController extends GetxController {
  final SpecialiteService _service = SpecialiteService();

  var specialites = <Specialite>[].obs;
  var specialiteDetails = Rxn<Specialite>();
  var isLoading = false.obs;

   var specialitesByDepartement = <Specialite>[].obs;



  var filteredSpecialites = <Specialite>[].obs; // List for filtered results
  

  @override
  void onInit() {
    super.onInit();
    fetchSpecialites(); // Fetch specialties on initialization
  }

  // Fetch all specialties
  Future<void> fetchSpecialites() async {
    isLoading(true);
    try {
      final fetchedSpecialites = await _service.fetchSpecialites();
      specialites.assignAll(fetchedSpecialites);
      filteredSpecialites.assignAll(fetchedSpecialites); // Initialize filtered list
    } catch (e) {
      Get.snackbar('Error', 'Failed to load specialties: $e');
    } finally {
      isLoading(false);
    }
  }

  // Filter specialties by name
  void filterSpecialites(String query) {
    if (query.isEmpty) {
      filteredSpecialites.assignAll(specialites); // Reset filter
    } else {
      filteredSpecialites.assignAll(
        specialites.where((specialite) =>
            specialite.nom.toLowerCase().contains(query.toLowerCase())).toList(),
      );
    }
  }


  // Fetch all specialities
  // Future<void> fetchSpecialites() async {
  //   isLoading(true);
  //   try {
  //     final fetchedSpecialites = await _service.fetchSpecialites();
  //     specialites.assignAll(fetchedSpecialites);
  //   } catch (e) {
  //     Get.snackbar('Error', 'Failed to load specialities: $e');
  //   } finally {
  //     isLoading(false);
  //   }
  // }

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
      // Get.snackbar('Success', 'Speciality created successfully');
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
      // Get.snackbar('Success', 'Speciality updated successfully');
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
      // Get.snackbar('Success', 'Speciality deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete speciality: $e');
    } finally {
      isLoading(false);
    }
  }

   // Fetch specialties by department ID
  Future<void> fetchSpecialitesByDepartement(int departementId) async {
    isLoading(true);
    try {
      final fetchedSpecialites = await _service.fetchSpecialitesByDepartement(departementId);
      specialitesByDepartement.assignAll(fetchedSpecialites);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load specialties by department: $e');
    } finally {
      isLoading(false);
    }
  }
}
