import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:webpfe/AppRoutes.dart';
import 'package:webpfe/Views/AppTranslations.dart';
import 'package:webpfe/Views/Certification/AdminDashboardCertification.dart';
import 'package:webpfe/Views/Certification/CertificateScreen.dart';
import 'package:webpfe/Views/ForgetScreen/ForgotPassAdmine.dart';
import 'package:webpfe/Views/ForgetScreen/SetPasswordAdmin.dart';
import 'package:webpfe/Views/ForgetScreen/VerifyCodeScreenAdmin.dart';
import 'package:webpfe/Views/Screeendepatemnet/AdminDashboardDepartement.dart';
import 'package:webpfe/Views/ScreenCatagories/DashboardCatagories.dart';

import '../../controllers/CertificationController.dart';

import 'package:webpfe/Views/LoginScreen/LoginAdmin.dart';

import 'package:webpfe/Views/ScreenEmploye/AdminDashboardEmploye.dart';
import 'package:webpfe/Views/ScreenFormateur/DashboardScreen.dart';
import 'package:webpfe/Views/Specialite/AdminDashboardSpecialite.dart';
import 'package:webpfe/Views/StatisticDashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(CertificationController());
  // await Firebase.initializeApp(
  //   options: FirebaseOptions(
  //     apiKey: "AIzaSyBm4g2fvDkqrl-tTG7wtFLDB-7-xh439x8",
  //     authDomain: "eduformation-2f4fb.firebaseapp.com",
  //     projectId: "eduformation-2f4fb",
  //     storageBucket: "eduformation-2f4fb.appspot.com",
  //     messagingSenderId: "989691190149",
  //     appId: "1:989691190149:web:e2fa8089274c2d009102ec",
  //     measurementId: "G-MYPVW3Q3CZ",
  //   ),
  // );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: AppTranslations(), // Add translations
      locale: Locale('fr'), // Default locale
      fallbackLocale: Locale('en'), // Fallback locale
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.loginAdmin,
      getPages: [
        GetPage(name: AppRoutes.loginAdmin, page: () => LoginAdmin()),
        GetPage(name: AppRoutes.statisticsPage, page: () => StatisticsPage()),
        GetPage(
            name: AppRoutes.adminDashboardFormateur,
            page: () => AdminDashboardFormateur()),
        GetPage(
            name: AppRoutes.adminDashboardEmploye,
            page: () => AdminDashboardEmploye()),
        GetPage(
            name: AppRoutes.dashboardCatagorie,
            page: () => AdminDashboardCategorie()),
        GetPage(
            name: AppRoutes.adminDashboardDepartement,
            page: () => AdminDashboardDepartement()),
        GetPage(
            name: AppRoutes.adminDashboardSpecialite,
            page: () => AdminDashboardSpecialite()),
        GetPage(
            name: AppRoutes.forgotPassAdmine, page: () => ForgotPassAdmine()),
        GetPage(
            name: AppRoutes.verifyCodeScreenAdmin,
            page: () => VerifyCodeScreenAdmin()),
        GetPage(
          name: AppRoutes.setPasswordAdminn,
          page: () => SetPasswordAdmin(
            email: Get.arguments['email'] ?? '',
            code: Get.arguments['code'] ?? '',
          ),
        ),
        GetPage(
            name: AppRoutes.adminDashboardCertification,
            page: () => AdminDashboardCertification()),
        GetPage(
            name: AppRoutes.certificateScreen, page: () => CertificateScreen()),
      ],
    );
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

  
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       home:AdminDashboardFormateur(),
//     );
//   }
// }