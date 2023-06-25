import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockmobilesync/modules/dashboard/dashboard_controller.dart';

class ProgressDialog extends StatelessWidget {
  const ProgressDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      init: DashboardController(),
      initState: (_) {},
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Sinkronisasi Data'),
          titlePadding: const EdgeInsets.only(
            top: 16,
            left: 20,
            bottom: 10,
          ),
          contentPadding: const EdgeInsets.only(
            bottom: 16,
            left: 20,
            right: 20,
            top: 10,
          ),
          content: Obx(
            () {
              return SizedBox(
                width: Get.width,
                child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: Get.width,
                          child: Text(
                            ctx.statusSync.value,
                            textAlign: TextAlign.start,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(height: 10),
                        LinearProgressIndicator(
                          value: ctx.progressSync.value,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${(ctx.progressSync.value * 100).toStringAsFixed(0)}%',
                        ),
                      ],
                    ),
              );
            }
          ),
        );
      },
    );
  }
}