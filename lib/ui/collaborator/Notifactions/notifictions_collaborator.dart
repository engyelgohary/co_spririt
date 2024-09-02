import 'package:co_spririt/utils/components/appbar.dart';
import 'package:co_spririt/utils/theme/appColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/api/apimanager.dart';
import '../../../utils/helper_functions.dart';

class NotificationScreenCollaborator extends StatefulWidget {
  static const String routName = 'Notification Collaborator';
  const NotificationScreenCollaborator({super.key});

  @override
  State<NotificationScreenCollaborator> createState() => _NotificationScreenCollaboratorState();
}

class _NotificationScreenCollaboratorState extends State<NotificationScreenCollaborator> {
  final LoadingStateNotifier<UserNotification> loadingNotifier = LoadingStateNotifier();
  final ApiManager apiManager = ApiManager.getInstance();

  @override
  void dispose() {
    loadingNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alerts',style: Theme.of(context).textTheme.titleSmall,),
        leading: AppBarCustom(),
    ),
      body: ListView.separated(
        separatorBuilder: (context, index) {
          return Divider(
            color: AppColor.whiteColor,
            thickness: 2,
          );
        },
        itemCount: 10,
        itemBuilder: (context, index) {
          return Card(
            color: AppColor.backgroundColor,
            elevation: 0,
            margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColor.secondColor,
                radius: 25,
              ),
              title: Text(
                'Matteo',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w700)
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Contract 1 20/03/2024', style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w400,fontSize: 12)),
                  Text(
                    index % 2 == 0 ? 'End' : 'End Soon',
                    style: TextStyle(
                      color: index % 2 == 0 ? AppColor.errorColor : AppColor.secondColor,
                    ),
                  ),
                ],
              ),
              trailing: CircleAvatar(
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
      ),
      );
  }
}
