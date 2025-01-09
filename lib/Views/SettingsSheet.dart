import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = false.obs; // Replace with your actual dark mode controller
    final selectedLanguage = 'fr'.obs; // Default to French

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Obx(() => Switch(
                  value: isDarkMode.value,
                  onChanged: (value) {
                    isDarkMode.value = value;
                    // Implement dark mode logic
                    Get.changeTheme(
                      value ? ThemeData.dark() : ThemeData.light(),
                    );
                  },
                )),
            title: Text(
              'Mode Sombre',
              style: TextStyle(fontSize: 18),
            ),
          ),
          Divider(),
          ListTile(
            title: Text(
              'Changer la langue',
              style: TextStyle(fontSize: 18),
            ),
          ),
          Wrap(
            spacing: 10,
            children: [
              _buildLanguageButton('AR', 'ar', selectedLanguage),
              _buildLanguageButton('FR', 'fr', selectedLanguage),
              _buildLanguageButton('EN', 'en', selectedLanguage),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(
      String label, String langCode, RxString selectedLanguage) {
    return Obx(() => ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: selectedLanguage.value == langCode
                ? Colors.white
                : Colors.black87, backgroundColor: selectedLanguage.value == langCode
                ? Color.fromARGB(255, 24, 86, 88)
                : Colors.grey[200],
          ),
          onPressed: () {
            selectedLanguage.value = langCode;
            // Implement language change logic
            // Example: Get.updateLocale(Locale(langCode));
            Get.updateLocale(Locale(langCode));
          },
          child: Text(label),
        ));
  }
}
