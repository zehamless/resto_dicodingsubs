import 'package:flutter/foundation.dart';

class IndexNavProvider extends ChangeNotifier {
  int _index = 0;

  int get index => _index;

  set setIndex(int index) {
    _index = index;
    notifyListeners();
  }
}
