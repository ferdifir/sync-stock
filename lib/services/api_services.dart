import 'package:dio/dio.dart';
import 'package:stockmobilesync/models/master.dart';
import 'package:stockmobilesync/models/purchases.dart';
import 'package:stockmobilesync/models/sales.dart';
import 'package:stockmobilesync/models/users.dart';
import 'package:stockmobilesync/utils/config.dart';
import 'package:stockmobilesync/utils/log.dart';

class ApiServices {
  final Dio _dio = Dio(BaseOptions(baseUrl: baseUrl));

  Future<List<Users>> fetchUserData() async {
    try {
      final response = await _dio.get(userApi);
      final result = response.data;
      final data = result['data'];
      if (response.statusCode == 200) {
        return _parseUserData(data);
      }
    } catch (e) {
      Log.e('Fetch User Data', '$e');
    }
    return [];
  }

  Future<List<Master>> fetchMasterData() async {
    try {
      final response = await _dio.get(masterApi);
      final result = response.data;
      final data = result['data'];
      if (response.statusCode == 200) {
        return _parseMasterData(data);
      }
    } catch (e) {
      Log.e('Fetch Master Data', '$e');
    }
    return [];
  }

  Future<List<Sales>> fetchSalesData() async {
    try {
      final response = await _dio.get(salesApi);
      final result = response.data;
      final data = result['data'];
      if (response.statusCode == 200) {
        return _parseSalesData(data);
      }
    } catch (e) {
      Log.e('Fetch Sales Data', '$e');
    }
    return [];
  }

  Future<List<Purchases>> fetchPurchasesData() async {
    try {
      final response = await _dio.get(purchaseApi);
      final result = response.data;
      final data = result['data'];
      if (response.statusCode == 200) {
        return _parsePurchasesData(data);
      }
    } catch (e) {
      Log.e('Fetch Purchases Data', '$e');
    }
    return [];
  }

  List<Users> _parseUserData(dynamic data) {
    return data.map<Users>((json) => Users.fromJson(json)).toList();
  }

  List<Master> _parseMasterData(dynamic data) {
    return data.map<Master>((json) => Master.fromJson(json)).toList();
  }

  List<Sales> _parseSalesData(dynamic data) {
    return data.map<Sales>((json) => Sales.fromJson(json)).toList();
  }

  List<Purchases> _parsePurchasesData(dynamic data) {
    return data.map<Purchases>((json) => Purchases.fromJson(json)).toList();
  }
}
