import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:stockmobilesync/models/master.dart';
import 'package:stockmobilesync/utils/config.dart';
import 'package:stockmobilesync/utils/log.dart';

class MasterController extends GetxController {
  RxList<Master> masters = RxList();
  RxBool isSearch = false.obs;
  RxBool isLoading = false.obs;
  RxString level = RxString('');
  SharedPreferences? pref;

  @override
  void onInit() async {
    super.onInit();
    pref = await SharedPreferences.getInstance();
    getListMaster();
    getUserLever();
  }

  getUserLever() {
    level.value = pref!.getString(levelPrefKey)!;
  }

  toggleSearch() {
    isSearch.value = !isSearch.value;
  }

  getListMaster() async {
    isLoading.value = true;
    masters.clear();
    try {
      var databasePath = await getDatabasesPath();
      String path = join(databasePath, dbMaster);
      final db = await openDatabase(path);
      List<Map<String, dynamic>> masterList =
          await db.rawQuery("SELECT * FROM master");
      for (var element in masterList) {
        masters.add(Master.fromJson(element));
      }
      isLoading.value = false;
    } catch (e) {
      Log.e('Get List Master', '$e');
      isLoading.value = false;
    }
  }

  searchMaster(String query) async {
    isLoading.value = true;
    masters.clear();
    try {
      var databasePath = await getDatabasesPath();
      String path = join(databasePath, dbMaster);
      final db = await openDatabase(path);
      List<Map<String, dynamic>> masterList =
          await db.rawQuery("SELECT * FROM master WHERE nama LIKE '%$query%'");

      for (var element in masterList) {
        masters.add(Master.fromJson(element));
      }
      isLoading.value = false;
    } catch (e) {
      Log.e('Search Master', '$e');
      isLoading.value = false;
    }
  }
}
