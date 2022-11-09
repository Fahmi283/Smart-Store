import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_store/provider/items_provider.dart';

import '../model/sales_model.dart';
import '../provider/selling_provider.dart';

class EditSale extends StatefulWidget {
  static const routeName = '/editSale';
  const EditSale({super.key});

  @override
  State<EditSale> createState() => _EditSaleState();
}

class _EditSaleState extends State<EditSale> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController sellingPriceController;
  late TextEditingController barcodeController;
  late TextEditingController stockController;

  void showNotification(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.blue.shade200,
        content: Text(message.toString())));
  }

  @override
  void initState() {
    nameController = TextEditingController();
    sellingPriceController = TextEditingController();
    barcodeController = TextEditingController();
    stockController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    sellingPriceController.dispose();
    barcodeController.dispose();
    stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var ref = context.read<ItemsProvider>();
    final args = ModalRoute.of(context)!.settings.arguments as Sales;

    nameController.text = args.name;
    sellingPriceController.text = args.sellingPrice.toString();
    barcodeController.text = args.barcode.toString();
    stockController.text = args.sum.toString();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade200,
        title: Text(
          'Edit Data',
          style: GoogleFonts.lato(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(16),
                  child: Text(
                    'Edit Data Barang',
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
                    enabled: false,
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
                    enabled: false,
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
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    controller: sellingPriceController,
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
                        hintText: 'Selling price'),
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
                        hintText: 'Jmmlah'),
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
                          final helper = Provider.of<SellingProvider>(context,
                              listen: false);
                          Sales data = Sales(
                            uId: args.uId,
                            id: args.id,
                            name: args.name,
                            sellingPrice:
                                int.parse(sellingPriceController.text),
                            barcode: args.barcode,
                            sum: int.parse(stockController.text),
                            date: args.date,
                          );
                          final result = await helper.edit(data);
                          var selisih =
                              args.sum - int.parse(stockController.text);

                          var dataIndex = ref.items.indexWhere(
                              (element) => element.barcode == args.barcode);
                          if (dataIndex != -1) {
                            var sum = ref.items[dataIndex].stock + selisih;
                            await ref.updateStock(ref.items[dataIndex], sum);
                            ref.get();
                          }

                          if (mounted) {}
                          showNotification(context, result);
                          SmartDialog.dismiss();
                          helper.get();
                          ref.get();
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Edit Item')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
