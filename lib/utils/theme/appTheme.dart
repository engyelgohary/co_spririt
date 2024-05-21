import 'package:flutter/material.dart';

import 'appColors.dart';

class AppTheme {
  static ThemeData mainTheme = ThemeData(
      textTheme: const TextTheme(
          titleLarge: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColor.whiteColor
          ),
          titleMedium: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: AppColor.whiteColor
          ),
          titleSmall: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColor.basicColor
          )
      )
  );
}