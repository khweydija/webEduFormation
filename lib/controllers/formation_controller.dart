import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:webpfe/Services/formation_service.dart';
import 'package:webpfe/models/Formation.dart';

class FormationController extends GetxController {
  final FormationService _formationService = FormationService();
  var isLoading = false.obs;
  var formations = <Formation>[].obs;

  final box = GetStorage();

 

  // New method to fetch the list of all formations
  Future<void> fetchFormationList() async {
    isLoading(true);
    try {
      List<Formation> fetchedFormations =
          await _formationService.fetchFormationList();
      formations.assignAll(fetchedFormations); // Bind the data to the observable list
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch formation list, $e');
    } finally {
      isLoading(false);
    }
  }
}
