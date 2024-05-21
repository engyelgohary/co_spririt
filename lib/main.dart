import 'package:co_spririt/ui/auth/login.dart';
import 'package:co_spririt/ui/superadmin/Notifactions/notifictionsScreen.dart';
import 'package:co_spririt/utils/theme/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360,800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return  MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: LoginScreen.routeName,
          routes: {
            LoginScreen.routeName: (context) => LoginScreen(),
            NotifactionScreenSuperAdmin.routName: (context) => NotifactionScreenSuperAdmin(),
          },
          theme: AppTheme.mainTheme,
        );
      },
    );

  }
}


