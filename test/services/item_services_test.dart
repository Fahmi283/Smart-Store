import 'package:smart_store/model/items_model.dart';
import 'package:smart_store/services/items_services.dart';
import 'package:test/test.dart';

import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'item_services_test.mocks.dart';

@GenerateMocks([ItemsServices])
void main() {
  group('Items API', () {
    test('get all Items return data', () async {
      var modelApi = MockItemsServices();
      when(modelApi.getdata()).thenAnswer(
        (_) async =>
            <Items>[Items(name: 'test', price: 0, barcode: 0, stock: 0)],
      );

      var items = await modelApi.getdata();
      expect(items.isNotEmpty, true);
    });

    test('Add Items return String', () async {
      var data = Items(name: 'test', price: 10000, barcode: 123456, stock: 10);
      var modelApi = MockItemsServices();
      when(modelApi.add(data)).thenAnswer(
        (realInvocation) async => 'Data berhasil ditambahkan',
      );

      var items = await modelApi.add(data);
      expect(items == 'Data berhasil ditambahkan', true);
    });

    test('delete Items return String', () async {
      var data = 'OqttqUwml2NMSRifQbzyWjLhlGb2';
      var modelApi = MockItemsServices();
      when(modelApi.delete(data)).thenAnswer(
        (realInvocation) async => 'null',
      );

      var items = await modelApi.delete(data);
      expect(items == 'null', true);
    });

    test('update Items return String', () async {
      var data = Items(name: 'test', price: 10000, barcode: 123456, stock: 10);
      var modelApi = MockItemsServices();
      when(modelApi.updateItem(data)).thenAnswer(
        (realInvocation) async => 'Berhasil di update',
      );

      var items = await modelApi.updateItem(data);
      expect(items == 'Berhasil di update', true);
    });

    test('update Stock return String', () async {
      var data = Items(name: 'test', price: 10000, barcode: 123456, stock: 10);
      var sum = 10;
      var modelApi = MockItemsServices();
      when(modelApi.updateStock(data, sum)).thenAnswer(
        (realInvocation) async => 'Berhasil di update',
      );

      var items = await modelApi.updateStock(data, sum);
      expect(items == 'Berhasil di update', true);
    });
  });
}
