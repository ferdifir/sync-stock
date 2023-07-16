import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockmobilesync/models/master.dart';
import 'package:stockmobilesync/models/purchases.dart';
import 'package:stockmobilesync/models/sales.dart';
import 'package:stockmobilesync/models/sales_data.dart';
import 'package:stockmobilesync/services/api_services.dart';
import 'package:stockmobilesync/services/data_synchronization.dart';
import 'package:stockmobilesync/services/db_services.dart';
import 'package:stockmobilesync/utils/config.dart';
import 'package:stockmobilesync/utils/helper.dart';
import 'package:stockmobilesync/utils/log.dart';

import '../../models/users.dart';

class DashboardController extends GetxController {
  SharedPreferences? pref;
  final api = ApiServices();
  final db = DbServices();
  final synData = DataSynchronization();

  RxString name = RxString('');
  RxString email = RxString('');
  RxString level = RxString('');
  RxString sessionId = RxString('');
  RxBool firstSynch = RxBool(true);
  RxString statusSync = RxString('Sinkronisasi data');
  RxDouble progressSync = RxDouble(0);
  final salesData = <SalesData>[].obs;

  @override
  void onInit() async {
    super.onInit();
    pref = await SharedPreferences.getInstance();
    fetchUserData();
    collectSalesData();
  }

  collectSalesData() async {
    Map<String, int> groupedData = {};
    try {
      String query = querySelectData('sales', forAvailibility: false);
      List<Sales> listSales = await db.getData<Sales>(
        'sales',
        query,
        Helper.fromJsonSales,
      );
      for (var element in listSales) {
        groupedData[element.tgl] = (groupedData[element.tgl] ?? 0) + 1;
      }
      groupedData.forEach((key, value) {
        salesData.add(SalesData(key, value));
      });

      List<SalesData> updatedList = [];
      int index = 1;
      for (int i = 0; i < salesData.length; i++) {
        SalesData sales = salesData[i];
        sales.year = index.toString();
        updatedList.add(sales);
        index++;
      }
    } catch (e) {
      printError(info: e.toString());
    }
  }

  updateStatusProgress(String s, double p) {
    statusSync.value = s;
    progressSync.value = p;
  }

  void fetchUserData() {
    name.value = pref?.getString(namePrefKey) ?? '';
    email.value = pref?.getString(emailPrefKey) ?? '';
    level.value = pref?.getString(levelPrefKey) ?? '';
    firstSynch.value = pref?.getBool(firstTimeSync) ?? true;
    sessionId.value = pref?.getString(sessionIdPrefKey) ?? '';
  }

  String querySelectData(String tableName, {required bool forAvailibility}) {
    String query = "SELECT * FROM $tableName";
    String limit = "LIMIT 1";
    if (forAvailibility) {
      return '$query $limit';
    } else {
      return query;
    }
  }

  Future<bool> checkDataMaster() async {
    List<Master> masterData = await getMaster(true);
    return masterData.isNotEmpty;
  }

  Future<List<Master>> getMaster(bool isCheck) async {
    String masterQuery = querySelectData('master', forAvailibility: isCheck);
    List<Master> masterData = await db.getData<Master>(
      'master',
      masterQuery,
      Helper.fromJsonMaster,
    );
    return masterData;
  }

  Future<bool> checkDataSales() async {
    List<Sales> salesData = await getSales(true);
    return salesData.isNotEmpty;
  }

  Future<List<Sales>> getSales(bool isCheck) async {
    String salesQuery = querySelectData('sales', forAvailibility: isCheck);
    List<Sales> salesData = await db.getData<Sales>(
      'sales',
      salesQuery,
      Helper.fromJsonSales,
    );
    return salesData;
  }

  Future<bool> checkDataPurchases() async {
    List<Purchases> purchasesData = await getPurchases(true);
    return purchasesData.isNotEmpty;
  }

  Future<List<Purchases>> getPurchases(bool isCheck) async {
    String purchasesQuery =
        querySelectData('purchases', forAvailibility: isCheck);
    List<Purchases> purchasesData = await db.getData<Purchases>(
      'purchases',
      purchasesQuery,
      Helper.fromJsonPurchases,
    );
    return purchasesData;
  }

  Future<bool> loadDataMaster(Function(String, double)? callback) async {
    callback!('Memulai Sinkronisasi', 0.001);
    List<Master> master = await api.fetchMasterData();
    callback('Mengambil Data Produk dari API', 0.002);
    bool isSuccess = await db.insertData(
        'master', master.map((e) => e.toJson()).toList(),
        callback: callback);
    return isSuccess;
  }

  Future<bool> loadDataSales(Function(String, double)? callback) async {
    callback!('Memulai Sinkronisasi', 0.001);
    List<Sales> sales = await api.fetchSalesData();
    callback('Mengambil Data Penjualan dari API', 0.002);
    bool isSuccess = await db.insertData(
        'sales', sales.map((e) => e.toJson()).toList(),
        callback: callback);
    return isSuccess;
  }

  Future<bool> loadDataPurchases(Function(String, double)? callback) async {
    callback!('Memulai Sinkronisasi', 0.001);
    List<Purchases> purchases = await api.fetchPurchasesData();
    callback('Mengambil Data Pembelian dari API', 0.002);
    bool isSuccess = await db.insertData(
        'purchases', purchases.map((e) => e.toJson()).toList(),
        callback: callback);
    return isSuccess;
  }

  Future<bool> synchronizeData(Function(String s, double p) callback) async {
    callback('Mengambil data user dari server', 0.2);
    List<Users> users = await api.fetchUserData();
    Log.d('Check User APi', users[0].toString());
    callback('Mengambil data produk dari server', 0.4);
    List<Master> master = await api.fetchMasterData();
    Log.d('Check Master APi', master[0].toString());
    callback('Mengambil data penjualan dari server', 0.6);
    List<Sales> sales = await api.fetchSalesData();
    Log.d('Check Sales APi', sales[0].toString());
    callback('Mengambil data pembelian dari server', 0.8);
    List<Purchases> purchases = await api.fetchPurchasesData();
    Log.d('Check Purchases APi', purchases[0].toString());
    callback('Data dari server berhasil diunduh', 1);

    bool deleteUser = await db.deleteAllData('users');
    bool deleteMaster = await db.deleteAllData('master');
    bool deleteSales = await db.deleteAllData('sales');
    bool deletePurchases = await db.deleteAllData('purchases');

    bool insertUser = false;
    bool insertMaster = false;
    bool insertSales = false;
    bool insertPurchases = false;
    if (deleteUser && deleteMaster && deleteSales && deletePurchases) {
      insertUser = await db.insertData(
        'users',
        users.map((e) => e.toJson()).toList(),
        callback: callback,
      );
      insertMaster = await db.insertData(
        'master',
        master.map((e) => e.toJson()).toList(),
        callback: callback,
      );
      insertSales = await db.insertData(
        'sales',
        sales.map((e) => e.toJson()).toList(),
        callback: callback,
      );
      insertPurchases = await db.insertData(
        'purchases',
        purchases.map((e) => e.toJson()).toList(),
        callback: callback,
      );
    }

    if (insertUser && insertMaster && insertSales && insertPurchases) {
      return true;
    } else {
      return false;
    }
  }
}
