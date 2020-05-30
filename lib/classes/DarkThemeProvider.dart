import 'package:flutter/foundation.dart';
import 'package:wise/classes/DevFestPreferemces.dart';

class DarkThemeProvider with ChangeNotifier {
  DevFestPreferences devFestPreferences = DevFestPreferences();
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    devFestPreferences.setDarkTheme(value);
    notifyListeners();
  }
}
