import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:webpfe/Views/LoginScreen/LoginAdmin.dart';
import 'package:webpfe/Views/RegisterScreen/SignUpScreenAdmin.dart';


class Routes {
  static const String signUp = '/signup';
  static const String loginAdmin = '/loginAdmin';
  static const String mainScreen = '/mainScreen';
  static const String success = '/success';

  static List<GetPage> getPages = [
    GetPage(name: signUp, page: () => SignUpScreenAdmin()),
    GetPage(name: loginAdmin, page: () => LoginAdmin()),
    //GetPage(name: mainScreen, page: () => MainScreen()),
    GetPage(
        name: success,
        page: () =>
            LoginAdmin()), // Assurez-vous d'ajouter cette ligne si vous avez une page de succès
  ];
}
