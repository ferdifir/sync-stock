import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockmobilesync/models/users.dart';
import 'package:stockmobilesync/services/api_services.dart';
import 'package:stockmobilesync/services/db_services.dart';
import 'package:stockmobilesync/utils/config.dart';
import 'package:stockmobilesync/utils/log.dart';

class SplashController extends GetxController {
  final api = ApiServices();
  final db = DbServices();
  RxBool isFirstTime = true.obs;
  RxBool isRemember = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadPref();
  }

  void loadPref() async {
    final pref = await SharedPreferences.getInstance();
    isFirstTime.value = pref.getBool(firstTimePrefKey) ?? true;
    isRemember.value = pref.getBool(rememberMePrefKey) ?? false;
  }

  void setPref() async {
    final pref = await SharedPreferences.getInstance();
    pref.setBool(firstTimePrefKey, false);
  }

  Future<bool> loadDataUser() async {
    try {
      db.openDB();
      List<Users> users = await api.fetchUserData();
      db.insertData(
        'users',
        users.map((e) => e.toJson()).toList(),
      );

      return true;
    } catch (e) {
      Log.d('Load Data User', e.toString());
      return false;
    }
  }
}
