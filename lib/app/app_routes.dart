import 'package:get/get.dart';
import 'package:prosystem_dashboard/app/modules/home/home_page.dart';
import 'package:prosystem_dashboard/app/modules/home/modules/daily_payments/daily_payments_page.dart';
import 'package:prosystem_dashboard/app/modules/home/modules/financial/financial_page.dart';
import 'package:prosystem_dashboard/app/modules/home/modules/month_payments/month_payments_page.dart';
import 'package:prosystem_dashboard/app/modules/home/modules/register/register_page.dart';
import 'package:prosystem_dashboard/app/modules/home/modules/technical_assistance/technical_assistance_page.dart';
import 'package:prosystem_dashboard/app/modules/login/login_page.dart';

import 'modules/home/modules/comercial/commercial_page.dart';
import 'modules/home/modules/payment_daily/payment_daily_page.dart';

class Routes {
  static const INITIAL = "/login";
  static const HOME = "/home";
  static const DAILY = "/daily";
  static const REGISTER = "/register";
  static const PAYMENTS = "/payments";
  static const TECHNICAL = "/technical";
  static const MONTH = "/month";
  static const COMMERCIAL = "/commercial";
  static const FINANCIAL = "/financial";

}

class AppPages {
  static final pages = [
    GetPage(name: Routes.INITIAL, page: () => const LoginPage()),
    GetPage(name: Routes.HOME, page: () => const HomePage()),
    GetPage(name: Routes.DAILY, page: () => const PaymentDailyPage()),
    GetPage(name: Routes.REGISTER, page: () => const RegisterPage()),
    GetPage(name: Routes.PAYMENTS, page: () => const DailyPaymentsPage()),
    GetPage(name: Routes.TECHNICAL, page: () => const TechnicalAssistancePage()),
    GetPage(name: Routes.MONTH, page: () => const MonthPaymentsPage()),
    GetPage(name: Routes.COMMERCIAL, page: () => const CommercialPage()),
    GetPage(name: Routes.FINANCIAL, page: () => const FinancialPage()),
  ];
}
