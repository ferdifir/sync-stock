import 'package:stockmobilesync/models/master.dart';
import 'package:stockmobilesync/models/purchases.dart';
import 'package:stockmobilesync/models/sales.dart';
import 'package:stockmobilesync/services/api_services.dart';
import 'package:stockmobilesync/services/db_services.dart';
import 'package:stockmobilesync/utils/helper.dart';
import 'package:stockmobilesync/utils/log.dart';

import '../models/users.dart';

class DataSynchronization {
  final db = DbServices();
  final api = ApiServices();

  Future<bool> syncDataUser({
    Function(String status, double progress)? callback,
  }) async {
    String query = "SELECT * FROM users";
    try {
      List<Users> users = await api.fetchUserData();
      List<Users> dbUsers = await db.getData<Users>(
        'users',
        query,
        Helper.fromJsonUser,
      );

      Map<String, List<Users>> result = Helper.areUsersEqual(
        api: users,
        db: dbUsers,
        callback: callback,
      );

      List<Users> updatedList = result['update']!;
      List<Users> deletedList = result['delete']!;
      List<Users> addedList = result['add']!;

      bool update = false;
      if (updatedList.isNotEmpty) {
        update = await db.updateDataUser(updatedList,callback: callback);
      } else {
        callback?.call('Tidak ada data yang perlu diupdate', 1);
      }
      Log.d('Update Data User', update.toString());

      bool delete = false;
      if (deletedList.isNotEmpty) {
        delete = await db.deleteDataUser(deletedList,callback: callback);
      } else {
        callback?.call('Tidak ada data yang perlu dihapus', 1);
      }
      Log.d('Delete Data User', delete.toString());

      bool add = false;
      if (addedList.isNotEmpty) {
        add = await db.insertData(
          'users',
          addedList.map((e) => e.toJson()).toList(),
          callback: callback,
        );
      } else {
        callback?.call('Tidak ada data yang perlu ditambahkan', 1);
      }
      Log.d('Add Data User', add.toString());

      callback?.call('Sinkronisasi data user selesai', 1);
      return true;
    } catch (e) {
      Log.d('Load Data User', e.toString());
      return false;
    }
  }

  Future<bool> syncDataMaster({
    Function(String status, double progress)? callback,
  }) async {
    String query = "SELECT * FROM master";
    try {
      List<Master> masters = await api.fetchMasterData();
      List<Master> dbMasters = await db.getData<Master>(
        'master',
        query,
        Helper.fromJsonMaster,
      );

      Map<String, List<Master>> result = Helper.areMastersEqual(
        api: masters,
        db: dbMasters,
        callback: callback,
      );

      List<Master> updatedList = result['update']!;
      List<Master> deletedList = result['delete']!;
      List<Master> addedList = result['add']!;

      bool update = false;
      if (updatedList.isNotEmpty) {
        update = await db.updateDataMaster(updatedList,callback: callback);
      } else {
        callback?.call('Tidak ada data yang perlu diupdate', 1);
      }
      Log.d('Update Data Master', update.toString());

      bool delete = false;
      if (deletedList.isNotEmpty) {
        delete = await db.deleteDataMaster(deletedList,callback: callback);
      } else {
        callback?.call('Tidak ada data yang perlu dihapus', 1);
      }
      Log.d('Delete Data Master', delete.toString());

      bool add = false;
      if (addedList.isNotEmpty) {
        add = await db.insertData(
          'master',
          addedList.map((e) => e.toJson()).toList(),
          callback: callback,
        );
      } else {
        callback?.call('Tidak ada data yang perlu ditambahkan', 1);
      }
      Log.d('Add Data Master', add.toString());

      callback?.call('Sinkronisasi data master selesai', 1);
      return true;
    } catch (e) {
      Log.d('Load Data Master', e.toString());
      return false;
    }
  }

  Future<bool> syncDataSales({
    Function(String status, double progress)? callback,
  }) async {
    String query = "SELECT * FROM sales";
    try {
      List<Sales> sales = await api.fetchSalesData();
      List<Sales> dbSales = await db.getData<Sales>(
        'sales',
        query,
        Helper.fromJsonSales,
      );

      Map<String, List<Sales>> result = Helper.areSalesEqual(
        api: sales,
        db: dbSales,
        callback: callback,
      );

      List<Sales> updatedList = result['update']!;
      List<Sales> deletedList = result['delete']!;
      List<Sales> addedList = result['add']!;

      bool update = false;
      if (updatedList.isNotEmpty) {
        update = await db.updateDataSales(updatedList,callback: callback);
      } else {
        callback?.call('Tidak ada data yang perlu diupdate', 1);
      }
      Log.d('Update Data Sales', update.toString());

      bool delete = false;
      if (deletedList.isNotEmpty) {
        delete = await db.deleteDataSales(deletedList,callback: callback);
      } else {
        callback?.call('Tidak ada data yang perlu dihapus', 1);
      }
      Log.d('Delete Data Sales', delete.toString());

      bool add = false;
      if (addedList.isNotEmpty) {
        add = await db.insertData(
          'sales',
          addedList.map((e) => e.toJson()).toList(),
          callback: callback,
        );
      } else {
        callback?.call('Tidak ada data yang perlu ditambahkan', 1);
      }
      Log.d('Add Data Sales', add.toString());

      callback?.call('Sinkronisasi data sales selesai', 1);
      return true;
    } catch (e) {
      Log.d('Load Data Sales', e.toString());
      return false;
    }
  }

  Future<bool> syncDataPurchases({
    Function(String status, double progress)? callback,
  }) async {
    String query = "SELECT * FROM purchases";
    try {
      List<Purchases> purchases = await api.fetchPurchasesData();
      List<Purchases> dbPurchases = await db.getData<Purchases>(
        'purchases',
        query,
        Helper.fromJsonPurchases,
      );

      Map<String, List<Purchases>> result = Helper.arePurchasesEqual(
        api: purchases,
        db: dbPurchases,
        callback: callback,
      );

      List<Purchases> updatedList = result['update']!;
      List<Purchases> deletedList = result['delete']!;
      List<Purchases> addedList = result['add']!;

      bool update = false;
      if (updatedList.isNotEmpty) {
        update = await db.updateDataPurchases(updatedList,callback: callback);
      } else {
        callback?.call('Tidak ada data yang perlu diupdate', 1);
      }
      Log.d('Update Data Purchases', update.toString());

      bool delete = false;
      if (deletedList.isNotEmpty) {
        delete = await db.deleteDataPurchases(deletedList,callback: callback);
      } else {
        callback?.call('Tidak ada data yang perlu dihapus', 1);
      }
      Log.d('Delete Data Purchases', delete.toString());

      bool add = false;
      if (addedList.isNotEmpty) {
        add = await db.insertData(
          'purchases',
          addedList.map((e) => e.toJson()).toList(),
          callback: callback,
        );
      } else {
        callback?.call('Tidak ada data yang perlu ditambahkan', 1);
      }
      Log.d('Add Data Purchases', add.toString());

      callback?.call('Sinkronisasi data purchases selesai', 1);
      return true;
    } catch (e) {
      Log.d('Load Data Purchases', e.toString());
      return false;
    }
  }
}
