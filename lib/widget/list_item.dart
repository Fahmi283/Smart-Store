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
        }
        if (manager.state == ViewState.error) {
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
        if (value.isNotEmpty) {
          SmartDialog.dismiss();
          return Column(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListView.separated(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        child: ListTile(
                          onTap: () {
                            manager.get();
                          },
                          onLongPress: () async {
                            final result =
                                await manager.delete(value[index].id!);
                            manager.get();

                            // ignore: use_build_context_synchronously
                            showNotification(context, result);
                          },
                          leading: SizedBox(
                              width: 30,
                              child: Center(
                                child: Text('${index + 1}.)'),
                              )),
                          title: Text(value[index].name),
                          trailing: IconButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  EntryItems.routeName,
                                  arguments: value[index],
                                );
                              },
                              icon: const Icon(Icons.edit)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Price : Rp. ${currency.format(value[index].price)}'),
                              // Text('Stock : ${value[index].stock.toString()}'),
                            ],
                          ),
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
