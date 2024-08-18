import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GetFormateurDetailsController extends GetxController {
  final String apiUrl = 'http://192.168.100.12:8080/formateurs/Formateur/';

  var formateurDetails = {}.obs; // Observable map to hold formateur details
  var isLoading = true.obs; // Observable boolean to show loading state

  // Method to get formateur details by ID
  Future<void> getFormateurDetails(int id) async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse(apiUrl + id.toString()));

      if (response.statusCode == 200) {
        formateurDetails.value = json.decode(response.body);
        Get.snackbar('Success', 'Formateur details loaded successfully');
      } else if (response.statusCode == 404) {
        Get.snackbar('Error', 'Formateur not found');
      } else {
        Get.snackbar('Error', 'Failed to load formateur details');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }
}
