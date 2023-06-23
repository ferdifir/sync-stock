import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:stockmobilesync/models/master.dart';
import 'package:stockmobilesync/models/purchases.dart';
import 'package:stockmobilesync/models/sales.dart';
import 'package:stockmobilesync/models/users.dart';
import 'package:stockmobilesync/services/api_services.dart';
import 'package:stockmobilesync/services/data_synchronization.dart';
import 'package:stockmobilesync/utils/config.dart';
import 'package:stockmobilesync/utils/helper.dart';
import 'package:stockmobilesync/utils/log.dart';

class DashboardController extends GetxController {
  SharedPreferences? pref;
  final apiServices = ApiServices();
  final dataSync = DataSynchronization();

  RxString name = RxString('');
  RxString email = RxString('');
  RxString level = RxString('');
  RxBool firstSynch = RxBool(true);

  RxBool isSalesAvailable = RxBool(false);
  RxBool isPurchasesAvailable = RxBool(false);

  @override
  void onInit() async {
    super.onInit();
    pref = await SharedPreferences.getInstance();
    fetchUserData();
    checkDataAvailability();
  }

  Future<bool> isTableExists(Database database, String tableName) async {
    var result = await database.rawQuery(
        "SELECT * FROM $tableName");
    return result.isNotEmpty;
  }

  checkDataAvailability() async {
    try {
      var databasePath = await getDatabasesPath();
      String pathSales = join(databasePath, dbSales);
      String pathPurchases = join(databasePath, dbPurchases);
      final databaseSales = await openDatabase(pathSales);
      final databasePurchases = await openDatabase(pathPurchases);

      bool isSalesTableExists = await isTableExists(databaseSales, 'sales');
      bool isPurchasesTableExists =
          await isTableExists(databasePurchases, 'purchases');

      isSalesAvailable.value = isSalesTableExists;
      isPurchasesAvailable.value = isPurchasesTableExists;
    } catch (e) {
      printError(info: e.toString());
      isSalesAvailable.value = false;
      isPurchasesAvailable.value = false;
    }
  }

  void fetchUserData() {
    name.value = pref?.getString(namePrefKey) ?? '';
    email.value = pref?.getString(emailPrefKey) ?? '';
    level.value = pref?.getString(levelPrefKey) ?? '';
    firstSynch.value = pref?.getBool(firstTimeSync) ?? true;
  }

  Future<Map> fetchDataFromApi() async {
    final userData = await apiServices.fetchUserData();
    final masterData = await apiServices.fetchMasterData();
    final salesData = await apiServices.fetchSalesData();
    final purchasesData = await apiServices.fetchPurchasesData();

    return {
      'users': userData,
      'master': masterData,
      'sales': salesData,
      'purchases': purchasesData,
    };
  }

  Future<bool> firstSync(
    Function(String status, double progress) callback,
  ) async {
    List<Purchases> purchases = [];
    List<Sales> sales = [];
    try {
      callback('Mengambil data dari API...', 0.1);
      final fetchedPurchases = await apiServices.fetchPurchasesData();
      callback('Mengambil data dari API...', 0.25);
      final fetchedSales = await apiServices.fetchSalesData();
      callback('Mengambil data dari API...', 0.5);

      fetchedPurchases.forEach((element) {
        purchases.add(Purchases.fromJson(element));
      });
      callback('Mengambil data dari API...', 0.75);
      fetchedSales.forEach((element) {
        sales.add(Sales.fromJson(element));
      });
      callback('Mengambil data dari API...', 1);

      var databasesPath = await getDatabasesPath();
      String purchasesPath = join(databasesPath, dbPurchases);
      String salesPath = join(databasesPath, dbSales);

      final purchasesDb = await openDatabase(
        purchasesPath,
      );
      callback('Membuat database purchases', 1);

      final salesDb = await openDatabase(
        salesPath,
      );
      callback('Membuat database sales', 1);

      for (var item in purchases) {
        await purchasesDb.insert('purchases', item.toJson());
      }

      for (var item in sales) {
        await salesDb.insert('sales', item.toJson());
      }

      await purchasesDb.close();
      await salesDb.close();

      pref?.setBool(firstTimeSync, false);
      firstSynch.value = pref?.getBool(firstTimeSync) ?? false;
      return true;
    } catch (e) {
      printError(info: e.toString());
      callback('Terjadi kesalahan', 0);
      return false;
    }
  }

  Future<bool> syncData(
    Function(String status, double progress) callback,
  ) async {
    try {
      int totalSteps = 4;
      int currentStep = 0;

      void updateProgress() {
        double percentage = (currentStep / totalSteps) * 100;
        callback('Mengupdate...', percentage);
      }

      callback('Mengambil data dari API...', 0);

      List<Users> listUserApi = [];
      List<Users> listUserDb = [];
      List<Master> listMasterApi = [];
      List<Master> listMasterDb = [];
      List<Sales> listSalesApi = [];
      List<Sales> listSalesDb = [];
      List<Purchases> listPurchasesApi = [];
      List<Purchases> listPurchasesDb = [];

      Map dataFromApi = await fetchDataFromApi();
      List<Map<String, dynamic>> userFromDb = await getUserData();
      List<Map<String, dynamic>> masterFromDb = await getMasterData();
      List<Map<String, dynamic>> salesFromDb = await getSalesData();
      List<Map<String, dynamic>> purchasesFromDb = await getPurchasesData();

      dataFromApi['users'].forEach((element) {
        listUserApi.add(Users.fromJson(element));
      });

      dataFromApi['master'].forEach((element) {
        listMasterApi.add(Master.fromJson(element));
      });

      dataFromApi['sales'].forEach((element) {
        listSalesApi.add(Sales.fromJson(element));
      });

      dataFromApi['purchases'].forEach((element) {
        listPurchasesApi.add(Purchases.fromJson(element));
      });

      currentStep++;
      updateProgress();

      for (var element in userFromDb) {
        listUserDb.add(Users.fromJson(element));
      }

      for (var element in masterFromDb) {
        listMasterDb.add(Master.fromJson(element));
      }

      for (var element in salesFromDb) {
        listSalesDb.add(Sales.fromJson(element));
      }

      for (var element in purchasesFromDb) {
        listPurchasesDb.add(Purchases.fromJson(element));
      }

      if (!compareList(listUserApi, listUserDb)) {
        callback(
            'Sinkronisasi data pengguna...', (currentStep / totalSteps) * 100);
        await syncUsers(listUserApi);
      }

      currentStep++;
      updateProgress();

      if (!compareList(listMasterApi, listMasterDb)) {
        callback(
            'Sinkronisasi data master...', (currentStep / totalSteps) * 100);
        await syncMaster(listMasterApi);
      }

      currentStep++;
      updateProgress();

      if (!compareList(listSalesApi, listSalesDb)) {
        callback(
            'Sinkronisasi data penjualan...', (currentStep / totalSteps) * 100);
        await syncSales(listSalesApi);
      }

      currentStep++;
      updateProgress();

      if (!compareList(listPurchasesApi, listPurchasesDb)) {
        callback(
            'Sinkronisasi data pembelian...', (currentStep / totalSteps) * 100);
        await syncPurchases(listPurchasesApi);
      }

      callback('Sinkronisasi selesai', 100);

      return true;
    } catch (e) {
      printError(info: e.toString());
      callback('Terjadi kesalahan', 0);
      return false;
    }
  }

  bool compareList(List api, List dbLocal) {
    if (api.length != dbLocal.length) {
      return false;
    } else {
      for (var i = 0; i < api.length; i++) {
        if (api[i].toJson() != dbLocal[i].toJson()) {
          return false;
        }
      }
    }
    return true;
  }

  Future<List<Map<String, dynamic>>> getDataFromTable(
    String databaseName,
    String tableName,
  ) async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, databaseName);
    final db = await openDatabase(path);
    List<Map<String, dynamic>> dataList =
        await db.rawQuery("SELECT * FROM $tableName");
    return dataList;
  }

  Future<List<Map<String, dynamic>>> getUserData() async {
    return getDataFromTable(dbUsers, 'users');
  }

  Future<List<Map<String, dynamic>>> getMasterData() async {
    return getDataFromTable(dbMaster, 'master');
  }

  Future<List<Map<String, dynamic>>> getSalesData() async {
    return getDataFromTable(dbSales, 'sales');
  }

  Future<List<Map<String, dynamic>>> getPurchasesData() async {
    return getDataFromTable(dbPurchases, 'purchases');
  }

  syncUsers(List<Users> list) async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, dbUsers);
    final db = await openDatabase(path);
    await db.delete('users');

    for (var item in list) {
      await db.insert('users', item.toJson());
    }

    await db.close();
  }

  syncMaster(List<Master> list) async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, dbMaster);
    final db = await openDatabase(path);
    await db.delete('master');

    for (var item in list) {
      await db.insert('master', item.toJson());
    }

    await db.close();
  }

  syncSales(List<Sales> list) async {
    String salesQuery = Helper.queryCreateTable('sales', [
      'idsales INTEGER PRIMARY KEY AUTOINCREMENT',
      'nmcustomer TEXT',
      'nama TEXT',
      'sat TEXT',
      'qty TEXT',
      'hjual TEXT',
      'ecer INTEGER',
      'pak TEXT',
      'nota TEXT',
      'tgl DATE',
      'hbeli TEXT',
      'kdsales TEXT'
    ]);
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, dbSales);
    final db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(salesQuery);
      },
    );
    await db.delete('sales');

    for (var item in list) {
      await db.insert('sales', item.toJson());
    }

    await db.close();
  }

  syncPurchases(List<Purchases> list) async {
    String purchasesQuery = Helper.queryCreateTable('purchases', [
      'idtranst INTEGER PRIMARY KEY',
      'nama TEXT',
      'tgl DATE',
      'qty TEXT',
      'hbeli TEXT',
      'hjualcr INTEGER',
      'nmsupplier TEXT'
    ]);
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, dbPurchases);
    final db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(purchasesQuery);
      },
    );
    await db.delete('purchases');

    for (var item in list) {
      await db.insert('purchases', item.toJson());
    }

    await db.close();
  }
}
