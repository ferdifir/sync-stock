import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockmobilesync/models/users.dart';
import 'package:stockmobilesync/services/db_services.dart';
import 'package:stockmobilesync/utils/config.dart';
import 'package:stockmobilesync/utils/log.dart';

import '../../services/api_services.dart';

class LoginController extends GetxController {
  SharedPreferences? pref;
  final db = DbServices();
  final api = ApiServices();
  RxBool rememberMe = false.obs;
  RxBool showPassword = false.obs;

  @override
  void onInit() {
    super.onInit();
    initPref();
  }

  initPref() async {
    pref = await SharedPreferences.getInstance();
  }

  setRememberMe() async {
    pref!.setBool(rememberMePrefKey, rememberMe.value);
  }

  toggleShowPassword() {
    showPassword.value = !showPassword.value;
  }

  Future<bool> userLogin(String username, String password) async {
    String query =
        "SELECT * FROM users WHERE username = '$username' AND password = '$password'";
    try {
      List<Users> listUser = await db.getData<Users>(
        'users',
        query,
        fromJsonUser,
      );

      if (listUser.isEmpty) {
        return false;
      } else {
        setUserData(listUser);
        return true;
      }
    } catch (e) {
      printError(info: e.toString());
      return false;
    }
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

  void setUserData(List<Users> listUser) {
    pref!.setString(namePrefKey, listUser[0].fullName);
    pref!.setString(emailPrefKey, listUser[0].email);
    pref!.setString(levelPrefKey, listUser[0].level);
  }

  Users fromJsonUser(Map<String, dynamic> json) {
    return Users.fromJson(json);
  }

}
