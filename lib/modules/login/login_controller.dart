import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stockmobilesync/utils/config.dart';

class LoginController extends GetxController {
  RxBool rememberMe = false.obs;
  RxBool showPassword = false.obs;

  setRememberMe() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(rememberMePrefKey, rememberMe.value);
  }

  toggleShowPassword() {
    showPassword.value = !showPassword.value;
  }

  Future<bool> userLogin(String username, String password) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      var databasePath = await getDatabasesPath();
      String path = join(databasePath, dbUsers);
      final db = await openDatabase(path);

      List<Map> loginQuery = await db.rawQuery(
          "SELECT * FROM users WHERE username = '$username' AND password = '$password'");

      if (loginQuery.isEmpty) {
        return false;
      } else {
        pref.setString(namePrefKey, loginQuery[0]['nama_lengkap']);
        pref.setString(emailPrefKey, loginQuery[0]['email']);
        pref.setString(levelPrefKey, loginQuery[0]['level']);
        return true;
      }
    } catch (e) {
      printError(info: e.toString());
      return false;
    }
  }
}
