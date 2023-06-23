import 'package:get/get.dart';
import 'package:stockmobilesync/modules/dashboard/dashboard_controller.dart';

class DashboardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}
