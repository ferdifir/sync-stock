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
  final dataSync = DataSynchronization();

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
      return query + limit;
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

  Future<bool> loadDataMaster() async {
    List<Master> master = await api.fetchMasterData();
    bool isSuccess = await db.insertData(
      'master',
      dbMasterQuery,
      master.map((e) => e.toJson()).toList(),
    );
    return isSuccess;
  }

  Future<bool> loadDataSales() async {
    List<Sales> sales = await api.fetchSalesData();
    bool isSuccess = await db.insertData(
      'sales',
      dbSalesQuery,
      sales.map((e) => e.toJson()).toList(),
    );
    return isSuccess;
  }

  Future<bool> loadDataPurchases() async {
    List<Purchases> purchases = await api.fetchPurchasesData();
    bool isSuccess = await db.insertData(
      'purchases',
      dbPurchasesQuery,
      purchases.map((e) => e.toJson()).toList(),
    );
    return isSuccess;
  }

  Future<bool> syncData() async {
    try {
      List<Master> masterApi = await api.fetchMasterData();
      List<Master> masterDb = await getMaster(false);
      List<Purchases> purchasesApi = await api.fetchPurchasesData();
      List<Purchases> purchasesDb = await getPurchases(false);
      List<Sales> salesApi = await api.fetchSalesData();
      List<Sales> salesDb = await getSales(false);

      bool isMasterUpdated = Helper.areListsEqual(api: masterApi, db: masterDb);
      bool isSalesUpdated = Helper.areListsEqual(api: purchasesApi, db: purchasesDb);
      bool isPurchasesUpdated = Helper.areListsEqual(api: salesApi, db: salesDb);

      if (!isMasterUpdated) {
        loadDataMaster();
      }

      if (!isSalesUpdated) {
        loadDataSales();
      }

      if (!isPurchasesUpdated) {
        loadDataPurchases();
      }

      return true;
    } catch(e) {
      return false;
    }
  }

}
