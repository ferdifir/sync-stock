import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockmobilesync/models/users.dart';
import 'package:stockmobilesync/services/data_synchronization.dart';
import 'package:stockmobilesync/services/db_services.dart';
import 'package:stockmobilesync/utils/config.dart';
import 'package:stockmobilesync/utils/helper.dart';

import '../../services/api_services.dart';

class LoginController extends GetxController {
  SharedPreferences? pref;
  final db = DbServices();
  final api = ApiServices();
  final syncData = DataSynchronization();
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

  Future<String?> userLogin(String username, String password) async {
    String query =
        "SELECT * FROM users WHERE username = '$username' AND password = '$password'";
    try {
      List<Users> listUser = await db.getData<Users>(
        'users',
        query,
        Helper.fromJsonUser,
      );

      if (listUser.isEmpty) {
        return 'Username atau password yang anda masukkan salah';
      } else if (listUser[0].block == 'Y') {
        return 'Anda tidak dapat login karena akun anda diblokir';
      } else {
        setUserData(listUser);
        return 'Login berhasil';
      }
    } catch (e) {
      printError(info: e.toString());
      return null;
    }
  }

  void setUserData(List<Users> listUser) {
    pref!.setString(namePrefKey, listUser[0].fullName);
    pref!.setString(emailPrefKey, listUser[0].email);
    pref!.setString(levelPrefKey, listUser[0].level);
  }
}
