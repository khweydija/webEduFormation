import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class StatisticController extends GetxController {
  var employeeCount = 0.obs;
  var formateurCount = 0.obs;
  var specialiteCount = 0.obs;
  var departementCount = 0.obs;
  var categoryCount = 0.obs;
  var isLoading = false.obs;

  Future<void> fetchStatistics() async {
    final box = GetStorage();
    String? token = box.read('token');
    try {
      isLoading(true);

      // Fetch employee count
      var employeeResponse = await http.get(
        Uri.parse('http://localhost:8080/employes/count'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (employeeResponse.statusCode == 200) {
        var employeeCountValue = jsonDecode(employeeResponse.body);
        employeeCount.value = int.parse(employeeCountValue.toString());
      } else {
        Get.snackbar('Error', 'Failed to fetch employee count');
      }

      // Fetch formateur count
      var formateurResponse = await http.get(
        Uri.parse('http://localhost:8080/formateurs/count'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (formateurResponse.statusCode == 200) {
        var formateurCountValue = jsonDecode(formateurResponse.body);
        formateurCount.value = int.parse(formateurCountValue.toString());
      } else {
        Get.snackbar('Error', 'Failed to fetch formateur count');
      }

      // Fetch specialite count
      var specialiteResponse = await http.get(
        Uri.parse('http://localhost:8080/api/specialites/count'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (specialiteResponse.statusCode == 200) {
        var specialiteCountValue = jsonDecode(specialiteResponse.body);
        specialiteCount.value = int.parse(specialiteCountValue.toString());
      } else {
        Get.snackbar('Error', 'Failed to fetch specialite count');
      }

      // Fetch departement count
      var departementResponse = await http.get(
        Uri.parse('http://localhost:8080/api/departements/count'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (departementResponse.statusCode == 200) {
        var departementCountValue = jsonDecode(departementResponse.body);
        departementCount.value = int.parse(departementCountValue.toString());
      } else {
        Get.snackbar('Error', 'Failed to fetch departement count');
      }

      // Fetch category count
      var categoryResponse = await http.get(
        Uri.parse('http://localhost:8080/api/categories/count'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (categoryResponse.statusCode == 200) {
        var categoryCountValue = jsonDecode(categoryResponse.body);
        categoryCount.value = int.parse(categoryCountValue.toString());
      } else {
        Get.snackbar('Error', 'Failed to fetch category count');
      }

    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch statistics: $e');
    } finally {
      isLoading(false);
    }
  }


  
}
