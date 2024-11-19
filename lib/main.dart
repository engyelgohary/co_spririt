import 'package:co_spirit/core/theme/app_theme.dart';
import 'package:co_spirit/edited_ui/home/oa_home.dart';
import 'package:co_spirit/edited_ui/home/od_home.dart';
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
      home: const OAHomeScreen(OAId: "6"),
      theme: AppTheme.mainTheme,
    );
  }
}
