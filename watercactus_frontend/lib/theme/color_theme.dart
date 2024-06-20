import 'package:flutter/material.dart';

class AppColors {
  // text
  static const lightBlue = Color.fromRGBO(172, 230, 255, 1);
  static const blue = Color.fromRGBO(43, 96, 158, 1);
  static const lightGrey = Color.fromRGBO(217, 217, 217, 1);
  static const grey = Color.fromRGBO(119, 119, 119, 1);
  static const darkGrey = Color.fromRGBO(30, 30, 30, 1);
  static const black = Color.fromRGBO(0, 0, 0, 1);
  static const white = Color.fromRGBO(255, 255, 255, 1);

  // beverages
  static const water = Color.fromRGBO(88, 210, 255, 1);
  static const tea = Color.fromRGBO(157, 198, 61, 1);
  static const coffee = Color.fromRGBO(106, 86, 61, 1);
  static const juice = Color.fromRGBO(251, 199, 0, 1);
  static const milk = Color.fromRGBO(155, 204, 234, 1);
  static const soda = Color.fromRGBO(226, 35, 94, 1);
  static const beer = Color.fromRGBO(199, 199, 255, 1);
  static const wine = Color.fromRGBO(210, 48, 58, 1);

  static const Map<String, Color> beverageColors = {
    'WATER': water,
    'TEA': tea,
    'COFFEE': coffee,
    'JUICE': juice,
    'MILK': milk,
    'SODA': soda,
    'BEER': beer,
    'WINE': wine,
  };
}
