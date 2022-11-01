import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isdark = true;
  bool get isdark => _isdark;

  ThemeProvider() {
    getPref();
  }

  changeTheme() async {
    _isdark = !_isdark;

    final helper = await SharedPreferences.getInstance();
    helper.setBool('isDark', _isdark);
    notifyListeners();
  }

  getPref() async {
    final helper = await SharedPreferences.getInstance();
    final data = helper.getBool('isDark');
    if (data != null) {
      _isdark = data;
      notifyListeners();
    } else {
      _isdark = true;
      notifyListeners();
    }
  }
}
