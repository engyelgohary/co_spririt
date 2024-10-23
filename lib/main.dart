import 'package:co_spirit/core/theme/app_theme.dart';
import 'package:co_spirit/ui/splash/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const OpDetector());
}

class OpDetector extends StatelessWidget {
  const OpDetector({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: AppTheme.mainTheme,
    );
  }
}
