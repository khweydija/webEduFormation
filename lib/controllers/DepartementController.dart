import 'package:get/get.dart';
import 'package:webpfe/Services/DepartementService.dart';
import 'package:webpfe/models/Departement.dart';

class DepartementController extends GetxController {
  final DepartementService _service = DepartementService();

  var departements = <Departement>[].obs;
  var departementDetails = Rxn<Departement>();
  var isLoading = false.obs;

  Future<void> fetchDepartements() async {
    isLoading(true);
    try {
      final fetchedDepartements = await _service.fetchDepartements();
      departements.assignAll(fetchedDepartements);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load departements: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> getDepartementById(int id) async {
    isLoading(true);
    try {
      final fetchedDepartement = await _service.getDepartementById(id);
      departementDetails.value = fetchedDepartement;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load departement: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> createDepartement(String nom, String description) async {
    isLoading(true);
    try {
      await _service.createDepartement(nom, description);
      fetchDepartements();
      Get.snackbar('Success', 'Departement created successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to create departement: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateDepartement(int id, String nom, String description) async {
    isLoading(true);
    try {
      await _service.updateDepartement(id, nom, description);
      fetchDepartements();
      Get.snackbar('Success', 'Departement updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update departement: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteDepartement(int id) async {
    isLoading(true);
    try {
      await _service.deleteDepartement(id);
      fetchDepartements();
      Get.snackbar('Success', 'Departement deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete departement: $e');
    } finally {
      isLoading(false);
    }
  }
}
