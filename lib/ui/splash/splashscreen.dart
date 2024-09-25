import 'dart:async';
import 'package:co_spirit/ui/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Splash extends StatelessWidget {
  static const String routeName = 'SplashScreen';
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
    });
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/images/logo-corelia.png",
          width: 210.w,
          height: 70.h,
        ),
      ),
    );
  }
}
