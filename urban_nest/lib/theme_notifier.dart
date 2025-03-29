import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Color primary = Color(0xfff2f9fe);
const Color secondary = Color(0xFFdbe4f3);
const Color black = Color(0xFF000000);
const Color white = Color(0xFFFFFFFF);
const Color grey = Colors.grey;
const Color red = Color(0xFFec5766);
const Color green = Color(0xFF43aa8b);
const Color blue = Color(0xFF28c2ff);
const Color buttoncolor = Color(0xff3e4784);
const Color mainFontColor = Color(0xff565c95);
const Color arrowbgColor = Color(0xffe4e9f7);

class ThemeNotifier extends ChangeNotifier {

  final darkTheme = ThemeData.dark(useMaterial3: true).copyWith(
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
    primaryTextTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.dark,
    ),
  );

  final lightTheme = ThemeData.light(useMaterial3: true).copyWith(
    // primaryColor: Colors.white,
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
    primaryTextTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.light,
    ),
  );

  ThemeData _themeData = ThemeData();
  ThemeData getTheme() => _themeData;

  ThemeNotifier({required bool isDark}) {
    _themeData = darkTheme;
    if (!isDark) {
      _themeData = lightTheme;
      notifyListeners();
    }
  }

  void toggleThemeMode() async {
    final prefs = await SharedPreferences.getInstance();

    if (_themeData == darkTheme) {
      _themeData = lightTheme;
      log('light-mode');
      prefs.setBool('isDark', false);
    } else {
      _themeData = darkTheme;
      log('dark-mode');
      prefs.setBool('isDark', true);
    }
    notifyListeners();
  }
}
