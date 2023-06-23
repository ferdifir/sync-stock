import 'package:get/get.dart';
import 'package:stockmobilesync/modules/sales/sales_controller.dart';

class SalesBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SalesController>(() => SalesController());
  }
}
