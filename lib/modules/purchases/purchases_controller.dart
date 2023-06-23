import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:stockmobilesync/models/purchases.dart';
import 'package:stockmobilesync/utils/config.dart';
import 'package:stockmobilesync/utils/log.dart';

class PurchasesController extends GetxController {
  RxList<Purchases> purchases = RxList();
  RxBool isSearch = false.obs;
  RxBool isLoading = false.obs;
  RxString searchQuery = ''.obs;
  RxString fromDate = ''.obs;
  RxString toDate = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getPurchasesMaster();
  }

  toggleSearch() {
    isSearch.value = !isSearch.value;
  }

  getPurchasesMaster() async {
    isLoading.value = true;
    purchases.clear();
    try {
      var databasePath = await getDatabasesPath();
      String path = join(databasePath, dbPurchases);
      final db = await openDatabase(path);
      List<Map<String,dynamic>> purchasesList = await db.rawQuery("SELECT * FROM purchases");
      for (var data in purchasesList) {
        purchases.add(Purchases.fromJson(data));
      }
      isLoading.value = false;
    } catch(e) {
      Log.e('Get List Purchases', e.toString());
      isLoading.value = false;
    }
  }

  searchPurchases(String query) async {
    isLoading.value = true;
    purchases.clear();
    try {
      var databasePath = await getDatabasesPath();
      String path = join(databasePath, dbPurchases);
      final db = await openDatabase(path);
      List<Map<String,dynamic>> purchasesList = await db.rawQuery(
          "SELECT * FROM purchases WHERE nama LIKE '%$query%'");

      for (var data in purchasesList) {
        purchases.add(Purchases.fromJson(data));
      }
      isLoading.value = false;
    } catch(e) {
      Log.e('Search Purchases', e.toString());
      isLoading.value = false;
    }
  }

  filterPurchases(String from, String to) async {
    isLoading.value = true;
    purchases.clear();
    try {
      var databasePath = await getDatabasesPath();
      String path = join(databasePath, dbPurchases);
      final db = await openDatabase(path);
      List<Map<String,dynamic>> purchasesList = await db.rawQuery(
          "SELECT * FROM purchases WHERE nama LIKE '%${searchQuery.value}%' AND tgl BETWEEN '$from' AND '$to'");

      for (var data in purchasesList) {
        purchases.add(Purchases.fromJson(data));
      }
      isLoading.value = false;
    } catch(e) {
      Log.e('Filter Purchases', e.toString());
      isLoading.value = false;
    }
  }
}