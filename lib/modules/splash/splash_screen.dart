import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockmobilesync/modules/splash/splash_controller.dart';
import 'package:stockmobilesync/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final ctx = Get.find<SplashController>();
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      print(ctx.isFirstTime);
      if (ctx.isFirstTime.value) {
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
        ctx.loadDataUser().then((value) {
          if (value) {
            ctx.setPref();
            Get.offAllNamed(AppRoutes.LOGIN);
          } else {
            Get.dialog(
              WillPopScope(
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: const Text('Gagal memuat data'),
                  content: const Text(
                    'Mohon nyalakan koneksi internet dan coba lagi',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        ctx.loadDataUser();
                        Get.back();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
                onWillPop: () async => false,
              ),
            );
          }
        });
      } else {
        if (ctx.isRemember.value) {
          Get.offAllNamed(AppRoutes.DASHBOARD);
        } else {
          Get.offAllNamed(AppRoutes.LOGIN);
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      init: SplashController(),
      initState: (_) {},
      builder: (ctx) {
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage('assets/splash.png'),
              ),
            ),
          ),
        );
      },
    );
  }
}
