import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockmobilesync/models/master.dart';
import 'package:stockmobilesync/services/db_services.dart';
import 'package:stockmobilesync/utils/config.dart';
import 'package:stockmobilesync/utils/helper.dart';
import 'package:stockmobilesync/utils/log.dart';

class MasterController extends GetxController {
  final db = DbServices();
  RxList<Master> masters = RxList();
  RxBool isSearch = false.obs;
  RxBool isLoading = false.obs;
  RxBool isAktif = true.obs;
  RxString level = RxString('');
  SharedPreferences? pref;
  String sessionId = Get.arguments;

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

  toggleAktif(bool value) {
    isAktif.value = value;
  }

  showListAktif() {
    var data = masters;
    if (isAktif.value) {
      masters.value = masters.where((element) => element.aktif == 1).toList();
    } else {
      masters = data;
    }
  }

  getListMaster() async {
    isLoading.value = true;
    masters.clear();
    try {
      String query = "SELECT * FROM master";
      if (isAktif.value) {
        query += " WHERE aktif = 1";
      }
      masters.value = await getListData(query);
      isLoading.value = false;
    } catch (e) {
      Log.e('Get List Master', '$e');
      isLoading.value = false;
    }
  }

  Future<List<Master>> getListData(String query) async {
    var data = await db.getData<Master>(
      'master',
      query,
      Helper.fromJsonMaster,
    );
    return data;
  }

  searchMaster(String keyword) async {
    isLoading.value = true;
    masters.clear();
    try {
      String query = "SELECT * FROM master WHERE nama LIKE '%$keyword%'";
      if (isAktif.value) {
        query += " AND aktif = 1";
      }
      masters.value = await getListData(query);
      isLoading.value = false;
    } catch (e) {
      Log.e('Search Master', '$e');
      isLoading.value = false;
    }
  }
}
