import 'package:flutter/cupertino.dart';

class MainPageController extends ChangeNotifier {
  int _tab = 0;
  int get tab => _tab;

  onTabSelected(int index) {
    if (index == _tab) return;

    _tab = index;
    notifyListeners();
  }
}
