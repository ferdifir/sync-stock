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
  RxString fromDate = ''.obs;
  RxString toDate = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getSalesMaster();
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
    sales.clear();
    try {
      String query = "SELECT * FROM sales";
      sales.value = await getListData(query);
      isLoading.value = false;
    } catch(e) {
      Log.e('Get List Sales', e.toString());
      isLoading.value = false;
    }
  }

  searchSales(String keyword) async {
    isLoading.value = true;
    sales.clear();
    try {
      String query = "SELECT * FROM sales WHERE nama LIKE '%$keyword%' ORDER BY tgl DESC";
      sales.value = await getListData(query);
      isLoading.value = false;
    } catch(e) {
      Log.e('Search Sales', e.toString());
      isLoading.value = false;
    }
  }

  filterSales(String from, String to) async {
    isLoading.value = true;
    sales.clear();
    try {
      String query = "SELECT * FROM sales WHERE nama LIKE '%${searchQuery.value}%' AND tgl BETWEEN '$from' AND '$to' ORDER BY tgl DESC";
      sales.value = await getListData(query);
      isLoading.value = false;
    } catch(e) {
      Log.e('Filter Sales', e.toString());
      isLoading.value = false;
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