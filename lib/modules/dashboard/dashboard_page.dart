import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockmobilesync/modules/dashboard/dashboard_controller.dart';
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
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.MASTER,
                  ),
                ),
                buildItemDashboard(
                  image: 'assets/2.png',
                  title: 'Data Pembelian',
                  onTap: () {
                    if (ctx.isPurchasesAvailable.value) {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.PURCHASES,
                      );
                    } else {
                      Get.dialog(
                        AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: const Text('Perhatian'),
                          content: const Text(
                            'Data pembelian belum tersedia, silahkan sinkronisasi data terlebih dahulu',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Tutup'),
                            ),
                          ],
                        ),
                      );
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
                  onTap: () {
                    if (ctx.isSalesAvailable.value) {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.SALES,
                      );
                    } else {
                      Get.dialog(
                        AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: const Text('Perhatian'),
                          content: const Text(
                            'Data penjualan belum tersedia, silahkan sinkronisasi data terlebih dahulu',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Tutup'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
                buildItemDashboard(
                  image: 'assets/3.png',
                  title: 'Sinkronisasi Data',
                  onTap: () {
                    showSynchronizationAlert(() {
                      if (ctx.firstSynch.value) {
                        ctx.firstSync((status, progress) {
                          showProgressDialog(status, progress);
                        }).then((value) {
                          if (value) {
                            Get.offAllNamed(AppRoutes.DASHBOARD);
                          }
                        });
                      } else {
                        ctx.syncData((status, progress) {
                          showProgressDialog(status, progress);
                        }).then((value) {
                          if (value) {
                            Get.offAllNamed(AppRoutes.DASHBOARD);
                          }
                        });
                      }
                    });
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
                              Navigator.pop(context);
                            },
                            child: const Text('Tidak'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pushReplacementNamed(
                                context,
                                AppRoutes.LOGIN,
                              );
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

  void showProgressDialog(String status, double progress) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Sinkronisasi Data'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(status),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: progress,
            ),
            const SizedBox(height: 4),
            Text(
              '${(progress * 100).toStringAsFixed(0)}%',
            ),
          ],
        ),
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
