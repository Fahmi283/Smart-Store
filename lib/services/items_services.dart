import 'package:dio/dio.dart';

import '../model/items_model.dart';

class ItemsServices {
  late Dio _dio;
  static const baseUrl =
      'https://warung-firebase-default-rtdb.asia-southeast1.firebasedatabase.app/items.json';

  ItemsServices() {
    _dio = Dio();
  }
  Future<List<Items>> getdata() async {
    List<Items> data = [];
    final Response response = await _dio.get(baseUrl);
    if (response.data != null) {
      response.data.forEach((k, v) {
        data.add(Items(
          id: k,
          name: v["name"],
          price: v["price"],
          barcode: v["barcode"],
          stock: v["stock"],
        ));
      });
      return data;
    }
    return [];
  }

  Future<String> add(Items data) async {
    Map<String, dynamic> map = {
      "name": data.name,
      "price": data.price,
      "barcode": data.barcode,
      "stock": data.stock,
    };
    final response = await _dio.post(baseUrl, data: map);
    if (response.data != null) {
      return 'Data berhasil ditambahkan';
    } else {
      return 'Gagal menambah data';
    }
  }

  Future<String> delete(String id) async {
    final response = await _dio.delete(
        'https://warung-firebase-default-rtdb.asia-southeast1.firebasedatabase.app/items/$id.json');
    return response.data.toString();
  }

  Future<String> updateItem(Items data) async {
    Map<String, dynamic> map = {
      "name": data.name,
      "price": data.price,
      "barcode": data.barcode,
      "stock": data.stock,
    };
    final response = await _dio.put(
        'https://warung-firebase-default-rtdb.asia-southeast1.firebasedatabase.app/items/${data.id}.json',
        data: map);

    if (response.data != null) {
      return 'Berhasil di update';
    } else {
      return 'Gagal di update';
    }
  }

  Future<String> updateStock(Items data, int sum) async {
    Map<String, dynamic> map = {
      "stock": sum,
    };
    final response = await _dio.patch(
        'https://warung-firebase-default-rtdb.asia-southeast1.firebasedatabase.app/items/${data.id}.json',
        data: map);

    if (response.data != null) {
      return 'Berhasil di update';
    } else {
      return 'Gagal di update';
    }
  }
}
