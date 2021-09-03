import 'package:flutter/material.dart';

class Constants {
  static const primaryColor = Color(0xFFE53935);
  static const secondaryColor = Colors.black;
  static const golden = Color.fromRGBO(250, 228, 129, 0.5);
  static const LinearGradient gradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [primaryColor, secondaryColor],
  );
}
