import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockmobilesync/modules/sales/sales_controller.dart';
import 'package:stockmobilesync/utils/helper.dart';

class ContentSalesProduct extends StatelessWidget {
  const ContentSalesProduct({
    Key? key,
    required this.index,
    required this.width,
  }) : super(key: key);

  final int index;
  final double width;

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
                buildText(sal.nota, bold: true),
                buildText('  -  '),
                buildText(sal.nmCustomer),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildText('Satuan'),
                          buildText('Qty'),
                          buildText('Harga Jual'),
                          buildText('Harga Ecer'),
                        ],
                      ),
                      const SizedBox(width: 4),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildText(': ${sal.sat}'),
                          buildText(': ${sal.qty.toInt()}'),
                          buildText(': ${Helper.rupiah(sal.hjual.toInt())}'),
                          buildText(': ${sal.ecer.toInt()}'),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildText('Pack'),
                          buildText('Tanggal'),
                          buildText('Harga Beli'),
                          buildText('Kode Penjualan'),
                        ],
                      ),
                      const SizedBox(width: 4),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildText(': ${sal.pak}'),
                          buildText(': ${sal.tgl}'),
                          buildText(': ${sal.hbeli!}'),
                          buildText(
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

  Text buildText(String text, {bool bold = false}) {
    final textSize = width * 0.04;
    return Text(
      text,
      style: TextStyle(
        fontSize: textSize,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
