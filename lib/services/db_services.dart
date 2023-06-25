import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:stockmobilesync/utils/config.dart';
import 'package:stockmobilesync/utils/helper.dart';
import 'package:stockmobilesync/utils/log.dart';

class DbServices {
  
  Future<Database> openDB() async {
    String userQuery = Helper.queryCreateTable('users', dbUsersQuery);
    String masterQuery = Helper.queryCreateTable('master', dbMasterQuery);
    String salesQuery = Helper.queryCreateTable('sales', dbSalesQuery);
    String purchasesQuery = Helper.queryCreateTable('purchases', dbPurchasesQuery);
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
      await database.delete(tableName);
      for (var element in data) {
        double iteration = data.indexOf(element) / data.length;
        if (callback != null) {
          callback('Memasukkan data ${element['nama']}', iteration);
        }
        await database.insert(tableName, element);
      }
      await database.close();
      return true;
    } catch(e) {
      Log.e('Inset to DB', e.toString());
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
}
