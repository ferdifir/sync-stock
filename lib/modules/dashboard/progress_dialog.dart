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
          content: Obx(() => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(ctx.statusSync.value),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: ctx.progressSync.value,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${(ctx.progressSync.value * 100).toStringAsFixed(0)}%',
                  ),
                ],
              )),
        );
      },
    );
  }
}