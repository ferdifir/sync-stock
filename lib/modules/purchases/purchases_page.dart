import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockmobilesync/models/purchases.dart';
import 'package:stockmobilesync/modules/purchases/purchases_controller.dart';
import 'package:stockmobilesync/utils/empty_data_widget.dart';
import 'package:stockmobilesync/utils/helper.dart';

class PembelianPage extends StatelessWidget {
  PembelianPage({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return GetBuilder<PurchasesController>(
      initState: (_) {},
      init: PurchasesController(),
      builder: (ctx) {
        return Scaffold(
          appBar: AppBar(
            title: Obx(
              () => ctx.isSearch.value
                  ? TextField(
                      controller: searchController,
                      autofocus: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Cari Produk',
                        hintStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        ctx.searchPurchases(value);
                        ctx.searchQuery.value = value;
                      },
                    )
                  : const Text('Data Pembelian'),
            ),
            elevation: 0,
            actions: [
              Obx(
                () => IconButton(
                  onPressed: () {
                    ctx.toggleSearch();
                    if (!ctx.isSearch.value) {
                      searchController.clear();
                      ctx.searchQuery.value = '';
                      ctx.getPurchasesMaster();
                    }
                  },
                  icon: Icon(
                    ctx.isSearch.value ? Icons.close : Icons.search,
                  ),
                ),
              ),
              Obx(() {
                return IconButton(
                  onPressed: () {
                    if (ctx.fromDate.value.isEmpty &&
                        ctx.toDate.value.isEmpty) {
                      showDateFilterSheet(context, ctx);
                    } else {
                      ctx.clearFilter();
                      ctx.getPurchasesMaster();
                    }
                  },
                  icon: ctx.fromDate.value.isEmpty && ctx.toDate.value.isEmpty
                      ? const Icon(Icons.date_range)
                      : const Icon(Icons.format_clear),
                );
              }),
            ],
          ),
          body: Obx(() => ctx.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : buildList(ctx, context, width)),
        );
      },
    );
  }

  buildList(
    PurchasesController ctx,
    BuildContext context,
    double width,
  ) {
    final bool state =
        ctx.fromDate.value.isNotEmpty && ctx.toDate.value.isNotEmpty;
    return Obx(() {
      return ctx.purchases.isEmpty
          ? EmptyData(width: width)
          : Column(
              children: [
                state
                    ? Container(
                        color: Colors.grey[200],
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      selectDate(
                                        context,
                                        ctx,
                                        'from',
                                      );
                                    },
                                    child: Text(
                                      Helper.convertToDate(ctx.fromDate.value),
                                      style: TextStyle(
                                        fontSize: width * 0.035,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    size: width * 0.05,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      selectDate(
                                        context,
                                        ctx,
                                        'to',
                                      );
                                    },
                                    child: Text(
                                      Helper.convertToDate(ctx.toDate.value),
                                      style: TextStyle(
                                        fontSize: width * 0.035,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                ctx.filterPurchases(
                                    ctx.fromDate.value, ctx.toDate.value);
                              },
                              child: Icon(
                                Icons.send,
                                size: width * 0.05,
                              ),
                            )
                          ],
                        ))
                    : Container(),
                Expanded(
                  child: ListView.builder(
                    itemCount: ctx.purchases.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(
                          left: 8,
                          right: 8,
                          top: 10,
                        ),
                        child: purchaseListItem(ctx, index, width),
                      );
                    },
                  ),
                ),
              ],
            );
    });
  }

  ListTile purchaseListItem(PurchasesController ctx, int index, double width) {
    final textSize = width * 0.04;
    return ListTile(
      onTap: () {
        showDetailPurchasesProduct(ctx.purchases[index]);
      },
      contentPadding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 16,
      ),
      tileColor: Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ctx.purchases[index].nama!,
            style: TextStyle(
              fontSize: width * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Suplier: ${ctx.purchases[index].nmSupplier}',
            style: TextStyle(
              fontSize: textSize,
            ),
          ),
          SizedBox(height: width * 0.02),
        ],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Harga Beli',
                      style: TextStyle(
                        fontSize: textSize,
                      ),
                    ),
                    Text(
                      'Harga Jual',
                      style: TextStyle(
                        fontSize: textSize,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ': ${Helper.rupiah(ctx.purchases[index].hbeli.toInt())}',
                      style: TextStyle(
                        fontSize: textSize,
                      ),
                    ),
                    Text(
                      ': ${Helper.rupiah(ctx.purchases[index].hjualcr)}',
                      style: TextStyle(
                        fontSize: textSize,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tanggal',
                      style: TextStyle(
                        fontSize: textSize,
                      ),
                    ),
                    Text(
                      'Qty',
                      style: TextStyle(
                        fontSize: textSize,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ': ${ctx.purchases[index].tgl}',
                      style: TextStyle(
                        fontSize: textSize,
                      ),
                    ),
                    Text(
                      ': ${ctx.purchases[index].qty.toInt()}',
                      style: TextStyle(
                        fontSize: textSize,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
      // trailing: SizedBox(
      //   width: 90,
      //   child: Column(
      //     mainAxisSize: MainAxisSize.min,
      //     mainAxisAlignment: MainAxisAlignment.start,
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       const Text('Supplier: '),
      //       Text(ctx.purchases[index].nmSupplier),
      //     ],
      //   ),
      // ),
    );
  }

  void showDetailPurchasesProduct(Purchases purchas) {
    Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(purchas.nama ?? 'Produk Tidak memiliki nama'),
      content: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text('ID Transaksi'),
              Text('Tanggal'),
              Text('Qty'),
              Text('Harga Beli'),
              Text('Harga Jual'),
              Text('Supplier'),
            ],
          ),
          const SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(': ${purchas.idTrans.toString()}'),
              Text(': ${purchas.tgl}'),
              Text(': ${purchas.qty.toInt().toString()}'),
              Text(': ${Helper.rupiah(purchas.hbeli.toInt())}'),
              Text(': ${Helper.rupiah(purchas.hjualcr)}'),
              Text(': ${purchas.nmSupplier}'),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text('Tutup'),
        ),
      ],
    ));
  }

  void selectDate(BuildContext context, PurchasesController ctx, String date) {
    DateTime? fromDate =
        ctx.fromDate.value.isEmpty ? null : DateTime.parse(ctx.fromDate.value);
    DateTime? toDate =
        ctx.toDate.value.isEmpty ? null : DateTime.parse(ctx.toDate.value);
    showDatePicker(
      context: context,
      initialDate: ctx.fromDate.value.isEmpty
          ? DateTime.now()
          : DateTime.parse(ctx.fromDate.value),
      firstDate: ctx.toDate.value.isEmpty || date == 'from'
          ? DateTime(2010)
          : DateTime(fromDate!.year, fromDate.month, fromDate.day),
      lastDate: ctx.fromDate.value.isEmpty || date == 'to'
          ? DateTime(2030)
          : DateTime(toDate!.year, toDate.month, toDate.day),
    ).then((value) {
      if (value != null) {
        String selectedDate = value.toString().substring(0,
            10); // Ambil substring dari indeks 0 hingga 9 untuk mendapatkan format 'yyyy-MM-dd'
        if (date == 'to') {
          ctx.toDate.value = selectedDate;
        } else {
          ctx.fromDate.value = selectedDate;
        }
      }
    });
  }

  void showDateFilterSheet(
    BuildContext context,
    PurchasesController ctx,
  ) {
    Get.bottomSheet(
      Container(
        height: 250,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            const Text(
              'Filter Tanggal',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Dari Tanggal'),
                Obx(() => TextButton(
                      onPressed: () {
                        selectDate(
                          context,
                          ctx,
                          'from',
                        );
                      },
                      child: Text(
                        ctx.fromDate.value.isEmpty
                            ? 'Pilih Tanggal'
                            : Helper.convertToDate(ctx.fromDate.value),
                      ),
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Sampai Tanggal'),
                Obx(() => TextButton(
                      onPressed: () {
                        selectDate(
                          context,
                          ctx,
                          'to',
                        );
                      },
                      child: Text(
                        ctx.toDate.value.isEmpty
                            ? 'Pilih Tanggal'
                            : Helper.convertToDate(ctx.toDate.value),
                      ),
                    )),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (ctx.toDate.value.isNotEmpty &&
                    ctx.fromDate.value.isNotEmpty) {
                  ctx.filterPurchases(ctx.fromDate.value, ctx.toDate.value);
                  Get.back();
                } else {
                  Get.dialog(WillPopScope(
                    onWillPop: () async => false,
                    child: AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: const Text('Perhatian!'),
                      content: const Text(
                          'Silahkan isi Tanggal mulai dan Tanggal akhir untuk mendapatkan filter produk'),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text('OK'),
                        )
                      ],
                    ),
                  ));
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                minimumSize: const Size(200, 40),
              ),
              child: const Text('Filter'),
            ),
          ],
        ),
      ),
    );
  }
}
