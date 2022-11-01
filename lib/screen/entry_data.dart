import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../model/items_model.dart';
import '../provider/items_provider.dart';

class EntryItems extends StatefulWidget {
  static const routeName = '/entry';
  const EntryItems({super.key});

  @override
  State<EntryItems> createState() => _EntryItemsState();
}

class _EntryItemsState extends State<EntryItems> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController barcodeController;
  late TextEditingController stockController;

  void showNotification(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.blue.shade200,
        content: Text(message.toString())));
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes = '';
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      var barcode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      if (barcode == '-1') {
        barcodeScanRes = '';
      } else {
        barcodeScanRes = barcode;
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    // if (!mounted) return;

    barcodeController.text = barcodeScanRes;
  }

  @override
  void initState() {
    nameController = TextEditingController();
    priceController = TextEditingController();
    barcodeController = TextEditingController();
    stockController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    barcodeController.dispose();
    stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Items?;
    if (args != null) {
      nameController.text = args.name;
      priceController.text = args.price.toString();
      barcodeController.text = args.barcode.toString();
      stockController.text = args.stock.toString();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade200,
        title: Text(
          (args == null) ? 'Entry Items' : 'Edit Items',
          style: GoogleFonts.lato(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Hero(
          tag: 'edit-list',
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all(16),
                    child: Text(
                      (args == null)
                          ? 'Masukan Data Barang'
                          : 'Edit Data Barang',
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
                    margin: const EdgeInsets.fromLTRB(30, 0, 30, 15),
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                      controller: nameController,
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
                            borderSide: BorderSide(color: Colors.blue.shade200),
                          ),
                          hintText: 'Item Name'),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(30, 0, 30, 15),
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
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
                            borderSide: BorderSide(color: Colors.blue.shade200),
                          ),
                          hintText: 'price'),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(30, 0, 30, 15),
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                    child: TextFormField(
                      onTap: () {
                        scanBarcodeNormal();
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.none,
                      controller: barcodeController,
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
                            borderSide: BorderSide(color: Colors.blue.shade200),
                          ),
                          hintText: 'Barcode'),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(30, 0, 30, 15),
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                    child: TextFormField(
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.number,
                      controller: stockController,
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
                            borderSide: BorderSide(color: Colors.blue.shade200),
                          ),
                          hintText: 'Stock'),
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
                          if (formKey.currentState!.validate()) {
                            SmartDialog.showLoading();
                            final helper = Provider.of<ItemsProvider>(context,
                                listen: false);
                            if (args == null) {
                              Items data = Items(
                                  name: nameController.text,
                                  price: int.parse(priceController.text),
                                  barcode: int.parse(barcodeController.text),
                                  stock: int.parse(stockController.text));
                              var result = await helper.add(data);
                              helper.get();
                              if (mounted) {}
                              showNotification(context, result);
                              SmartDialog.dismiss();
                              Navigator.pop(context);
                            } else {
                              Items data = Items(
                                  id: args.id,
                                  name: nameController.text,
                                  price: int.parse(priceController.text),
                                  barcode: int.parse(barcodeController.text),
                                  stock: int.parse(stockController.text));
                              final result = await helper.edit(data);
                              helper.get();
                              if (mounted) {}
                              showNotification(context, result);
                              SmartDialog.dismiss();
                              Navigator.pop(context);
                            }
                          }
                        },
                        child: Text((args == null) ? 'Add Item' : 'Edit Item')),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
