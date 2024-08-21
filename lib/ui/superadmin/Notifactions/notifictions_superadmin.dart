import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:co_spririt/utils/components/appbar.dart';
import 'package:co_spririt/utils/theme/appColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotifactionScreenSuperAdmin extends StatefulWidget {
  static const String routName = 'Notifaction SuperAdmin';
  const NotifactionScreenSuperAdmin({super.key});

  @override
  State<NotifactionScreenSuperAdmin> createState() => _NotifactionScreenSuperAdminState();
}

class _NotifactionScreenSuperAdminState extends State<NotifactionScreenSuperAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Alerts',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 20),
        ),
        leading: AppBarCustom(),
      ),
      body: ListView.separated(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage("assets/images/photo.png"),
              radius: 25,
            ),
            title: Text('Matteo',
                style:
                Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w700)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Contract 1 20/03/2024',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontWeight: FontWeight.w400, fontSize: 12)),
                Text(
                  index % 2 == 0 ? 'End' : 'End Soon',
                  style: TextStyle(
                    color: index % 2 == 0 ? AppColor.errorColor : AppColor.secondColor,
                  ),
                ),
              ],
            ),
            trailing: InkWell(
              onTap: () async {
                await AwesomeNotifications().createNotification(
                    content: NotificationContent(
                        id: 16, // -1 is replaced by a random number
                        channelKey: 'basic_channel',
                        title: 'Huston! The eagle has landed!',
                        body: "A small step for a man, but a giant leap to Flutter's community!",
                        bigPicture:
                        'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
                        largeIcon: 'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
                        notificationLayout: NotificationLayout.BigPicture,
                        payload: {'notificationId': '1234567890'}),
                    actionButtons: [
                      NotificationActionButton(
                        key: 'DISMISS',
                        label: 'Dismiss',
                        actionType: ActionType.DismissAction,
                        isDangerousOption: true,
                      )
                    ]);
              },
              child: CircleAvatar(
                backgroundColor: AppColor.SkyColor,
                radius: 18.r,
                child: Icon(
                  Icons.info_outline,
                  color: AppColor.secondColor,
                  size: 20,
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: 0,
            color: AppColor.whiteColor,
            thickness: 1,
          );
        },
      ),
    );
  }
}