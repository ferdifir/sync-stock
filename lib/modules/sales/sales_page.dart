import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockmobilesync/models/sales.dart';
import 'package:stockmobilesync/modules/sales/sales_controller.dart';
import 'package:stockmobilesync/utils/empty_data_widget.dart';
import 'package:stockmobilesync/utils/helper.dart';

import 'content_sales.dart';

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
                        ctx.sales.clear();
                        ctx.searchQuery.value = value;
                        ctx.offset = 0;
                        ctx.searchSales();
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
                      ctx.sales.clear();
                      ctx.getSalesMaster();
                    }
                    if (ctx.isSearchCustomer.value) {
                      ctx.isSearchCustomer.value = false;
                    }
                  },
                  icon: Icon(
                    ctx.isSearch.value ? Icons.close : Icons.search,
                  ),
                ),
              ),
              Obx(() => IconButton(
                    onPressed: () {
                      ctx.isSearchCustomer.value = !ctx.isSearchCustomer.value;
                      if (!ctx.isSearchCustomer.value) {
                        searchController.clear();
                        ctx.searchQuery.value = '';
                        ctx.sales.clear();
                        ctx.getSalesMaster();
                      }
                      if (ctx.isSearch.value) {
                        ctx.isSearch.value = false;
                      }
                    },
                    icon: Icon(
                      ctx.isSearchCustomer.value
                          ? Icons.clear
                          : Icons.account_circle_outlined,
                    ),
                  )),
              Obx(() {
                bool state =
                    ctx.fromDate.value.isEmpty && ctx.toDate.value.isEmpty;
                return IconButton(
                  onPressed: () {
                    if (state) {
                      showDateFilterSheet(context, ctx);
                    } else {
                      ctx.clearFilter();
                      ctx.getSalesMaster();
                    }
                  },
                  icon: Icon(
                    state ? Icons.date_range : Icons.format_clear,
                  ),
                );
              }),
            ],
          ),
          body: Obx(() => ctx.isLoading.value && ctx.sales.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : buildList(context, ctx)),
        );
      },
    );
  }

  buildList(
    BuildContext context,
    SalesController ctx,
  ) {
    bool state = ctx.fromDate.isNotEmpty && ctx.toDate.isNotEmpty;
    final double width = MediaQuery.of(context).size.width;
    return Obx(
      () {
        return ctx.sales.isEmpty
            ? EmptyData(width: width)
            : Column(
                children: [
                  ctx.isSearchCustomer.value
                      ? Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          child: TextField(
                            controller: searchController,
                            decoration: const InputDecoration(
                              hintText: 'Cari Nama Customer',
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              ctx.sales.clear();
                              ctx.searchCustomerQuery.value = value;
                              ctx.offset = 0;
                              ctx.searchCustomer();
                            },
                          ),
                        )
                      : const SizedBox(),
                  state
                      ? Container(
                          color: Colors.grey[200],
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          child: Row(
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
                                        Helper.convertToDate(
                                            ctx.fromDate.value),
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
                                  ctx.sales.clear();
                                  ctx.offset = 0;
                                  ctx.filterSales();
                                },
                                child: Icon(
                                  Icons.send,
                                  size: width * 0.05,
                                ),
                              )
                            ],
                          ),
                        )
                      : const SizedBox(),
                  Expanded(
                    child: ListView.builder(
                      controller: ctx.scrollController,
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
                              style: TextStyle(
                                fontSize: width * 0.05,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              showDetailSales(ctx.sales[index]);
                            },
                            subtitle: ContentSalesProduct(
                              index: index,
                              width: width,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 12,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  ctx.isLoadMoreData.value
                      ? Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          child:
                              const Center(child: CircularProgressIndicator()),
                        )
                      : const SizedBox(),
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

  void showDateFilterSheet(BuildContext context, SalesController ctx) {
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
                  ctx.offset = 0;
                  ctx.filterSales();
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

  void selectDate(BuildContext context, SalesController ctx, String date) {
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
}
