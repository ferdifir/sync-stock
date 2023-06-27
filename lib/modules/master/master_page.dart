import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockmobilesync/modules/master/master_controller.dart';
import 'package:stockmobilesync/utils/helper.dart';

class MasterPage extends StatelessWidget {
  MasterPage({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MasterController>(
      init: MasterController(),
      initState: (_) {},
      builder: (ctx) {
        return Scaffold(
          appBar: AppBar(
            title: Obx(
              () {
                return ctx.isSearch.value
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
                          ctx.searchMaster(value);
                          ctx.showListAktif();
                        },
                      )
                    : const Text('Data Master');
              },
            ),
            elevation: 0,
            actions: [
              Obx(
                () => IconButton(
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
                ),
              ),
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
                    Obx(() => Checkbox(
                          value: ctx.isAktif.value,
                          onChanged: (value) {
                            ctx.toggleAktif(value!);
                            ctx.getListMaster();
                          },
                        )),
                    const Text('Aktif'),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: Colors.grey[200],
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

  buildList(MasterController ctx) {
    return Obx(() {
      return ctx.masters.isEmpty
          ? const Center(
              child: Text('Data Kosong'),
            )
          : ListView.builder(
              itemCount: ctx.masters.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(
                    top: 10,
                    left: 10,
                    right: 10,
                  ),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    tileColor: ctx.masters[index].aktif == 1
                        ? Colors.blueAccent[100]
                        : Colors.redAccent[100],
                    textColor: Colors.white,
                    onTap: () {
                      if (ctx.level.value == 'admin') {
                        showDetailProduct(ctx, index);
                      } else {
                        null;
                      }
                    },
                    title: Text(
                        '${ctx.masters[index].kdBrg} - ${ctx.masters[index].nama}'),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text('Modal: '),
                                Text(Helper.rupiah(ctx.masters[index].hjual)),
                              ],
                            ),
                            Row(
                              children: [
                                const Text('Harga Sales: '),
                                Text(Helper.rupiah(ctx.masters[index].hjualcr)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text('Satuan: '),
                                Text(ctx.masters[index].sat!),
                              ],
                            ),
                            Row(
                              children: [
                                const Text('Pack: '),
                                Text(ctx.masters[index].pak!),
                              ],
                            ),
                            Row(
                              children: [
                                const Text('Stock: '),
                                Text(ctx.masters[index].akhirG!),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: ctx.level.value == 'admin'
                        ? SizedBox(
                            width: 80,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Supplier:'),
                                Text(ctx.masters[index].nmSupplier ?? '-'),
                              ],
                            ),
                          )
                        : IconButton(
                            onPressed: () {
                              showDetailProduct(ctx, index);
                            },
                            icon: const Icon(Icons.info),
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
