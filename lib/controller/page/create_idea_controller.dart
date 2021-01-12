import 'package:flutter/material.dart';

class CreateIdeaController extends ChangeNotifier {
  int _counter;
  int get counter => _counter;
  set counter(int value) {
    if (_counter == value) return;
    _counter = value;
    notifyListeners();
  }

  onIncrementFabPressed() {
    counter++;
  }
}
