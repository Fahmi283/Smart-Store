import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../provider/items_provider.dart';
import '../screen/entry_data.dart';

class TableInventory extends StatefulWidget {
  const TableInventory({super.key});

  @override
  State<TableInventory> createState() => _TableInventoryState();
}

class _TableInventoryState extends State<TableInventory> {
  int _currentSortColumn = 0;

  bool _isAscending = true;
  void showNotification(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.blue.shade200,
        content: Text(message.toString())));
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat("#,##0.00", "id_ID");
    return Consumer<ItemsProvider>(builder: (context, value, child) {
      var data = value.items;
      return Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            child: const Text('Data Inventory'),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: DataTable2(
                // border: const TableBorder(
                //   verticalInside: BorderSide(width: 1, color: Colors.grey),
                //   horizontalInside: BorderSide(width: 1, color: Colors.grey),
                //   top: BorderSide(width: 1, color: Colors.grey),
                //   bottom: BorderSide(width: 1, color: Colors.grey),
                //   left: BorderSide(width: 1, color: Colors.grey),
                //   right: BorderSide(width: 1, color: Colors.grey),
                // ),
                headingRowColor:
                    MaterialStateProperty.all(Colors.blue.shade200),
                dataRowColor: MaterialStateProperty.all(
                    const Color.fromARGB(14, 144, 202, 249)),
                columnSpacing: 12,
                horizontalMargin: 12,
                minWidth: 800,
                sortAscending: _isAscending,
                sortColumnIndex: _currentSortColumn,
                columns: [
                  const DataColumn2(
                    label: Text('NO'),
                    fixedWidth: 25,
                  ),
                  DataColumn2(
                    label: const Text('Item Name'),
                    fixedWidth: 250,
                    onSort: (columnIndex, _) {
                      setState(() {
                        _currentSortColumn = columnIndex;
                        if (_isAscending == true) {
                          _isAscending = false;
                          // sort the product list in Ascending, order by Sum
                          data.sort((A, B) => B.name.compareTo(A.name));
                        } else {
                          _isAscending = true;
                          // sort the product list in Descending, order by Sum
                          data.sort((A, B) => A.name.compareTo(B.name));
                        }
                      });
                    },
                  ),
                  DataColumn2(
                    label: const Center(child: Text('Stock')),
                    fixedWidth: 70,
                    onSort: (columnIndex, _) {
                      setState(() {
                        _currentSortColumn = columnIndex;
                        if (_isAscending == true) {
                          _isAscending = false;
                          // sort the product list in Ascending, order by Sum
                          data.sort((A, B) => B.stock.compareTo(A.stock));
                        } else {
                          _isAscending = true;
                          // sort the product list in Descending, order by stock
                          data.sort((A, B) => A.stock.compareTo(B.stock));
                        }
                      });
                    },
                  ),
                  DataColumn2(
                    label: const Text('Harga'),
                    fixedWidth: 170,
                    onSort: (columnIndex, _) {
                      setState(() {
                        _currentSortColumn = columnIndex;
                        if (_isAscending == true) {
                          _isAscending = false;
                          // sort the product list in Ascending, order by Sum
                          data.sort((A, B) => B.price.compareTo(A.price));
                        } else {
                          _isAscending = true;
                          // sort the product list in Descending, order by Sum
                          data.sort((A, B) => A.price.compareTo(B.price));
                        }
                      });
                    },
                  ),
                  DataColumn2(
                    label: const Text('Barcode'),
                    fixedWidth: 150,
                    onSort: (columnIndex, _) {
                      setState(() {
                        _currentSortColumn = columnIndex;
                        if (_isAscending == true) {
                          _isAscending = false;
                          // sort the product list in Ascending, order by Sum
                          data.sort((A, B) => B.barcode.compareTo(A.barcode));
                        } else {
                          _isAscending = true;
                          // sort the product list in Descending, order by Sum
                          data.sort((A, B) => A.barcode.compareTo(B.barcode));
                        }
                      });
                    },
                  ),
                  const DataColumn2(
                    label: Center(
                      child: Icon(Icons.edit),
                    ),
                    fixedWidth: 50,
                  )
                ],
                rows: List<DataRow>.generate(
                  value.items.length,
                  (index) => DataRow(
                    onLongPress: () {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Ingin Menghapus Data?'),
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
                                    final result =
                                        await value.delete(data[index].id!);
                                    value.get();
                                    if (mounted) {}
                                    Navigator.pop(context);
                                    showNotification(context, result);
                                  },
                                  child: const Text('Hapus'),
                                ),
                              ],
                            );
                          });
                    },
                    cells: [
                      DataCell(Center(child: Text('${index + 1}'))),
                      DataCell(Text(data[index].name)),
                      DataCell(
                          Center(child: Text(data[index].stock.toString()))),
                      DataCell(
                          Text('Rp. ${currency.format(data[index].price)}')),
                      DataCell(Text(data[index].barcode.toString())),
                      DataCell(
                        const Center(child: Text('Edit')),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            EntryItems.routeName,
                            arguments: data[index],
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
