import 'package:get/get.dart';
import 'package:stockmobilesync/modules/master/master_controller.dart';

class MasterBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MasterController>(() => MasterController());
  }
}
