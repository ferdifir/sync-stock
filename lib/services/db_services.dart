import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:stockmobilesync/models/master.dart';
import 'package:stockmobilesync/models/purchases.dart';
import 'package:stockmobilesync/models/sales.dart';
import 'package:stockmobilesync/models/users.dart';
import 'package:stockmobilesync/utils/config.dart';
import 'package:stockmobilesync/utils/helper.dart';
import 'package:stockmobilesync/utils/log.dart';

class DbServices {
  Future<Database> openDB() async {
    String userQuery = Helper.queryCreateTable('users', dbUsersQuery);
    String masterQuery = Helper.queryCreateTable('master', dbMasterQuery);
    String salesQuery = Helper.queryCreateTable('sales', dbSalesQuery);
    String purchasesQuery =
        Helper.queryCreateTable('purchases', dbPurchasesQuery);
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, dbName);
    final database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(userQuery);
        await db.execute(masterQuery);
        await db.execute(salesQuery);
        await db.execute(purchasesQuery);
      },
    );
    return database;
  }

  Future<bool> insertData(
    String tableName,
    List<Map<String, dynamic>> data, {
    Function(String status, double progress)? callback,
  }) async {
    try {
      final database = await openDB();
      for (var element in data) {
        double iteration = data.indexOf(element) / data.length;
        if (callback != null) {
          callback('Memasukkan data ${element['nama']}', iteration);
        }
        await database.insert(tableName, element);
      }
      await database.close();
      return true;
    } catch (e) {
      Log.e('Inset to DB', e.toString());
      return false;
    }
  }

  Future<bool> deleteAllData(String tableName) async {
    try {
      final database = await openDB();
      await database.delete(tableName);
      await database.close();
      return true;
    } catch (e) {
      Log.e('Delete Data in table', e.toString());
      return false;
    }
  }

  Future<List<T>> getData<T>(
    String tableName,
    String query,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final database = await openDB();
    final data = await database.rawQuery(query);
    await database.close();
    List<T> list = data.map((e) => fromJson(e)).toList();
    return list;
  }

  Future<bool> updateDataUser(
    List<Users> updateData, {
    Function(String status, double progress)? callback,
  }) async {
    try {
      final database = await openDB();
      for (var data in updateData) {
        double iteration = updateData.indexOf(data) / updateData.length;
        if (callback != null) {
          callback('Memperbarui data ${data.fullName}', iteration);
        }
        await database.update(
          'users',
          data.toJson(),
          where: 'id = ?',
          whereArgs: [data.id],
        );
      }
      await database.close();
      return true;
    } catch (e) {
      Log.e('Update to DB', e.toString());
      return false;
    }
  }

  Future<bool> deleteDataUser(
    List<Users> deleteData, {
    Function(String status, double progress)? callback,
  }) async {
    try {
      final database = await openDB();
      for (var data in deleteData) {
        double iteration = deleteData.indexOf(data) / deleteData.length;
        if (callback != null) {
          callback('Menghapus data ${data.fullName}', iteration);
        }
        await database.delete(
          'users',
          where: 'id = ?',
          whereArgs: [data.id],
        );
      }
      await database.close();
      return true;
    } catch (e) {
      Log.e('Delete from DB', e.toString());
      return false;
    }
  }

  Future<bool> updateDataMaster(
    List<Master> updateData, {
    Function(String status, double progress)? callback,
  }) async {
    try {
      final database = await openDB();
      for (var data in updateData) {
        double iteration = updateData.indexOf(data) / updateData.length;
        if (callback != null) {
          callback('Memperbarui data ${data.nama}', iteration);
        }
        await database.update(
          'master',
          data.toJson(),
          where: 'kd_brg = ?',
          whereArgs: [data.kdBrg],
        );
      }
      await database.close();
      return true;
    } catch (e) {
      Log.e('Update to DB', e.toString());
      return false;
    }
  }

  Future<bool> deleteDataMaster(
    List<Master> deleteData, {
    Function(String status, double progress)? callback,
  }) async {
    try {
      final database = await openDB();
      for (var data in deleteData) {
        double iteration = deleteData.indexOf(data) / deleteData.length;
        if (callback != null) {
          callback('Menghapus data ${data.nama}', iteration);
        }
        await database.delete(
          'master',
          where: 'kd_brg = ?',
          whereArgs: [data.kdBrg],
        );
      }
      await database.close();
      return true;
    } catch (e) {
      Log.e('Delete from DB', e.toString());
      return false;
    }
  }

  Future<bool> updateDataSales(
    List<Sales> updateData, {
    Function(String status, double progress)? callback,
  }) async {
    try {
      final database = await openDB();
      for (var data in updateData) {
        double iteration = updateData.indexOf(data) / updateData.length;
        if (callback != null) {
          callback('Memperbarui data ${data.nmCustomer}', iteration);
        }
        await database.update(
          'sales',
          data.toJson(),
          where: 'nmcustomer = ?',
          whereArgs: [data.nmCustomer],
        );
      }
      await database.close();
      return true;
    } catch (e) {
      Log.e('Update to DB', e.toString());
      return false;
    }
  }

  Future<bool> deleteDataSales(
    List<Sales> deleteData, {
    Function(String status, double progress)? callback,
  }) async {
    try {
      final database = await openDB();
      for (var data in deleteData) {
        double iteration = deleteData.indexOf(data) / deleteData.length;
        if (callback != null) {
          callback('Menghapus data ${data.nmCustomer}', iteration);
        }
        await database.delete(
          'sales',
          where: 'nmcustomer = ?',
          whereArgs: [data.nmCustomer],
        );
      }
      await database.close();
      return true;
    } catch (e) {
      Log.e('Delete from DB', e.toString());
      return false;
    }
  }

  Future<bool> updateDataPurchases(
    List<Purchases> updateData, {
    Function(String status, double progress)? callback,
  }) async {
    try {
      final database = await openDB();
      for (var data in updateData) {
        double iteration = updateData.indexOf(data) / updateData.length;
        if (callback != null) {
          callback('Memperbarui data ${data.nama}', iteration);
        }
        await database.update(
          'purchases',
          data.toJson(),
          where: 'idtranst = ?',
          whereArgs: [data.idTrans],
        );
      }
      await database.close();
      return true;
    } catch (e) {
      Log.e('Update to DB', e.toString());
      return false;
    }
  }

  Future<bool> deleteDataPurchases(
    List<Purchases> deleteData, {
    Function(String status, double progress)? callback,
  }) async {
    try {
      final database = await openDB();
      for (var data in deleteData) {
        double iteration = deleteData.indexOf(data) / deleteData.length;
        if (callback != null) {
          callback('Menghapus data ${data.nama}', iteration);
        }
        await database.delete(
          'purchases',
          where: 'idtranst = ?',
          whereArgs: [data.idTrans],
        );
      }
      await database.close();
      return true;
    } catch (e) {
      Log.e('Delete from DB', e.toString());
      return false;
    }
  }
}
