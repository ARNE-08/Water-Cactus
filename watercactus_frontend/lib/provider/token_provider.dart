import 'package:flutter/foundation.dart';

class TokenProvider with ChangeNotifier {
  String? _token;

  String? get token => _token;

  void updateToken(String? token) {
    _token = token;
    notifyListeners();
  }
}

