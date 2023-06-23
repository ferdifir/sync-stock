import 'package:get/get.dart';
import 'package:stockmobilesync/modules/dashboard/dashboard_binding.dart';
import 'package:stockmobilesync/modules/dashboard/dashboard_page.dart';
import 'package:stockmobilesync/modules/login/login_binding.dart';
import 'package:stockmobilesync/modules/login/login_page.dart';
import 'package:stockmobilesync/modules/master/master_page.dart';
import 'package:stockmobilesync/modules/purchases/purchases_page.dart';
import 'package:stockmobilesync/modules/sales/sales_page.dart';
import 'package:stockmobilesync/modules/splash/splash_binding.dart';
import 'package:stockmobilesync/routes/app_routes.dart';
import 'package:stockmobilesync/modules/splash/splash_screen.dart';

class AppPages {
  static List<GetPage> routes = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => const SplashScreen(),
      transition: Transition.fadeIn,
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => LoginPage(),
      transition: Transition.fadeIn,
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.DASHBOARD,
      page: () => const DashboardPage(),
      transition: Transition.fadeIn,
      binding: DashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.MASTER,
      page: () => MasterPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.PURCHASES,
      page: () => PembelianPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.SALES,
      page: () => PenjualanPage(),
      transition: Transition.fadeIn,
    ),
  ];
}