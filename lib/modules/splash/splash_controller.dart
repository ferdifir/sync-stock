import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:stockmobilesync/routes/app_routes.dart';
import 'package:stockmobilesync/utils/config.dart';
import 'package:stockmobilesync/services/data_synchronization.dart';
import 'package:stockmobilesync/utils/log.dart';

class SplashController extends GetxController {
  SharedPreferences? pref;
  final syncData = DataSynchronization();

  @override
  void onInit() {
    super.onInit();
    _loadPref();
    Future.delayed(const Duration(seconds: 3), () {
      if (pref!.getBool(firstTime) ?? true) {
        Get.dialog(
          WillPopScope(
            onWillPop: () async => false,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  SizedBox(height: 20),
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text(
                    'Sedang memuat data...\nMohon nyalakan koneksi internet',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          barrierDismissible: false,
        );
        fetchData();
        pref!.setBool(firstTime, false);
      } else {
        if (isRememberMe()) {
          Get.offAllNamed(AppRoutes.DASHBOARD);
        } else {
          Get.offAllNamed(AppRoutes.LOGIN);
        }
      }
    });
  }

  void fetchData() async {
    try {
      bool user = await syncData.fetchUserData();
      Log.d('Fetch Data', 'User: $user');
      bool master = await syncData.fetchMasterData();
      Log.d('Fetch Data', 'Master: $master');

      var databasesPath = await getDatabasesPath();
      String purchasesPath = join(databasesPath, dbPurchases);
      String salesPath = join(databasesPath, dbSales);

      await openDatabase(
        purchasesPath,
        version: 1,
        onCreate: (db, version) {
          db.execute('CREATE TABLE purchases('
              'idtranst INTEGER PRIMARY KEY, '
              'nama TEXT, '
              'tgl DATE, '
              'qty TEXT, '
              'hbeli TEXT, '
              'hjualcr INTEGER, '
              'nmsupplier TEXT)');
        },
      );

      await openDatabase(
        salesPath,
        version: 1,
        onCreate: (db, version) {
          db.execute('CREATE TABLE sales('
              'idsales INTEGER PRIMARY KEY AUTOINCREMENT, '
              'nmcustomer TEXT, '
              'nama TEXT, '
              'sat TEXT, '
              'qty TEXT, '
              'hjual TEXT, '
              'ecer INTEGER, '
              'pak TEXT, '
              'nota TEXT, '
              'tgl DATE, '
              'hbeli TEXT, '
              'kdsales TEXT)');
        },
      );
      
      if (user && master) {
        pref!.setBool(firstTimeSync, true);
        Get.offAllNamed(AppRoutes.LOGIN);
      } else {
        Get.dialog(
          AlertDialog(
            title: const Text('Gagal memuat data'),
            content: const Text('Silahkan coba lagi'),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                  fetchData();
                },
                child: const Text('Coba lagi'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      printError(info: e.toString());
    }
  }

  Future<void> _loadPref() async {
    pref = await SharedPreferences.getInstance();
  }

  Future<bool> isTheFirstTime() async {
    return pref!.getBool(firstTime) ?? true;
  }

  bool isRememberMe() {
    return pref!.getBool(rememberMePrefKey) ?? false;
  }

}
