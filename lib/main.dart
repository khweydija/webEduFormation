import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'package:webpfe/Views/Dashboard/DashboardFormateur.dart';
import 'package:webpfe/Views/ForgetScreen/ForgotPassAdmine.dart';
import 'package:webpfe/Views/ForgetScreen/SetPasswordAdmin.dart';
import 'package:webpfe/Views/LoginScreen/LoginAdmin.dart';


import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
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
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdminDashboard(),
    );
  }
}
