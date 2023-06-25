import 'package:get/get.dart';
import 'package:stockmobilesync/models/purchases.dart';
import 'package:stockmobilesync/services/db_services.dart';
import 'package:stockmobilesync/utils/helper.dart';
import 'package:stockmobilesync/utils/log.dart';

class PurchasesController extends GetxController {
  final db = DbServices();
  RxList<Purchases> purchases = RxList();
  RxBool isSearch = false.obs;
  RxBool isLoading = false.obs;
  RxString searchQuery = ''.obs;
  RxString fromDate = ''.obs;
  RxString toDate = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getPurchasesMaster();
  }

  clearFilter() {
    fromDate.value = '';
    toDate.value = '';
  }

  toggleSearch() {
    isSearch.value = !isSearch.value;
  }

  getPurchasesMaster() async {
    isLoading.value = true;
    purchases.clear();
    try {
      String query = "SELECT * FROM purchases";
      purchases.value = await getListData(query);
      isLoading.value = false;
    } catch(e) {
      Log.e('Get List Purchases', e.toString());
      isLoading.value = false;
    }
  }

  searchPurchases(String keyword) async {
    isLoading.value = true;
    purchases.clear();
    try {
      String query = "SELECT * FROM purchases WHERE nama LIKE '%$keyword%'";
      purchases.value = await getListData(query);
      isLoading.value = false;
    } catch(e) {
      Log.e('Search Purchases', e.toString());
      isLoading.value = false;
    }
  }

  filterPurchases(String from, String to) async {
    isLoading.value = true;
    purchases.clear();
    try {
      String query = "SELECT * FROM purchases WHERE nama LIKE '%${searchQuery.value}%' AND tgl BETWEEN '$from' AND '$to'";
      purchases.value = await getListData(query);
      isLoading.value = false;
    } catch(e) {
      Log.e('Filter Purchases', e.toString());
      isLoading.value = false;
    }
  }

  Future<List<Purchases>> getListData(String query) async {
    var data = await db.getData<Purchases>(
      'purchases',
      query,
      Helper.fromJsonPurchases,
    );
    return data;
  }
}