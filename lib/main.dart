import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockmobilesync/modules/splash/splash_binding.dart';
import 'package:stockmobilesync/modules/splash/splash_screen.dart';
import 'package:stockmobilesync/routes/app_pages.dart';

void main() {
  runApp(const StockSync());
}

class StockSync extends StatelessWidget {
  const StockSync({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stock Mobile Sync',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
      initialBinding: SplashBinding(),
      getPages: AppPages.routes,
    );
  }
}
