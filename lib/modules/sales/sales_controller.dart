import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:stockmobilesync/models/sales.dart';
import 'package:stockmobilesync/utils/config.dart';
import 'package:stockmobilesync/utils/log.dart';

class SalesController extends GetxController {
  RxList<Sales> sales = RxList();
  RxBool isSearch = false.obs;
  RxBool isLoading = false.obs;
  RxString searchQuery = ''.obs;
  RxString fromDate = ''.obs;
  RxString toDate = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getSalesMaster();
  }

  toggleSearch() {
    isSearch.value = !isSearch.value;
  }

  getSalesMaster() async {
    isLoading.value = true;
    sales.clear();
    try {
      var databasePath = await getDatabasesPath();
      String path = join(databasePath, dbSales);
      final db = await openDatabase(path);
      List<Map<String,dynamic>> salesList = await db.rawQuery("SELECT * FROM sales");
      for (var data in salesList) {
        sales.add(Sales.fromJson(data));
      }
      isLoading.value = false;
    } catch(e) {
      Log.e('Get List Sales', e.toString());
      isLoading.value = false;
    }
  }

  searchSales(String query) async {
    isLoading.value = true;
    sales.clear();
    try {
      var databasePath = await getDatabasesPath();
      String path = join(databasePath, dbSales);
      final db = await openDatabase(path);
      List<Map<String,dynamic>> salesList = await db.rawQuery(
          "SELECT * FROM sales WHERE nama LIKE '%$query%'");

      for (var data in salesList) {
        sales.add(Sales.fromJson(data));
      }
      isLoading.value = false;
    } catch(e) {
      Log.e('Search Sales', e.toString());
      isLoading.value = false;
    }
  }

  filterSales(String from, String to) async {
    isLoading.value = true;
    sales.clear();
    try {
      var databasePath = await getDatabasesPath();
      String path = join(databasePath, dbSales);
      final db = await openDatabase(path);
      List<Map<String,dynamic>> salesList = await db.rawQuery(
          "SELECT * FROM sales WHERE nama LIKE '%${searchQuery.value}%' AND tgl BETWEEN '$from' AND '$to'");

      for (var data in salesList) {
        sales.add(Sales.fromJson(data));
      }
      isLoading.value = false;
    } catch(e) {
      Log.e('Filter Sales', e.toString());
      isLoading.value = false;
    }
  }
}