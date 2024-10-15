import 'package:co_spirit/core/theme/app_theme.dart';
import 'package:co_spirit/ui/splash/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      theme: AppTheme.mainTheme,
    );
  }
}
