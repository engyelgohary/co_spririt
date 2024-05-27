import 'package:co_spririt/ui/admin/requests/request_admin.dart';
import 'package:co_spririt/ui/auth/login.dart';
import 'package:co_spririt/ui/splash/splashscreen.dart';
import 'package:co_spririt/ui/superadmin/Menu/menu_superadmin.dart';
import 'package:co_spririt/ui/superadmin/Notifactions/notifictions_superadmin.dart';
import 'package:co_spririt/ui/superadmin/requests/request_Superadmin.dart';
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
          initialRoute: RequestAdmin.routeName,
          routes: {
            LoginScreen.routeName: (context) => LoginScreen(),
            NotifactionScreenSuperAdmin.routName: (context) => NotifactionScreenSuperAdmin(),
            MenuScreenSuperAdmin.routeName:(context) => MenuScreenSuperAdmin(),
           Splash.routeName:(context) =>Splash(),
            RequestSuperAdmin.routeName:(context) =>RequestSuperAdmin(),
            RequestAdmin.routeName:(context) => RequestAdmin()

          },
          theme: AppTheme.mainTheme,
        );
      },
    );

  }
}


