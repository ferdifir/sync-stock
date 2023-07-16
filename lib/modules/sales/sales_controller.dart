import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockmobilesync/models/sales.dart';
import 'package:stockmobilesync/services/db_services.dart';
import 'package:stockmobilesync/utils/helper.dart';
import 'package:stockmobilesync/utils/log.dart';

class SalesController extends GetxController {
  final db = DbServices();
  RxList<Sales> sales = RxList();
  RxBool isSearch = false.obs;
  RxBool isLoading = false.obs;
  RxString searchQuery = ''.obs;
  RxString searchCustomerQuery = ''.obs;
  RxString fromDate = ''.obs;
  RxString toDate = ''.obs;
  int offset = 0;
  RxBool isLoadMoreData = false.obs;
  final scrollController = ScrollController();
  String statusQuery = 'master';
  String sessionId = Get.arguments;
  RxBool isSearchCustomer = false.obs;

  @override
  void onInit() {
    super.onInit();
    getSalesMaster();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (statusQuery == 'master') {
          getSalesMaster();
        } else if (statusQuery == 'search') {
          searchSales();
        } else if (statusQuery == 'search customer') {
          searchCustomer();
        } else {
          filterSales();
        }
      }
    });
  }

  clearFilter() {
    fromDate.value = '';
    toDate.value = '';
  }

  toggleSearch() {
    isSearch.value = !isSearch.value;
  }

  getSalesMaster() async {
    isLoading.value = true;
    isLoadMoreData.value = true;
    statusQuery = 'master';
    //sales.clear();
    try {
      String query = sessionId.isEmpty
          ? "SELECT * FROM sales ORDER BY tgl DESC LIMIT 10 OFFSET $offset"
          : "SELECT * FROM sales WHERE kdsales = '$sessionId' ORDER BY tgl DESC LIMIT 10 OFFSET $offset";
      offset += 10;
      List<Sales> updatedSales = await getListData(query);
      sales.addAll(updatedSales);
      isLoadMoreData.value = false;
      isLoading.value = false;
    } catch (e) {
      Log.e('Get List Sales', e.toString());
      isLoading.value = false;
      isLoadMoreData.value = false;
    }
  }

  searchSales() async {
    isLoading.value = true;
    isLoadMoreData.value = true;
    statusQuery = 'search customer';
    //sales.clear();
    try {
      String query = sessionId.isEmpty
          ? "SELECT * FROM sales WHERE nama LIKE '%${searchQuery.value}%' ORDER BY tgl DESC LIMIT 10 OFFSET $offset"
          : "SELECT * FROM sales WHERE nama LIKE '%${searchQuery.value}%' AND kdsales = '$sessionId' ORDER BY tgl DESC LIMIT 10 OFFSET $offset";
      offset += 10;
      List<Sales> updatedSales = await getListData(query);
      sales.addAll(updatedSales);
      isLoadMoreData.value = false;
      isLoading.value = false;
    } catch (e) {
      Log.e('Search Sales', e.toString());
      isLoading.value = false;
      isLoadMoreData.value = false;
    }
  }

  searchCustomer() async {
    isLoading.value = true;
    isLoadMoreData.value = true;
    statusQuery = 'search customer';
    //sales.clear();
    try {
      String query = sessionId.isEmpty
          ? "SELECT * FROM sales WHERE nama LIKE '%${searchCustomerQuery.value}%' ORDER BY tgl DESC LIMIT 10 OFFSET $offset"
          : "SELECT * FROM sales WHERE nama LIKE '%${searchCustomerQuery.value}%' AND kdsales = '$sessionId' ORDER BY tgl DESC LIMIT 10 OFFSET $offset";
      offset += 10;
      List<Sales> updatedSales = await getListData(query);
      sales.addAll(updatedSales);
      isLoadMoreData.value = false;
      isLoading.value = false;
    } catch (e) {
      Log.e('Search Sales', e.toString());
      isLoading.value = false;
      isLoadMoreData.value = false;
    }
  }

  filterSales() async {
    isLoading.value = true;
    //sales.clear();
    statusQuery = 'filter';
    try {
      String query = sessionId.isEmpty
          ? "SELECT * FROM sales WHERE nama LIKE '%${searchQuery.value}%' AND tgl BETWEEN '${fromDate.value}' AND '${toDate.value}' ORDER BY tgl DESC LIMIT 10 OFFSET $offset"
          : "SELECT * FROM sales WHERE nama LIKE '%${searchQuery.value}%' AND tgl BETWEEN '${fromDate.value}' AND '${toDate.value}' AND kdsales = '$sessionId' ORDER BY tgl DESC LIMIT 10 OFFSET $offset";
      offset += 10;
      List<Sales> updatedSales = await getListData(query);
      sales.addAll(updatedSales);
      isLoadMoreData.value = false;
      isLoading.value = false;
    } catch (e) {
      Log.e('Filter Sales', e.toString());
      isLoading.value = false;
      isLoadMoreData.value = false;
    }
  }

  Future<List<Sales>> getListData(String query) async {
    var data = await db.getData<Sales>(
      'sales',
      query,
      Helper.fromJsonSales,
    );
    return data;
  }
}
