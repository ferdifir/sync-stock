import 'package:dio/dio.dart';
import 'package:stockmobilesync/utils/config.dart';
import 'package:stockmobilesync/utils/log.dart';

class ApiServices {
  final Dio _dio = Dio(BaseOptions(baseUrl: baseUrl));

  Future<dynamic> fetchUserData() async {
    try {
      final response = await _dio.get(userApi);
      final result = response.data;
      final data = result['data'];
      if (response.statusCode == 200) {
        return data;
      } else {
        Log.d('Fetch User Data', '${response.statusCode}');
      }
    } catch (e) {
      Log.e('Fetch User Data', '$e');
    }
  }

  Future<dynamic> fetchMasterData() async {
    try {
      final response = await _dio.get(masterApi);
      final result = response.data;
      final data = result['data'];
      return data;
    } catch (e) {
      Log.e('Fetch Master Data', '$e');
    }
  }

  Future<dynamic> fetchSalesData() async {
    try {
      final response = await _dio.get(salesApi);
      final result = response.data;
      final data = result['data'];
      return data;
    } catch (e) {
      Log.e('Fetch Sales Data', '$e');
    }
  }

  Future<dynamic> fetchPurchasesData() async {
    try {
      final response = await _dio.get(purchaseApi);
      final result = response.data;
      final data = result['data'];
      return data;
    } catch (e) {
      Log.e('Fetch Purchases Data', '$e');
    }
  }
}