import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:weather_app/const/color.dart';

class CustomeTheme {
  static final lightTheme = ThemeData(
    fontFamily: 'poppins',
    cardColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Vx.gray800,
    iconTheme: const IconThemeData(
      color: Vx.gray600,
    ),
  );
  static final DarkTheme = ThemeData(
    fontFamily: 'poppins',
    cardColor: bgColor.withOpacity(0.5),
    scaffoldBackgroundColor: bgColor,
    primaryColor: Colors.white,
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
  );
}
