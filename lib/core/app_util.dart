import 'package:flutter/material.dart';

class AppUtil {
  static double responsiveHeight(context) => MediaQuery.of(context).size.height;

  static double responsiveWidth(context) => MediaQuery.of(context).size.width;

  static mainNavigator(context, screen) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => screen));

  static removeUntilNavigator(context, screen) =>
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => screen), (route) => false);

  static replacementNavigator(context, screen) => Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => screen));

}