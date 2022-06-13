import 'package:flutter/foundation.dart';

class MainProvider extends ChangeNotifier {
  var count = 0;
  List cart = [];

  String url = "http://192.168.1.4:8000/";
  increment() {
    count += 2;
    notifyListeners();
  }

  addtTocart(product) {
    cart.add(product);
    notifyListeners();
  }
}
