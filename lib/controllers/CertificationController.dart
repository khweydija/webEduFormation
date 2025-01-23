import 'package:get/get.dart';
import 'package:webpfe/Services/CertificationService.dart';
import 'package:webpfe/models/Certification.dart';

class CertificationController extends GetxController {
  final CertificationService _service = CertificationService();

  var certifications = <Certification>[].obs;
  var certificationDetails = Rxn<Certification>();
  var isLoading = false.obs;

  Future<void> fetchCertifications() async {
    isLoading(true);
    try {
      final fetchedCertifications = await _service.fetchCertifications();
      certifications.assignAll(fetchedCertifications);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load certifications: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> getCertificationById(int id) async {
    isLoading(true);
    try {
      final fetchedCertification = await _service.getCertificationById(id);
      certificationDetails.value = fetchedCertification;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load certification: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> createCertification(PostCertification certification) async {
    isLoading(true);
    try {
      await _service.createCertification(certification);
      fetchCertifications();
      Get.snackbar('Success', 'Certification created successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to create certification: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateCertification(Certification certification) async {
    isLoading(true);
    try {
      await _service.updateCertification(certification);
      fetchCertifications();
      Get.snackbar('Success', 'Certification updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update certification: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteCertification(int id) async {
    isLoading(true);
    try {
      await _service.deleteCertification(id);
      fetchCertifications();
      Get.snackbar('Success', 'Certification deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete certification: $e');
    } finally {
      isLoading(false);
    }
  }
}
