import 'package:smart_store/model/sales_model.dart';
import 'package:smart_store/services/selling_services.dart';
import 'package:test/test.dart';

import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'selling_services_test.mocks.dart';

@GenerateMocks([SellingServices])
void main() {
  group('Selling API', () {
    test('get all Selling data return data', () async {
      var modelApi = MockSellingServices();
      when(modelApi.getdata()).thenAnswer(
        (_) async => <Sales>[
          Sales(name: 'name', sellingPrice: 0, barcode: 0, sum: 0, date: 'date')
        ],
      );
      var data = await modelApi.getdata();
      expect(data.isNotEmpty, true);
    });

    test('add  Selling data return String', () async {
      var data = Sales(
          name: 'name', sellingPrice: 10, barcode: 10, sum: 10, date: 'date');
      var modelApi = MockSellingServices();
      when(modelApi.add(data))
          .thenAnswer((_) async => 'Data berhasil ditambahkan');
      var result = await modelApi.add(data);
      expect(result == 'Data berhasil ditambahkan', true);
    });

    test('delete  Selling data return String', () async {
      var data = Sales(
          name: 'name', sellingPrice: 10, barcode: 10, sum: 10, date: 'date');
      var modelApi = MockSellingServices();
      when(modelApi.delete(data)).thenAnswer((_) async => 'Data Dihapus');
      var result = await modelApi.delete(data);
      expect(result == 'Data Dihapus', true);
    });

    test('Edit  Selling data return String', () async {
      var data = Sales(
          name: 'name', sellingPrice: 10, barcode: 10, sum: 10, date: 'date');
      var modelApi = MockSellingServices();
      when(modelApi.updateItem(data))
          .thenAnswer((_) async => 'Berhasil di update');
      var result = await modelApi.updateItem(data);
      expect(result == 'Berhasil di update', true);
    });
  });
}
