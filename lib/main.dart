import 'package:co_spririt/ui/Home/home_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  // await Firebase.initializeApp();
  // await AppUtil.initNotification();
  runApp(
    EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ar')],
        path: 'lang',
        fallbackLocale: const Locale('en'),
        child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
          title: 'CO-Spirit',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: false,
            //scaffoldBackgroundColor: AppUI.,
            textTheme: GoogleFonts.tajawalTextTheme(Theme.of(context).textTheme)
                .copyWith(
              bodyText1: GoogleFonts.tajawal(
                  textStyle: Theme.of(context).textTheme.bodyText1),
            ),
          ),
          home: HomeScreen(),
        );
    });
  }
}
