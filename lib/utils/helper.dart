import 'package:intl/intl.dart';
import 'package:stockmobilesync/models/master.dart';
import 'package:stockmobilesync/models/purchases.dart';
import 'package:stockmobilesync/models/sales.dart';
import 'package:stockmobilesync/models/users.dart';

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

  static bool areListsEqual(
      {required List<dynamic> api, required List<dynamic> db}) {
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

  static Map<String, List<Users>> areUsersEqual({
    required List<Users> api,
    required List<Users> db,
    Function(String status, double progress)? callback,
  }) {
    List<Users> updatedList = [];
    List<Users> deletedList = [];
    List<Users> addedList = [];

    if (db.isEmpty) {
      return {
        'update': updatedList,
        'delete': deletedList,
        'add': api,
      };
    }

    for (var apiProduct in api) {
      for (var dbProduct in db) {
        double progress = (api.indexOf(apiProduct) / api.length);
        callback?.call('Mengecek Perubahan data user', progress);
        if (apiProduct.id == dbProduct.id &&
            apiProduct.fullName != dbProduct.fullName &&
            apiProduct.password != dbProduct.password &&
            apiProduct.email != dbProduct.email &&
            apiProduct.phoneNumber != dbProduct.phoneNumber &&
            apiProduct.level != dbProduct.level &&
            apiProduct.block != dbProduct.block &&
            apiProduct.sessionId != dbProduct.sessionId) {
          updatedList.add(apiProduct);
          break;
        }
      }
    }

    for (var dbProduct in db) {
      bool state = false;
      for (var apiProduct in api) {
        double progress = (db.indexOf(dbProduct) / db.length);
        callback?.call('Mengecek kemungkinan data user dihapus', progress);
        if (dbProduct.id == apiProduct.id) {
          state = true;
          break;
        }
      }
      if (!state) {
        deletedList.add(dbProduct);
      }
    }

    for (var product in api) {
      bool state = false;
      for (var dbProduct in db) {
        double progress = (api.indexOf(product) / api.length);
        callback?.call('Mengecek kemungkinan data user ditambahkan', progress);
        if (product.id == dbProduct.id) {
          state = true;
          break;
        }
      }
      if (!state) {
        addedList.add(product);
      }
    }

    return {
      'update': updatedList,
      'delete': deletedList,
      'add': addedList,
    };
  }

  static Map<String, List<Master>> areMastersEqual({
    required List<Master> api,
    required List<Master> db,
    Function(String status, double progress)? callback,
  }) {
    List<Master> updatedList = [];
    List<Master> deletedList = [];
    List<Master> addedList = [];

    if (db.isEmpty) {
      return {
        'update': updatedList,
        'delete': deletedList,
        'add': api,
      };
    }

    for (var apiProduct in api) {
      for (var dbProduct in db) {
        double progress = (api.indexOf(apiProduct) / api.length);
        callback?.call('Mengecek Perubahan data master', progress);
        if (apiProduct.kdBrg == dbProduct.kdBrg &&
            apiProduct.nama != dbProduct.nama &&
            apiProduct.sat != dbProduct.sat &&
            apiProduct.hjual != dbProduct.hjual &&
            apiProduct.hjualcr != dbProduct.hjualcr &&
            apiProduct.akhirG != dbProduct.akhirG &&
            apiProduct.pak != dbProduct.pak &&
            apiProduct.aktif != dbProduct.aktif &&
            apiProduct.nmSupplier != dbProduct.nmSupplier &&
            apiProduct.tglBeli != dbProduct.tglBeli) {
          updatedList.add(apiProduct);
          break;
        }
      }
    }

    for (var dbProduct in db) {
      bool state = false;
      for (var apiProduct in api) {
        double progress = (db.indexOf(dbProduct) / db.length);
        callback?.call('Mengecek kemungkinan data master dihapus', progress);
        if (dbProduct.kdBrg == apiProduct.kdBrg) {
          state = true;
          break;
        }
      }
      if (!state) {
        deletedList.add(dbProduct);
      }
    }

    for (var product in api) {
      bool state = false;
      for (var dbProduct in db) {
        double progress = (api.indexOf(product) / api.length);
        callback?.call('Mengecek kemungkinan data master ditambahkan', progress);
        if (product.kdBrg == dbProduct.kdBrg) {
          state = true;
          break;
        }
      }
      if (!state) {
        addedList.add(product);
      }
    }

    return {
      'update': updatedList,
      'delete': deletedList,
      'add': addedList,
    };
  }

  static Map<String, List<Sales>> areSalesEqual({
    required List<Sales> api,
    required List<Sales> db,
    Function(String status, double progress)? callback,
  }) {
    List<Sales> updatedList = [];
    List<Sales> deletedList = [];
    List<Sales> addedList = [];

    if (db.isEmpty) {
      return {
        'update': updatedList,
        'delete': deletedList,
        'add': api,
      };
    }

    for (var apiProduct in api) {
      for (var dbProduct in db) {
        double progress = (api.indexOf(apiProduct) / api.length);
        callback?.call('Mengecek Perubahan data sales', progress);
        if (apiProduct.nota == dbProduct.nota &&
            apiProduct.nama != dbProduct.nama &&
            apiProduct.sat != dbProduct.sat &&
            apiProduct.tgl != dbProduct.tgl &&
            apiProduct.qty != dbProduct.qty &&
            apiProduct.hbeli != dbProduct.hbeli &&
            apiProduct.hjual != dbProduct.hjual &&
            apiProduct.ecer != dbProduct.ecer &&
            apiProduct.pak != dbProduct.pak &&
            apiProduct.kdsales != dbProduct.kdsales &&
            apiProduct.nmCustomer != dbProduct.nmCustomer) {
          updatedList.add(apiProduct);
          break;
        }
      }
    }

    for (var dbProduct in db) {
      bool state = false;
      for (var apiProduct in api) {
        double progress = (db.indexOf(dbProduct) / db.length);
        callback?.call('Mengecek kemungkinan data sales dihapus', progress);
        if (dbProduct.nota == apiProduct.nota) {
          state = true;
          break;
        }
      }
      if (!state) {
        deletedList.add(dbProduct);
      }
    }

    for (var product in api) {
      bool state = false;
      for (var dbProduct in db) {
        double progress = (api.indexOf(product) / api.length);
        callback?.call('Mengecek kemungkinan data sales ditambahkan', progress);
        if (product.nota == dbProduct.nota) {
          state = true;
          break;
        }
      }
      if (!state) {
        addedList.add(product);
      }
    }

    return {
      'update': updatedList,
      'delete': deletedList,
      'add': addedList,
    };
  }

  static Map<String, List<Purchases>> arePurchasesEqual({
    required List<Purchases> api,
    required List<Purchases> db,
    Function(String status, double progress)? callback,
  }) {
    List<Purchases> updatedList = [];
    List<Purchases> deletedList = [];
    List<Purchases> addedList = [];

    if (db.isEmpty) {
      return {
        'update': updatedList,
        'delete': deletedList,
        'add': api,
      };
    }

    for (var apiProduct in api) {
      for (var dbProduct in db) {
        double progress = (api.indexOf(apiProduct) / api.length);
        callback?.call('Mengecek Perubahan data purchases', progress);
        if (apiProduct.idTrans == dbProduct.idTrans &&
            apiProduct.nama != dbProduct.nama &&
            apiProduct.tgl != dbProduct.tgl &&
            apiProduct.qty != dbProduct.qty &&
            apiProduct.hbeli != dbProduct.hbeli &&
            apiProduct.hjualcr != dbProduct.hjualcr &&
            apiProduct.nmSupplier != dbProduct.nmSupplier) {
          updatedList.add(apiProduct);
          break;
        }
      }
    }

    for (var dbProduct in db) {
      bool state = false;
      for (var apiProduct in api) {
        double progress = (db.indexOf(dbProduct) / db.length);
        callback?.call('Mengecek kemungkinan data purchases dihapus', progress);
        if (dbProduct.idTrans == apiProduct.idTrans) {
          state = true;
          break;
        }
      }
      if (!state) {
        deletedList.add(dbProduct);
      }
    }

    for (var product in api) {
      bool state = false;
      for (var dbProduct in db) {
        double progress = (api.indexOf(product) / api.length);
        callback?.call('Mengecek kemungkinan data purchases ditambahkan', progress);
        if (product.idTrans == dbProduct.idTrans) {
          state = true;
          break;
        }
      }
      if (!state) {
        addedList.add(product);
      }
    }

    return {
      'update': updatedList,
      'delete': deletedList,
      'add': addedList,
    };
  }

  static Users fromJsonUser(Map<String, dynamic> json) {
    return Users.fromJson(json);
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
