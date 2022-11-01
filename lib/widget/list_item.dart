import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../provider/items_provider.dart';
import '../screen/entry_data.dart';

class ListItems extends StatelessWidget {
  ListItems({super.key});
  final currency = NumberFormat("#,##0.00", "id_ID");
  void showNotification(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.blue, content: Text(message.toString())));
  }

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<ItemsProvider>(context);
    return Consumer<ItemsProvider>(
      builder: (context, value, child) {
        if (value.state == ViewState.loading) {
          SmartDialog.showLoading();
        }
        if (value.state == ViewState.error) {
          SmartDialog.dismiss();
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Gagal memuat data'),
                ElevatedButton.icon(
                  onPressed: () {
                    data.get();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                )
              ],
            ),
          );
        }
        if (data.items.isNotEmpty) {
          SmartDialog.dismiss();
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
              itemCount: data.items.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: ListTile(
                    onTap: () {
                      data.get();
                    },
                    onLongPress: () async {
                      final result = await data.delete(data.items[index].id!);
                      data.get();

                      // ignore: use_build_context_synchronously
                      showNotification(context, result);
                    },
                    title: Text(data.items[index].name),
                    trailing: IconButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            EntryItems.routeName,
                            arguments: data.items[index],
                          );
                        },
                        icon: const Icon(Icons.edit)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Price : Rp. ${currency.format(data.items[index].price)}'),
                        Text('Stock : ${data.items[index].stock.toString()}'),
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
          );
        } else {
          return Center(
            child: TextButton(
              onPressed: () {
                data.get();
              },
              child: const Text('List is Empty'),
            ),
          );
        }
      },
    );
  }
}
