import 'package:intl/intl.dart';
import 'package:stockmobilesync/models/master.dart';
import 'package:stockmobilesync/models/purchases.dart';
import 'package:stockmobilesync/models/sales.dart';

class Helper {
  static String rupiah(int? value) {
    if (value == null) return 'Rp 0';
    return 'Rp ${value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  static String queryCreateTable(
    String tableName,
    List<String> columns,
  ) {
    return 'CREATE TABLE IF NOT EXISTS $tableName (${columns.join(', ')})';
  }

  static String convertToDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    String formattedDate = DateFormat('EEEE, dd MMMM yyyy').format(dateTime);
    return formattedDate;
  }

  static bool areListsEqual({required List<dynamic> api, required List<dynamic> db}) {
    if (api.length != db.length) {
      return false;
    }

    for (var i = 0; i < api.length; i++) {
      var apiNameProduct = api[i].toJson()['nama'];
      var dbNameProduct = db[i].toJson()['nama'];
      if (apiNameProduct != dbNameProduct) {
        return false;
      }
    }

    return true;
  }

  static Master fromJsonMaster(Map<String, dynamic> json) {
    return Master.fromJson(json);
  }

  static Sales fromJsonSales(Map<String, dynamic> json) {
    return Sales.fromJson(json);
  }

  static Purchases fromJsonPurchases(Map<String, dynamic> json) {
    return Purchases.fromJson(json);
  }

}
