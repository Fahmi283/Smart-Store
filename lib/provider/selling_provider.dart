import 'package:flutter/material.dart';

import '../model/sales_model.dart';
import '../services/selling_services.dart';

enum DataState {
  none,
  loading,
  error,
}

class SellingProvider extends ChangeNotifier {
  List<Sales> _items = [];
  DataState _state = DataState.none;
  final SellingServices _service = SellingServices();

  List<Sales> get items => _items;
  DataState get state => _state;
  SellingProvider() {
    get();
  }

  changeState(DataState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<String> add(Sales data) async {
    changeState(DataState.loading);

    try {
      final result = await _service.add(data);

      notifyListeners();
      changeState(DataState.none);
      return result;
    } catch (e) {
      changeState(DataState.error);
      return e.toString();
    }
  }

  void get() async {
    changeState(DataState.loading);

    try {
      final result = await _service.getdata();
      _items = result;
      notifyListeners();
      changeState(DataState.none);
    } catch (e) {
      changeState(DataState.error);
    }
  }

  Future<String> edit(Sales data) async {
    changeState(DataState.loading);

    try {
      final result = await _service.updateItem(data);

      notifyListeners();
      changeState(DataState.none);
      return result;
    } catch (e) {
      changeState(DataState.error);
      return e.toString();
    }
  }

  Future<String> delete(Sales data) async {
    changeState(DataState.loading);

    try {
      final result = await _service.delete(data);

      notifyListeners();
      changeState(DataState.none);
      return result;
    } catch (e) {
      changeState(DataState.error);
      return e.toString();
    }
  }
}
