import 'package:get/get.dart';
import 'package:stockmobilesync/modules/purchases/purchases_controller.dart';

class PurchasesBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PurchasesController>(() => PurchasesController());
  }
}
