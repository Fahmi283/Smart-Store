import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:smart_store/model/sales_model.dart';
import 'package:smart_store/provider/selling_provider.dart';

import '../provider/items_provider.dart';
import '../screen/edit_sale.dart';

class ListSale extends StatefulWidget {
  const ListSale({super.key});

  @override
  State<ListSale> createState() => _ListSaleState();
}

class _ListSaleState extends State<ListSale> {
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
    return Consumer<SellingProvider>(
      builder: (context, manager, child) {
        List<Sales> value = manager.items;
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
                        child: ExpansionTile(
                          leading: SizedBox(
                              width: 30,
                              child: Center(
                                child: Text('${index + 1}.)'),
                              )),
                          title: Text(value[index].name),
                          subtitle: Text(
                              'Price : Rp. ${currency.format(value[index].sellingPrice)}'),
                          children: [
                            ListTile(
                              onTap: () {},
                              leading: SizedBox(width: 30, child: Container()),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, EditSale.routeName,
                                          arguments: value[index]);
                                    },
                                    icon: const Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  'Ingin Menghapus Data?'),
                                              content: const Text(
                                                  'Anda hanya bisa Menghapus data yang telah anda tambahkan'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Batal'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    final result = await manager
                                                        .delete(value[index]);
                                                    manager.get();
                                                    if (mounted) {}
                                                    Navigator.pop(context);
                                                    showNotification(
                                                        context, result);
                                                    if (mounted) {}
                                                    Navigator.pop(context);
                                                    showNotification(
                                                        context, result);
                                                  },
                                                  child: const Text('Hapus'),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Quantity : ${value[index].sum}'),
                                  Text('Date : ${value[index].date}'),
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
