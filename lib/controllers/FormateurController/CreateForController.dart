import 'dart:html' as html;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CreateForController extends GetxController {
  final String apiUrl = 'http://192.168.100.12:8080/create/formateur';

  // Function to create a formateur
  Future<void> createFormateur({
    required String email,
    required String password,
    required String nom,
    required String departement,
    required String specialite,
    required html.File photo, // File is coming from dart:html for Flutter web
  }) async {
    try {
      // Use FileReader to read the file
      final reader = html.FileReader();
      reader.readAsArrayBuffer(photo);
      await reader.onLoadEnd.first; // Wait for file loading to complete

      // Convert the result to bytes
      final data = reader.result as List<int>;

      // Create a multipart request
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl))
        ..fields['email'] = email
        ..fields['password'] = password
        ..fields['nom'] = nom
        ..fields['departement'] = departement
        ..fields['specialite'] = specialite
        ..files.add(
          http.MultipartFile.fromBytes(
            'photo',
            data,
            filename: photo.name,
          ),
        );

      // Send the multipart request
      var response = await request.send();

      // Handle the server's response
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Formateur created successfully');
      } else {
        var responseBody = await response.stream.bytesToString();
        Get.snackbar('Error', 'Formateur creation failed: $responseBody');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }
}
