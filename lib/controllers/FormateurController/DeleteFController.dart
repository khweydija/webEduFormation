import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DeleteFormateurController extends GetxController {
  final String apiUrl = 'http://192.168.100.12:8080/formateurs/delete/';

  // Method to delete a formateur by ID
  Future<void> deleteFormateur(int id) async {
    try {
      var response = await http.delete(Uri.parse(apiUrl + id.toString()));

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Formateur deleted successfully');
      } else {
        Get.snackbar('Error', 'Failed to delete formateur');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }
}
