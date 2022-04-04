import 'package:flutter/foundation.dart';

class MainProvider extends ChangeNotifier {
  var count = 0;

  increment() {
    count += 2;
    notifyListeners();
  }
}
