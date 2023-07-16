import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockmobilesync/modules/master/master_controller.dart';
import 'package:stockmobilesync/utils/empty_data_widget.dart';
import 'package:stockmobilesync/utils/helper.dart';

class MasterPage extends StatelessWidget {
  MasterPage({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double textSize = width * 0.03;
    return GetBuilder<MasterController>(
      init: MasterController(),
      initState: (_) {},
      builder: (ctx) {
        return Scaffold(
          appBar: AppBar(
            title: Obx(() {
              if (ctx.isSearch.value) {
                return TextField(
                  controller: searchController,
                  autofocus: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Cari Produk',
                    hintStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    ctx.searchMaster(value);
                    ctx.showListAktif();
                  },
                );
              } else {
                return const Text('Data Master');
              }
            }),
            elevation: 0,
            actions: [
              Obx(() => IconButton(
                    onPressed: () {
                      ctx.toggleSearch();
                      if (!ctx.isSearch.value) {
                        searchController.clear();
                        ctx.getListMaster();
                      }
                    },
                    icon: Icon(
                      ctx.isSearch.value ? Icons.close : Icons.search,
                    ),
                  )),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey,
                ),
                padding: const EdgeInsets.only(right: 10),
                margin: const EdgeInsets.all(10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(() {
                      return Checkbox(
                        value: ctx.isAktif.value,
                        onChanged: (value) {
                          ctx.toggleAktif(value!);
                          ctx.getListMaster();
                        },
                      );
                    }),
                    const Text('Aktif'),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: Colors.grey[200],
          body: Obx(() {
            if (ctx.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return buildList(ctx, width);
            }
          }),
        );
      },
    );
  }

  buildList(
    MasterController ctx,
    double width,
  ) {
    final textSize = width * 0.04;
    final bool isAdmin = ctx.level.value == 'admin';
    return Obx(() {
      return ctx.masters.isEmpty
          ? EmptyData(width: width)
          : ListView.builder(
              itemCount: ctx.masters.length,
              itemBuilder: (context, index) {
                String supplier = ctx.masters[index].nmSupplier ?? '-';
                final additionalWidget = supplier.length > 14 && isAdmin
                    ? Text(
                        '',
                        style: TextStyle(fontSize: textSize),
                      )
                    : const SizedBox();
                return Container(
                  margin: const EdgeInsets.only(
                    top: 10,
                    left: 8,
                    right: 8,
                  ),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    tileColor: ctx.masters[index].aktif == 1
                        ? Colors.blueAccent[100]
                        : Colors.redAccent[100],
                    contentPadding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 10,
                      bottom: 6,
                    ),
                    textColor: Colors.white,
                    onTap: () {
                      showDetailProduct(ctx, index);
                    },
                    title: Text(
                      ctx.masters[index].nama!,
                      style: TextStyle(
                        fontSize: width * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Modal',
                                    style: TextStyle(fontSize: textSize),
                                  ),
                                  Text(
                                    'Harga Sales',
                                    style: TextStyle(fontSize: textSize),
                                  ),
                                  isAdmin
                                      ? Text(
                                          'Supplier',
                                          style: TextStyle(
                                            fontSize: textSize,
                                          ),
                                        )
                                      : const SizedBox(),
                                  additionalWidget,
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    ': ',
                                    style: TextStyle(fontSize: textSize),
                                  ),
                                  Text(
                                    ': ',
                                    style: TextStyle(fontSize: textSize),
                                  ),
                                  isAdmin
                                      ? Text(
                                          ': ',
                                          style: TextStyle(fontSize: textSize),
                                        )
                                      : const SizedBox(),
                                  additionalWidget,
                                ],
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      ctx.masters[index].hjual.toString(),
                                      style: TextStyle(fontSize: textSize),
                                    ),
                                    Text(
                                      ctx.masters[index].hjualcr.toString(),
                                      style: TextStyle(fontSize: textSize),
                                    ),
                                    isAdmin
                                        ? Text(
                                            supplier,
                                            style: TextStyle(
                                              fontSize: textSize,
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
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
                                    'Satuan',
                                    style: TextStyle(fontSize: textSize),
                                  ),
                                  Text(
                                    'Pack',
                                    style: TextStyle(fontSize: textSize),
                                  ),
                                  Text(
                                    'Stock',
                                    style: TextStyle(fontSize: textSize),
                                  ),
                                  additionalWidget,
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ': ${ctx.masters[index].sat!}',
                                    style: TextStyle(fontSize: textSize),
                                  ),
                                  Text(
                                    ': ${ctx.masters[index].pak!}',
                                    style: TextStyle(fontSize: textSize),
                                  ),
                                  Text(
                                    ': ${double.parse(ctx.masters[index].akhirG!).toInt()}',
                                    style: TextStyle(fontSize: textSize),
                                  ),
                                  additionalWidget,
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
    });
  }

  void showDetailProduct(MasterController ctx, int index) {
    String ket = ctx.masters[index].aktif == 1 ? 'Aktif' : 'Tidak Aktif';
    bool pak =
        ctx.masters[index].pak == null && ctx.masters[index].pak!.isEmpty;
    String pack = pak ? '-' : ctx.masters[index].pak!;
    bool state = ctx.level.value == 'admin';
    Get.dialog(
      WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(ctx.masters[index].nama!),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Kode Barang'),
                  const Text('Modal'),
                  const Text('Harga Sales'),
                  const Text('Satuan'),
                  const Text('Pack'),
                  const Text('Stock'),
                  state ? const Text('Supplier') : const SizedBox(),
                  const Text('Keterangan'),
                ],
              ),
              const SizedBox(
                width: 4,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(': ${ctx.masters[index].kdBrg}'),
                  Text(': ${Helper.rupiah(ctx.masters[index].hjual)}'),
                  Text(': ${Helper.rupiah(ctx.masters[index].hjualcr)}'),
                  Text(': ${ctx.masters[index].sat}'),
                  Text(': $pack'),
                  Text(': ${ctx.masters[index].akhirG}'),
                  state
                      ? Text(': ${ctx.masters[index].nmSupplier ?? '-'}')
                      : const SizedBox(),
                  Text(': $ket'),
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
        ),
      ),
    );
  }
}
