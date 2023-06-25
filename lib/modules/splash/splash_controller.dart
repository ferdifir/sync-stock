import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockmobilesync/models/users.dart';
import 'package:stockmobilesync/services/api_services.dart';
import 'package:stockmobilesync/services/db_services.dart';
import 'package:stockmobilesync/utils/config.dart';
import 'package:stockmobilesync/services/data_synchronization.dart';
import 'package:stockmobilesync/utils/log.dart';

class SplashController extends GetxController {
  SharedPreferences? pref;
  final api = ApiServices();
  final db = DbServices();
  final syncData = DataSynchronization();
  RxBool isFirstTime = true.obs;
  RxBool isRemember = false.obs;

  @override
  void onInit() {
    super.onInit();
    initPref();
    loadPref();
  }

  initPref() async {
    pref = await SharedPreferences.getInstance();
  }

  void loadPref() {
    isFirstTime.value = pref?.getBool(firstTimePrefKey) ?? true;
    isRemember.value = pref?.getBool(rememberMePrefKey) ?? false;
  }

  void setPref() {
    pref?.setBool(firstTimePrefKey, false);
  }

  Future<bool> loadDataUser() async {
    try {
      db.openDB();
      List<Users> users = await api.fetchUserData();
      db.insertData(
        'users',
        dbUsersQuery,
        users.map((e) => e.toJson()).toList(),
      );

      setPref();

      return true;
    } catch (e) {
      Log.d('Load Data User', e.toString());
      return false;
    }
  }
}
