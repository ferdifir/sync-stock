import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockmobilesync/models/purchases.dart';
import 'package:stockmobilesync/modules/purchases/purchases_controller.dart';
import 'package:stockmobilesync/utils/helper.dart';

class PembelianPage extends StatelessWidget {
  PembelianPage({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
              IconButton(
                onPressed: () {
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
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2010),
                                        lastDate: DateTime(2030),
                                      ).then((value) {
                                        if (value != null) {
                                          String selectedDate = value
                                              .toString()
                                              .substring(0,
                                                  10); // Ambil substring dari indeks 0 hingga 9 untuk mendapatkan format 'yyyy-MM-dd'
                                          ctx.fromDate.value = selectedDate;
                                        }
                                      });
                                    },
                                    child: Text(
                                      ctx.fromDate.value.isEmpty
                                          ? 'Pilih Tanggal'
                                          : Helper.convertToDate(
                                              ctx.fromDate.value),
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
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2010),
                                        lastDate: DateTime(2030),
                                      ).then((value) {
                                        if (value != null) {
                                          String selectedDate = value
                                              .toString()
                                              .substring(0,
                                                  10); // Ambil substring dari indeks 0 hingga 9 untuk mendapatkan format 'yyyy-MM-dd'
                                          ctx.toDate.value = selectedDate;
                                        }
                                      });
                                    },
                                    child: Text(
                                      ctx.toDate.value.isEmpty
                                          ? 'Pilih Tanggal'
                                          : Helper.convertToDate(
                                              ctx.toDate.value),
                                    ),
                                  )),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              ctx.filterPurchases(
                                  ctx.fromDate.value, ctx.toDate.value);
                              Get.back();
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
                },
                icon: const Icon(Icons.date_range),
              ),
            ],
          ),
          body: Obx(
            () => ctx.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : buildList(ctx),
          ),
        );
      },
    );
  }

  buildList(PurchasesController ctx) {
    final bool state =
        ctx.fromDate.value.isNotEmpty && ctx.toDate.value.isNotEmpty;
    return Obx(
      () {
        return ctx.purchases.isEmpty
            ? const Center(
                child: Text('Data Kosong'),
              )
            : Column(
                children: [
                  state
                      ? Container(
                          color: Colors.grey[200],
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(Helper.convertToDate(ctx.fromDate.value)),
                              const Icon(Icons.arrow_forward),
                              Text(Helper.convertToDate(ctx.toDate.value)),
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
                          child: ListTile(
                            onTap: () {
                              showDetailPurchasesProduct(ctx.purchases[index]);
                            },
                            tileColor: Colors.grey[200],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            title: Text(
                                '${ctx.purchases[index].idTrans} - ${ctx.purchases[index].nama}'),
                            subtitle: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text('Tanggal: '),
                                        Text(ctx.purchases[index].tgl),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text('Qty: '),
                                        Text(ctx.purchases[index].qty
                                            .toInt()
                                            .toString()),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text('Harga Beli: '),
                                        Text(Helper.rupiah(ctx
                                            .purchases[index].hbeli
                                            .toInt())),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text('Harga Jual: '),
                                        Text(Helper.rupiah(
                                            ctx.purchases[index].hjualcr)),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                            trailing: SizedBox(
                              width: 90,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Supplier: '),
                                  Text(ctx.purchases[index].nmSupplier),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
      },
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
}
