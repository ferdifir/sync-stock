import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockmobilesync/modules/sales/sales_controller.dart';

class ContentSalesProduct extends StatelessWidget {
  const ContentSalesProduct({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SalesController>(
      init: SalesController(),
      initState: (_) {},
      builder: (ctx) {
        var sal = ctx.sales[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Row(
              children: [
                Text(sal.nota,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const Text('  -  '),
                Text(sal.nmCustomer),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Satuan'),
                          Text('Qty'),
                          Text('Harga Jual'),
                          Text('Harga Ecer'),
                        ],
                      ),
                      const SizedBox(width: 4),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(': ${sal.sat}'),
                          Text(': ${sal.qty.toInt()}'),
                          Text(': ${sal.hjual.toInt()}'),
                          Text(': ${sal.ecer.toInt()}'),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Pack'),
                          Text('Tanggal'),
                          Text('Harga Beli'),
                          Text('Kode Penjualan'),
                        ],
                      ),
                      const SizedBox(width: 4),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(': ${sal.pak}'),
                          Text(': ${sal.tgl}'),
                          Text(': ${sal.hbeli!}'),
                          Text(
                              ': ${sal.kdsales.isEmpty ? 'Tidak ada' : sal.kdsales}'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
