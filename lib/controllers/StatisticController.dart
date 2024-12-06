import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class StatisticController extends GetxController {
  var employeeCount = 0.obs;
  var formateurCount = 0.obs;
  var isLoading = false.obs;

  Future<void> fetchStatistics() async {
    final box = GetStorage();
    String? token = box.read('token');
    try {
      isLoading(true);

      // Fetch employee count
      var employeeResponse = await http.get(
          Uri.parse('http://localhost:8080/employes/count'),
          headers: {'Authorization': 'Bearer $token'});
      if (employeeResponse.statusCode == 200) {
        var employeeCountValue =
            jsonDecode(employeeResponse.body); // Parse response body
        employeeCount.value =
            int.parse(employeeCountValue.toString()); // Convert to int
      } else {
        Get.snackbar('Error', 'Failed to fetch employee count');
      }

      // Fetch formateur count
      var formateurResponse = await http.get(
          Uri.parse('http://localhost:8080/formateurs/count'),
          headers: {'Authorization': 'Bearer $token'});
      if (formateurResponse.statusCode == 200) {
        var formateurCountValue =
            jsonDecode(formateurResponse.body); // Parse response body
        formateurCount.value =
            int.parse(formateurCountValue.toString()); // Convert to int
      } else {
        Get.snackbar('Error', 'Failed to fetch formateur count');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch statistics: $e');
    } finally {
      isLoading(false);
    }
  }
}
