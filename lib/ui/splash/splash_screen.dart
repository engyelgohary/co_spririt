// import 'package:co_spirit/ui/auth/login.dart';
import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:co_spirit/core/constants.dart';
import 'package:co_spirit/ui/auth/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await initializeHive();
        await initializeNotification();
        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(
              builder: (context) => LoginScreen(),
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
            SizedBox(
              height: 32,
            ),
            CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}

Future<void> initializeHive() async {
  await Hive.initFlutter();
  const secureStorage = FlutterSecureStorage();
  String encryptionKey = await secureStorage.read(key: 'encryptionKey') ?? "";

  if (encryptionKey.isEmpty) {
    var key = base64UrlEncode(Hive.generateSecureKey());
    await secureStorage.write(key: 'encryptionKey', value: key);
    encryptionKey = key;
  }

  hiveBox = await Hive.openBox(
    userDB,
    encryptionCipher: HiveAesCipher(base64Url.decode(encryptionKey)),
  );
}

Future<void> initializeNotification() async {
  final initializationResult = await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelGroupKey: 'op_detector_group',
        channelKey: 'op_channel_channel',
        channelName: 'op detector notifications',
        channelDescription: 'Notification channel for op detector',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
      )
    ],
    channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: 'op_detector_group',
        channelGroupName: 'op detector group',
      )
    ],
    debug: true,
  );

  print("Notification initialization result: $initializationResult");

  bool isAllowed = await AwesomeNotifications().isNotificationAllowed();

  if (!isAllowed) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }
}
