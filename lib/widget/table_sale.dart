import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../provider/selling_provider.dart';
import '../screen/edit_sale.dart';

class TableSaleData extends StatefulWidget {
  const TableSaleData({super.key});

  @override
  State<TableSaleData> createState() => _TableSaleDataState();
}

class _TableSaleDataState extends State<TableSaleData> {
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
    return Consumer<SellingProvider>(builder: (context, value, child) {
      var data = value.items;
      return Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            child: const Text('Data History Penjualan'),
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
                    label: const Text('Jumlah'),
                    fixedWidth: 80,
                    onSort: (columnIndex, _) {
                      setState(() {
                        _currentSortColumn = columnIndex;
                        if (_isAscending == true) {
                          _isAscending = false;
                          // sort the product list in Ascending, order by Sum
                          data.sort((A, B) => B.sum.compareTo(A.sum));
                        } else {
                          _isAscending = true;
                          // sort the product list in Descending, order by Sum
                          data.sort((A, B) => A.sum.compareTo(B.sum));
                        }
                      });
                    },
                  ),
                  DataColumn2(
                    label: const Text('Harga Jual'),
                    fixedWidth: 170,
                    onSort: (columnIndex, _) {
                      setState(() {
                        _currentSortColumn = columnIndex;
                        if (_isAscending == true) {
                          _isAscending = false;
                          // sort the product list in Ascending, order by Sum
                          data.sort((A, B) =>
                              B.sellingPrice.compareTo(A.sellingPrice));
                        } else {
                          _isAscending = true;
                          // sort the product list in Descending, order by Sum
                          data.sort((A, B) =>
                              A.sellingPrice.compareTo(B.sellingPrice));
                        }
                      });
                    },
                  ),
                  DataColumn2(
                    label: const Text('Date'),
                    fixedWidth: 150,
                    onSort: (columnIndex, _) {
                      setState(() {
                        _currentSortColumn = columnIndex;
                        if (_isAscending == true) {
                          _isAscending = false;
                          // sort the product list in Ascending, order by Sum
                          data.sort((A, B) => B.date.compareTo(A.date));
                        } else {
                          _isAscending = true;
                          // sort the product list in Descending, order by Sum
                          data.sort((A, B) => A.date.compareTo(B.date));
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
                              content: Text(
                                  'Anda akan menghapus ${data[index].name}'),
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
                                        await value.delete(data[index]);
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
                      DataCell(Text(data[index].sum.toString())),
                      DataCell(Text(
                          'Rp. ${currency.format(data[index].sellingPrice)}')),
                      DataCell(Text(data[index].date)),
                      DataCell(
                        const Center(child: Text('Edit')),
                        onTap: () {
                          Navigator.pushNamed(context, EditSale.routeName,
                              arguments: data[index]);
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
