import 'package:co_spirit/core/initialization.dart';
import 'package:co_spirit/ui/auth/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        try {
          await initialization();
        } catch (e) {
          print(e); // TODO Handle the errors
        }

        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(
              builder: (context) => const LoginScreen(),
            ),
            (route) => false,
          );
        }
      },
    );

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo-corelia.png",
              width: width * 0.5,
            ),
            const SizedBox(
              height: 32,
            ),
            const CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}
