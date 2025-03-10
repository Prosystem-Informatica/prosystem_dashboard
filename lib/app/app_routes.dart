import 'package:get/get.dart';
import 'package:prosystem_dashboard/app/modules/home/home_page.dart';
import 'package:prosystem_dashboard/app/modules/login/login_page.dart';


class Routes {
  static const INITIAL = "/login";
  static const HOME = "/home";
}

class AppPages {
  static final pages = [
    GetPage(name: Routes.INITIAL, page: () => const LoginPage()),
    GetPage(name: Routes.HOME, page: () => const HomePage()),

  ];
}