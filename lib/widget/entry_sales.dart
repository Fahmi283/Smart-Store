import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/items_model.dart';
import '../model/sales_model.dart';
import '../provider/items_provider.dart';
import '../provider/selling_provider.dart';

class EntrySales extends StatefulWidget {
  const EntrySales({super.key});

  @override
  State<EntrySales> createState() => _EntrySalesState();
}

class _EntrySalesState extends State<EntrySales> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController barcodeController;
  late TextEditingController priceController;
  late TextEditingController sumController;
  late TextEditingController textEditingController;

  String? selectedValue;

  void showNotification(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.blue.shade200,
        content: Text(message.toString())));
  }

  @override
  void initState() {
    barcodeController = TextEditingController();
    textEditingController = TextEditingController();
    priceController = TextEditingController();
    sumController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    barcodeController.dispose();
    priceController.dispose();
    sumController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = Provider.of<ItemsProvider>(context, listen: false);
    return Consumer<SellingProvider>(
      builder: (context, manager, child) {
        if (manager.state == DataState.loading) {
          SmartDialog.showLoading();
        }
        if (manager.state == DataState.error) {
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
        } else {
          SmartDialog.dismiss();
          return Form(
            key: formKey,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(16),
                      child: Text(
                        'Masukan Data Penjualan',
                        style: GoogleFonts.lato(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade200),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 45),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          hint: Text(
                            'Select Item',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          items: List.generate(
                            item.items.length,
                            (index) => DropdownMenuItem(
                              value: item.items[index].barcode.toString(),
                              child: Text(
                                item.items[index].name,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          value: selectedValue,
                          onChanged: (value) {
                            setState(() {
                              barcodeController.text = value as String;
                              selectedValue = value;
                            });
                          },
                          buttonHeight: 40,
                          buttonWidth: 400,
                          itemHeight: 40,
                          dropdownMaxHeight: 300,
                          searchController: textEditingController,
                          searchInnerWidget: Padding(
                            padding: const EdgeInsets.only(
                              top: 8,
                              bottom: 4,
                              right: 8,
                              left: 8,
                            ),
                            child: TextFormField(
                              controller: textEditingController,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                hintText: 'Search for an item...',
                                hintStyle: const TextStyle(fontSize: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          searchMatchFn: (item, searchValue) {
                            return (item.child
                                .toString()
                                .toLowerCase()
                                .contains(searchValue.toLowerCase()));
                          },
                          //This to clear the search value when you close the menu
                          onMenuStateChange: (isOpen) {
                            if (!isOpen) {
                              textEditingController.clear();
                            }
                          },
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(30, 0, 30, 15),
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 15),
                      child: TextFormField(
                        onTap: () async {
                          String barcodeScanRes = '';
                          try {
                            var barcode =
                                await FlutterBarcodeScanner.scanBarcode(
                                    '#ff6666',
                                    'Cancel',
                                    true,
                                    ScanMode.BARCODE);
                            if (barcode == '-1') {
                              barcodeScanRes = '';
                            } else {
                              barcodeScanRes = barcode;
                            }
                          } on PlatformException {
                            barcodeScanRes = 'Failed to get platform version.';
                          }
                          if (!mounted) return;

                          setState(() {
                            barcodeController.text = barcodeScanRes;
                          });
                          var result = item.items.indexWhere((element) =>
                              element.barcode.toString() == barcodeScanRes);
                          if (result != -1) {
                            setState(() {
                              selectedValue = barcodeScanRes;
                            });
                          } else {
                            showNotification(context, 'Barcode Invalid');
                          }
                        },
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        controller: barcodeController,
                        cursorColor: Colors.blue.shade200,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Field tidak boleh kosong';
                          } else if (item.items.indexWhere((element) =>
                                  element.barcode == int.tryParse(value)) <
                              0) {
                            return 'Data Barcode Tidak Ditemukan';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  BorderSide(color: Colors.blue.shade200),
                            ),
                            hintText: 'Barcode'),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(30, 0, 30, 15),
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 15),
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        controller: priceController,
                        cursorColor: Colors.blue.shade200,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Field tidak boleh kosong';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  BorderSide(color: Colors.blue.shade200),
                            ),
                            hintText: 'Selling Price'),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(30, 0, 30, 15),
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 15),
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        controller: sumController,
                        cursorColor: Colors.blue.shade200,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Field tidak boleh kosong';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  BorderSide(color: Colors.blue.shade200),
                            ),
                            hintText: 'jumlah'),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 50),
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (formKey.currentState!.validate()) {
                            SmartDialog.showLoading();
                            User user = FirebaseAuth.instance.currentUser!;

                            var indexItem = item.items.indexWhere((element) =>
                                element.barcode ==
                                int.parse(barcodeController.text));
                            Items dataItem = item.items[indexItem];
                            Sales data = Sales(
                                uId: user.uid,
                                name: dataItem.name,
                                sellingPrice: int.parse(priceController.text),
                                barcode: int.parse(barcodeController.text),
                                sum: int.parse(sumController.text),
                                date: DateFormat('yyyy-MM-dd – kk:mm')
                                    .format(DateTime.now())
                                    .toString());
                            var sum = dataItem.stock - data.sum;
                            var result = await manager.add(data);
                            manager.get();
                            await item.updateStock(dataItem, sum);

                            item.get();
                            if (mounted) {}
                            showNotification(context, result);
                            barcodeController.clear();
                            sumController.clear();
                            priceController.clear();
                            SmartDialog.dismiss();
                          }
                        },
                        child: const Text('Add Data'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
