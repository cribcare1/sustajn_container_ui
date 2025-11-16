import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/number_constants.dart';

class CustomTheme {
  static ThemeData? getTheme(isLightMode) {
    return isLightMode
        ? ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primaryColor: const Color(0xFF78B5A4),
      secondaryHeaderColor: const Color(0xFFD1E5DE),
      colorScheme: const ColorScheme(
        primary: Color(0xff7300e6),
        secondary: Color(0xff00c4cc),
        brightness: Brightness.light,
        onPrimary: Color(0xff8b3dff),
        onSecondary: Color(0xff9e77f3),
        error: Color(0xffdb1436),
        onError: Color(0xffff4757),
        surface: Color(0xffffffff),
        onSurface: Color(0xff0e0e0e),
      ),
      scaffoldBackgroundColor: const Color(0xfffbfbfa),
      appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF78B5A4)), //0xff7300e6  0xff180fd1
      textTheme: TextTheme(
        displayLarge: GoogleFonts.openSans(),
        titleSmall: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xff3e4042)),
        titleMedium: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: const Color(0xff3e4042),
          textStyle: const TextStyle(overflow: TextOverflow.visible),
        ),
        titleLarge: GoogleFonts.roboto(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: const Color(0xff3e4042),
            textStyle: const TextStyle(overflow: TextOverflow.visible)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: const TextStyle(
          // letterSpacing: 1,
            fontFamily: 'OpenSans',
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w600),
        border: getAllBorder(),
        enabledBorder: getAllBorder(),
        focusedBorder: getBorder(),
      ),
    )
        : ThemeData(
      textTheme: const TextTheme(
        titleSmall: TextStyle(color: Colors.black, fontSize: 14),
        titleMedium: TextStyle(color: Colors.black, fontSize: 16),
        titleLarge: TextStyle(color: Colors.black, fontSize: 22),
      ),
    );
  }

  static OutlineInputBorder getBorder() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.purple));
  }

  static OutlineInputBorder getAllBorder() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.grey));
  }

  static TextStyle getButtonBoldBlackStyle() {
    return TextStyle(
      fontFamily: 'OpenSans-Semibold',
      fontSize: Constant.CONTAINER_SIZE_18,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    );
  }
  static TextStyle getButtonStyle() {
    return TextStyle(
      fontFamily: 'OpenSans-Semibold',
      fontSize: Constant.CONTAINER_SIZE_14,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    );
  }

  static TextStyle getButtonBlackStyle() {
    return const TextStyle(
      fontFamily: 'OpenSans-Semibold',
      fontSize: 14.0,
      color: Colors.black87,
    );
  }

  static TextStyle getButtonWhiteStyle() {
    return const TextStyle(
      fontFamily: 'OpenSans-Semibold',
      fontSize: 18.0,
      color: Colors.white,
    );
  }


}
