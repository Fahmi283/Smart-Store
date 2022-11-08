import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:smart_store/model/items_model.dart';

import '../provider/items_provider.dart';
import '../screen/entry_data.dart';

class ListItems extends StatefulWidget {
  const ListItems({super.key});

  @override
  State<ListItems> createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> {
  late TextEditingController searchController;
  final currency = NumberFormat("#,##0.00", "id_ID");

  void showNotification(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.blue, content: Text(message.toString())));
  }

  var searchResult = [];
  @override
  void initState() {
    searchController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ItemsProvider>(
      builder: (context, manager, child) {
        List<Items> value = manager.items;
        if (manager.state == ViewState.loading) {
          SmartDialog.showLoading();
        } else if (manager.state == ViewState.error) {
          SmartDialog.dismiss();
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Gagal memuat data'),
                ElevatedButton.icon(
                  onPressed: () {
                    manager.get();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                )
              ],
            ),
          );
        }

        if (value.isNotEmpty || searchResult.isNotEmpty) {
          SmartDialog.dismiss();
          return Column(
            children: [
              Container(
                height: 45,
                margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                child: TextField(
                  onChanged: (valueController) {
                    setState(() {
                      searchResult = value
                          .where((element) => element.name
                              .toLowerCase()
                              .contains(valueController.toLowerCase()))
                          .toList();
                    });
                  },
                  controller: searchController,
                  decoration: const InputDecoration(
                      hintText: "Search Data Inventory",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(25.0)))),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: (searchResult.isEmpty)
                      ? ListView.separated(
                          itemCount: value.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: ExpansionTile(
                                leading: SizedBox(
                                    width: 30,
                                    child: Center(
                                      child: Text('${index + 1}.)'),
                                    )),
                                title: Text(value[index].name),
                                subtitle: Text(
                                    'Price : Rp. ${currency.format(value[index].price)}'),
                                children: [
                                  ListTile(
                                    onTap: () {},
                                    leading:
                                        SizedBox(width: 30, child: Container()),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                              context,
                                              EntryItems.routeName,
                                              arguments: value[index],
                                            );
                                          },
                                          icon: const Icon(Icons.edit),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Ingin Menghapus Data?'),
                                                    content: const Text(
                                                        'Anda hanya bisa Menghapus data yang telah anda tambahkan'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child:
                                                            const Text('Batal'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          final result =
                                                              await manager
                                                                  .delete(value[
                                                                          index]
                                                                      .id!);
                                                          manager.get();
                                                          if (mounted) {}
                                                          Navigator.pop(
                                                              context);
                                                          showNotification(
                                                              context, result);
                                                        },
                                                        child:
                                                            const Text('Hapus'),
                                                      ),
                                                    ],
                                                  );
                                                });
                                          },
                                          icon: const Icon(Icons.delete),
                                        ),
                                      ],
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Stock : ${value[index].stock}'),
                                        Text(
                                            'Barcode : ${value[index].barcode}'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(
                            height: 5,
                          ),
                        )
                      : ListView.separated(
                          itemCount: searchResult.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: ExpansionTile(
                                leading: SizedBox(
                                    width: 30,
                                    child: Center(
                                      child: Text('${index + 1}.)'),
                                    )),
                                title: Text(searchResult[index].name),
                                subtitle: Text(
                                    'Price : Rp. ${currency.format(searchResult[index].price)}'),
                                children: [
                                  ListTile(
                                    onTap: () {},
                                    leading:
                                        SizedBox(width: 30, child: Container()),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                              context,
                                              EntryItems.routeName,
                                              arguments: searchResult[index],
                                            );
                                          },
                                          icon: const Icon(Icons.edit),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Ingin Menghapus Data?'),
                                                    content: const Text(
                                                        'Anda hanya bisa Menghapus data yang telah anda tambahkan'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child:
                                                            const Text('Batal'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          final result =
                                                              await manager.delete(
                                                                  searchResult[
                                                                          index]
                                                                      .id!);
                                                          manager.get();
                                                          if (mounted) {}
                                                          Navigator.pop(
                                                              context);
                                                          showNotification(
                                                              context, result);
                                                        },
                                                        child:
                                                            const Text('Hapus'),
                                                      ),
                                                    ],
                                                  );
                                                });
                                          },
                                          icon: const Icon(Icons.delete),
                                        ),
                                      ],
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Stock : ${searchResult[index].stock}'),
                                        Text(
                                            'Barcode : ${searchResult[index].barcode}'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(
                            height: 5,
                          ),
                        ),
                ),
              ),
            ],
          );
        } else {
          return Center(
            child: TextButton(
              onPressed: () {
                manager.get();
              },
              child: const Text('List is Empty'),
            ),
          );
        }
      },
    );
  }
}
