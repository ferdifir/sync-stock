import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockmobilesync/models/master.dart';
import 'package:stockmobilesync/models/purchases.dart';
import 'package:stockmobilesync/models/sales.dart';
import 'package:stockmobilesync/services/api_services.dart';
import 'package:stockmobilesync/services/data_synchronization.dart';
import 'package:stockmobilesync/services/db_services.dart';
import 'package:stockmobilesync/utils/config.dart';
import 'package:stockmobilesync/utils/helper.dart';

class DashboardController extends GetxController {
  SharedPreferences? pref;
  final api = ApiServices();
  final db = DbServices();
  final synData = DataSynchronization();

  RxString name = RxString('');
  RxString email = RxString('');
  RxString level = RxString('');
  RxBool firstSynch = RxBool(true);
  RxString statusSync = RxString('Sinkronisasi data');
  RxDouble progressSync = RxDouble(0);

  @override
  void onInit() async {
    super.onInit();
    pref = await SharedPreferences.getInstance();
    fetchUserData();
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
  }

  String querySelectData(String tableName,{required bool forAvailibility}) {
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
    String purchasesQuery = querySelectData('purchases', forAvailibility: isCheck);
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
      'master',
      master.map((e) => e.toJson()).toList(),
      callback: callback
    );
    return isSuccess;
  }

  Future<bool> loadDataSales(Function(String, double)? callback) async {
    callback!('Memulai Sinkronisasi', 0.001);
    List<Sales> sales = await api.fetchSalesData();
    callback('Mengambil Data Penjualan dari API', 0.002);
    bool isSuccess = await db.insertData(
      'sales',
      sales.map((e) => e.toJson()).toList(),
      callback: callback
    );
    return isSuccess;
  }

  Future<bool> loadDataPurchases(Function(String, double)? callback) async {
    callback!('Memulai Sinkronisasi', 0.001);
    List<Purchases> purchases = await api.fetchPurchasesData();
    callback('Mengambil Data Pembelian dari API', 0.002);
    bool isSuccess = await db.insertData(
      'purchases',
      purchases.map((e) => e.toJson()).toList(),
      callback: callback
    );
    return isSuccess;
  }

  Future<bool> syncData(Function(String, double) callback) async {
    callback('Memulai Sinkronisasi', 0.001);
    bool userSync = await synData.syncDataUser(callback: callback);
    bool masterSync = await synData.syncDataMaster(callback: callback);
    bool salesSync = await synData.syncDataSales(callback: callback);
    bool purchasesSync = await synData.syncDataPurchases(callback: callback);

    if (userSync && masterSync && salesSync && purchasesSync) {
      pref?.setBool(firstTimeSync, false);
      return true;
    } else {
      return false;
    }
  }

}
