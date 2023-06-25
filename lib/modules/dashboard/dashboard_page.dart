import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockmobilesync/modules/dashboard/dashboard_controller.dart';
import 'package:stockmobilesync/modules/dashboard/progress_dialog.dart';
import 'package:stockmobilesync/routes/app_routes.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return GetBuilder<DashboardController>(
        init: DashboardController(),
        initState: (_) {},
        builder: (ctx) {
          return SafeArea(
            child: Scaffold(
              body: Container(
                color: Colors.grey[300],
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  children: [
                    Positioned(
                      top: 10,
                      left: 10,
                      right: 10,
                      child: Row(
                        children: <Widget>[
                          const CircleAvatar(
                            radius: 24,
                            backgroundImage: AssetImage('assets/user.png'),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() => Text(
                                    ctx.name.isEmpty
                                        ? 'Loading...'
                                        : ctx.name.value,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                              Obx(() => Text(
                                    ctx.email.isEmpty
                                        ? 'Loading...'
                                        : ctx.email.value,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                            ],
                          ),
                          const Spacer(),
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Obx(() => Text(
                                  ctx.level.isEmpty
                                      ? 'Loading...'
                                      : ctx.level.value,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                          )
                        ],
                      ),
                    ),
                    contentDashboard(height, context, ctx),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Positioned contentDashboard(
    double height,
    BuildContext context,
    DashboardController ctx,
  ) {
    return Positioned(
      top: 70,
      left: 0,
      right: 0,
      child: Container(
        height: height - 70,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 150,
              height: 6,
              margin: const EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildItemDashboard(
                  image: 'assets/1.png',
                  title: 'Master Produk',
                  onTap: () async {
                    var isAvail = await ctx.checkDataMaster();
                    if (isAvail) {
                      Get.toNamed(AppRoutes.MASTER);
                    } else {
                      showLoadingDialog('Produk');
                      ctx.loadDataMaster().then((value) {
                        Get.back();
                        if (value) {
                          Get.toNamed(AppRoutes.MASTER);
                        }
                      });
                    }
                  },
                ),
                buildItemDashboard(
                  image: 'assets/2.png',
                  title: 'Data Pembelian',
                  onTap: () async {
                    bool isAvail = await ctx.checkDataPurchases();
                    if (isAvail) {
                      Get.toNamed(AppRoutes.PURCHASES);
                    } else {
                      showLoadingDialog('Pembelian');
                      ctx.loadDataPurchases().then((value) {
                        Get.back();
                        if (value) {
                          Get.toNamed(AppRoutes.PURCHASES);
                        }
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildItemDashboard(
                  image: 'assets/4.png',
                  title: 'Data Penjualan',
                  onTap: () async {
                    bool isAvail = await ctx.checkDataSales();
                    if (isAvail) {
                      Get.toNamed(AppRoutes.SALES);
                    } else {
                      showLoadingDialog('Penjualan');
                      ctx.loadDataSales().then((value) {
                        Get.back();
                        if (value) {
                          Get.toNamed(AppRoutes.SALES);
                        }
                      });
                    }
                  },
                ),
                buildItemDashboard(
                  image: 'assets/3.png',
                  title: 'Sinkronisasi Data',
                  onTap: () {
                    showLoadingDialog('Keseluruhan');
                    ctx.syncData().then((value) => Get.back());
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            buildItemDashboard(
              image: 'assets/5.png',
              title: 'Keluar',
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return WillPopScope(
                      onWillPop: () async => false,
                      child: AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        title: const Text('Konfirmasi'),
                        content: const Text(
                          'Apakah anda yakin ingin keluar?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text('Tidak'),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.offAllNamed(AppRoutes.LOGIN);
                            },
                            child: const Text('Ya'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void showLoadingDialog(String dataType) {
    Get.dialog(WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text('Memuat $dataType untuk pertama kali'),
            ],
          ),
        ),
      ),
    ));
  }

  void showProgressDialog() {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: const ProgressDialog(),
      ),
    );
  }

  void showSynchronizationAlert(
    Function() onConfirm,
  ) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: const [
            Icon(
              Icons.warning,
              color: Colors.red,
            ),
            SizedBox(width: 10),
            Text('Perhatian!'),
          ],
        ),
        content: const Text(
          'Sinkronisasi data akan memakan waktu beberapa menit, pastikan koneksi internet anda stabil',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Tutup'),
          ),
          TextButton(
            onPressed: () {
              onConfirm();
              Get.back();
            },
            child: const Text('Sinkronisasi'),
          ),
        ],
      ),
    );
  }

  InkWell buildItemDashboard({
    required String image,
    required String title,
    Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(
            image,
            width: 100,
            height: 100,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
