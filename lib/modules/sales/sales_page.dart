import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockmobilesync/models/sales.dart';
import 'package:stockmobilesync/modules/sales/sales_controller.dart';
import 'package:stockmobilesync/utils/helper.dart';

class PenjualanPage extends StatelessWidget {
  PenjualanPage({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SalesController>(
      init: SalesController(),
      initState: (_) {},
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
                        ctx.searchSales(value);
                        ctx.searchQuery.value = value;
                      },
                    )
                  : const Text('Data Penjualan'),
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
                      ctx.getSalesMaster();
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
                              ctx.filterSales(
                                ctx.fromDate.value,
                                ctx.toDate.value,
                              );
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
          body: Obx(() => ctx.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : buildList(ctx)),
        );
      },
    );
  }

  buildList(SalesController ctx) {
    bool state = ctx.fromDate.isNotEmpty && ctx.toDate.isNotEmpty;
    return Obx(
      () {
        return ctx.sales.isEmpty
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
                          ),
                        )
                      : const SizedBox(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: ctx.sales.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(
                            left: 8,
                            right: 8,
                            top: 10,
                          ),
                          child: ListTile(
                            tileColor: Colors.grey[200],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            title: Text(
                              '${ctx.sales[index].nama}',
                              style: const TextStyle(fontSize: 20),
                            ),
                            onTap: () {
                              showDetailSales(ctx.sales[index]);
                            },
                            subtitle: ContentSalesProduct(
                              index: index,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
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

  void showDetailSales(Sales sal) {
    bool state = sal.nmCustomer.length > 18;
    Get.dialog(
      WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text('Detail Penjualan ${sal.nama}'),
          content: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Nama Customer'),
                  state ? const Text(' ') : const SizedBox(),
                  const Text('Satuan'),
                  const Text('Qty'),
                  const Text('Harga Jual'),
                  const Text('Harga Ecer'),
                  const Text('Pack'),
                  const Text('Nota'),
                  const Text('Tanggal'),
                  const Text('Harga Beli'),
                  const Text('Kode Penjualan'),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(' :  '),
                  state ? const Text(' ') : const SizedBox(),
                  const Text(' :  '),
                  const Text(' :  '),
                  const Text(' :  '),
                  const Text(' :  '),
                  const Text(' :  '),
                  const Text(' :  '),
                  const Text(' :  '),
                  const Text(' :  '),
                  const Text(' :  '),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(sal.nmCustomer),
                    Text('${sal.sat}'),
                    Text('${sal.qty.toInt()}'),
                    Text('${sal.hjual.toInt()}'),
                    Text('${sal.ecer.toInt()}'),
                    Text('${sal.pak}'),
                    Text(sal.nota),
                    Text(sal.tgl),
                    Text(sal.hbeli!),
                    Text(sal.kdsales.isEmpty ? 'Tidak ada' : sal.kdsales),
                  ],
                ),
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
        ),
      ),
    );
  }
}

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
        Sales sal = ctx.sales[index];
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
