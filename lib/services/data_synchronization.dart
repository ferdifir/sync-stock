import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:stockmobilesync/services/api_services.dart';
import 'package:stockmobilesync/utils/helper.dart';
import 'package:stockmobilesync/utils/log.dart';

import '../models/master.dart';
import '../models/purchases.dart';
import '../models/sales.dart';
import '../models/users.dart';
import '../utils/config.dart';

class DataSynchronization {
  final apiServices = ApiServices();

  Future<bool> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Users> users = [];
    int databaseVersion = prefs.getInt(dbUserVersion) ?? 1;
    String userQuery = Helper.queryCreateTable('users', [
      'id INTEGER PRIMARY KEY',
      'username TEXT',
      'password TEXT',
      'nama_lengkap TEXT',
      'email TEXT',
      'no_telp TEXT',
      'level TEXT',
      'blokir TEXT',
      'id_session TEXT'
    ]);
    double progress = 0;
    try {
      users = await apiServices.fetchUserData();

      progress += 0.2;
      print('Progress: ${progress * 100}% - Data User fetched from API.');

      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, dbUsers);
      final database = await openDatabase(
        path,
        version: databaseVersion,
        onCreate: (db, version) {
          db.execute(userQuery);
        },
      );

      for (var item in users) {
        await database.insert('users', item.toJson());
      }

      progress += 0.6;
      print('Progress: ${progress * 100}% - Data User inserted to database.');

      int storedDataCount =
          await database.query('users').then((value) => value.length);
      bool isDataSameLength = storedDataCount == users.length;
      await database.close();

      prefs.setInt(dbUserVersion, databaseVersion + 1);

      progress += 0.2;
      print('Progress: ${progress * 100}% - Database User version updated.');
      return isDataSameLength;
    } catch (e) {
      Log.e('Fetch User Data', '$e');
      return false;
    }
  }

  Future<bool> fetchMasterData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Master> masters = [];
    int databaseVersion = prefs.getInt(dbMasterVersion) ?? 1;
    String masterQuery = Helper.queryCreateTable('master', [
      'kd_brg TEXT PRIMARY KEY',
      'nama TEXT',
      'sat TEXT',
      'hjual INTEGER',
      'hjualcr INTEGER',
      'akhir_g TEXT',
      'pak TEXT',
      'aktif INTEGER',
      'nmsupplier TEXT',
      'tglbeli DATE'
    ]);

    double progress = 0;
    try {
      masters = await apiServices.fetchMasterData();

      progress += 0.2;
      print('Progress: ${progress * 100}% - Data Master fetched from API.');

      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, dbMaster);
      final database = await openDatabase(
        path,
        version: databaseVersion,
        onCreate: (db, version) {
          db.execute(masterQuery);
        },
      );

      for (var item in masters) {
        await database.insert('master', item.toJson());
      }

      progress += 0.6;
      print('Progress: ${progress * 100}% - Data Master inserted to database.');

      int storedDataCount =
          await database.query('master').then((value) => value.length);
      bool isDataSameLength = storedDataCount == masters.length;
      await database.close();

      prefs.setInt(dbMasterVersion, databaseVersion + 1);

      progress += 0.2;
      print('Progress: ${progress * 100}% - Database Master version updated.');
      return isDataSameLength;
    } catch (e) {
      Log.e('Fetch Master Data', '$e');
      return false;
    }
  }

  Future<bool> fetchSalesData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Sales> sales = [];
    int databaseVersion = prefs.getInt(dbSalesVersion) ?? 1;
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
    double progress = 0;
    try {
      sales = await apiServices.fetchSalesData();

      progress += 0.2;
      print('Progress: ${progress * 100}% - Data Sales fetched from API.');

      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, dbSales);
      final database = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) {
          db.execute(salesQuery);
        },
      );

      for (var item in sales) {
        await database.insert('sales', item.toJson());
        print('Menambahkan data ${item.nama} ke database sales');
      }

      progress += 0.6;
      print('Progress: ${progress * 100}% - Data Sales inserted to database.');

      int storedDataCount =
          await database.query('sales').then((value) => value.length);
      bool isDataSameLength = storedDataCount == sales.length;
      await database.close();

      prefs.setInt(dbSalesVersion, databaseVersion + 1);

      progress += 0.2;
      print('Progress: ${progress * 100}% - Database Sales version updated.');
      return isDataSameLength;
    } catch (e) {
      Log.e('Fetch Sales Data', '$e');
      return false;
    }
  }

  Future<bool> fetchPurchasesData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Purchases> purchases = [];
    int databaseVersion = prefs.getInt(dbPurchasesVersion) ?? 1;
    String purchasesQuery = Helper.queryCreateTable('purchases', [
      'idtranst INTEGER PRIMARY KEY',
      'nama TEXT',
      'tgl DATE',
      'qty TEXT',
      'hbeli TEXT',
      'hjualcr INTEGER',
      'nmsupplier TEXT'
    ]);
    double progress = 0;
    try {
      purchases = await apiServices.fetchPurchasesData();

      progress += 0.2;
      print('Progress: ${progress * 100}% - Data Purchases fetched from API.');

      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, dbPurchases);
      final database = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) {
          db.execute(purchasesQuery);
        },
      );

      for (var item in purchases) {
        await database.insert('purchases', item.toJson());
      }

      progress += 0.6;
      print(
          'Progress: ${progress * 100}% - Data Purchases inserted to database.');

      int storedDataCount =
          await database.query('purchases').then((value) => value.length);
      bool isDataSameLength = storedDataCount == purchases.length;
      await database.close();

      prefs.setInt(dbPurchasesVersion, databaseVersion + 1);

      progress += 0.2;
      print(
          'Progress: ${progress * 100}% - Database Purchases version updated.');
      return isDataSameLength;
    } catch (e) {
      Log.e('Fetch Purchases Data', '$e');
      return false;
    }
  }

}
