import 'package:flutter/material.dart';

import '../model/items_model.dart';
import '../services/items_services.dart';

enum ViewState {
  none,
  loading,
  error,
}

class ItemsProvider extends ChangeNotifier {
  List<Items> _items = [];
  ViewState _state = ViewState.none;
  final ItemsServices _service = ItemsServices();

  List<Items> get items => _items;
  ViewState get state => _state;

  ItemsProvider() {
    get();
  }

  changeState(ViewState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<String> add(Items data) async {
    changeState(ViewState.loading);

    try {
      final result = await _service.add(data);

      notifyListeners();
      changeState(ViewState.none);
      return result;
    } catch (e) {
      changeState(ViewState.error);
      return e.toString();
    }
  }

  void get() async {
    changeState(ViewState.loading);

    try {
      final result = await _service.getdata();
      _items = result;
      notifyListeners();
      changeState(ViewState.none);
    } catch (e) {
      changeState(ViewState.error);
    }
  }

  Future<String> edit(Items data) async {
    changeState(ViewState.loading);

    try {
      final result = await _service.updateItem(data);

      notifyListeners();
      changeState(ViewState.none);
      return result;
    } catch (e) {
      changeState(ViewState.error);
      return e.toString();
    }
  }

  Future<String> updateStock(Items data, int sum) async {
    changeState(ViewState.loading);

    try {
      final result = await _service.updateStock(data, sum);

      notifyListeners();
      changeState(ViewState.none);
      return result;
    } catch (e) {
      changeState(ViewState.error);
      return e.toString();
    }
  }

  Future<String> delete(String id) async {
    changeState(ViewState.loading);

    try {
      final result = await _service.delete(id);

      notifyListeners();
      changeState(ViewState.none);
      return result;
    } catch (e) {
      changeState(ViewState.error);
      return e.toString();
    }
  }
}
