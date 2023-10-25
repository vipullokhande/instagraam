import 'package:flutter/material.dart';

class DarkMode with ChangeNotifier {
  bool isDark = true;
  void makeDark() {
    isDark = true;
    notifyListeners();
  }

  void makeLight() {
    isDark = false;
    notifyListeners();
  }
}
