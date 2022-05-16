import 'package:flutter/foundation.dart';

class MainProvider extends ChangeNotifier {
  var count = 0;
  List cart = [];
  increment() {
    count += 2;
    notifyListeners();
  }

  addtTocart(product) {
    cart.add(product);
    notifyListeners();
  }
}
