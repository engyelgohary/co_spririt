import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData mainTheme = ThemeData(
    scaffoldBackgroundColor: AppColor.backgroundColor,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: AppColor.backgroundColor,
      elevation: 0,
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(Colors.white),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      backgroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
        titleLarge:
            TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColor.whiteColor),
        titleMedium:
            TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: SMColorScheme.main),
        titleSmall:
            TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: SMColorScheme.main)),
  );
}
