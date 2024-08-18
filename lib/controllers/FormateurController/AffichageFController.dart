import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AffichageFController extends GetxController {
  final String apiUrl = 'http://192.168.100.12:8080/formateurs/list'; 
  var formateurs = [].obs; 

  // Method to fetch formateurs from the backend
  Future<void> fetchFormateurs() async {
    try {
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        formateurs.assignAll(data); 
      } else {
        Get.snackbar('Error', 'Failed to load formateurs');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }
}
