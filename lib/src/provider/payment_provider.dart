import 'package:flutter/material.dart';

class PaymentProvider extends ChangeNotifier {
  bool _isLoading = false;
  double _payAmount = 20;

  //getters
  bool get isLoading => _isLoading;
  double get payAmount => _payAmount;
  //setters
  set isLoading(val) {
    _isLoading = val;
    notifyListeners();
  }

  set payAmount(val) {
    _payAmount = val;
    notifyListeners();
  }
}
