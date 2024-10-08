import 'package:co_spirit/utils/theme/appColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/app_util.dart';
import '../../../data/api/apimanager.dart';
import '../../../data/model/Notification.dart';
import '../../../utils/helper_functions.dart';

class NotificationScreenOM extends StatefulWidget {
  static const String routName = 'Notification SuperAdmin ';
  const NotificationScreenOM({super.key});

  @override
  State<NotificationScreenOM> createState() => _NotificationScreenOMState();
}

class _NotificationScreenOMState extends State<NotificationScreenOM> {
  final LoadingStateNotifier<UserNotification> loadingNotifier = LoadingStateNotifier();
  final ApiManager apiManager = ApiManager.getInstance();

  @override
  void dispose() {
    loadingNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = AppUtil.responsiveWidth(context);

    return Scaffold(
      appBar: customAppBar(
          title: "Notifications",
          context: context,
          textColor: OMColorScheme.textColor,
          backArrowColor: OMColorScheme.mainColor,),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width / 25),
        child: ListenableBuilder(
            listenable: loadingNotifier,
            builder: (context, child) {
              if (loadingNotifier.loading) {
                notificationList(apiManager, loadingNotifier);
                return const Center(
                    child: CircularProgressIndicator(color: OMColorScheme.buttonColor));
              } else if (loadingNotifier.response == null) {
                return Center(
                  child: buildErrorIndicator(
                    "Some error occurred, Please try again.",
                    () => loadingNotifier.change(),
                  ),
                );
              }

              final data = loadingNotifier.response!.reversed.toList();

              if (data.isEmpty) {
                return const Center(child: Text("You don't have notifications."));
              }

              return ListView.separated(
                separatorBuilder: (context, index) {
                  return const Divider(
                    color: AppColor.whiteColor,
                    thickness: 2,
                  );
                },
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final LoadingStateNotifier readNotifier = LoadingStateNotifier();
                  final notification = data[index];
                  return Card(
                    color: AppColor.backgroundColor,
                    elevation: 0,
                    // margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    child: ListTile(
                      onTap: () {
                        readNotification(apiManager, readNotifier, notification);
                      },
                      leading: CircleAvatar(
                        backgroundColor: AppColor.secondColor,
                        radius: 25,
                        child: Center(
                          child: ListenableBuilder(
                              listenable: readNotifier,
                              builder: (context, child) {
                                return Icon(
                                  notification.isRead ?? false ? Icons.drafts : Icons.mail,
                                  color: Colors.white,
                                );
                              }),
                        ),
                      ),
                      title: Text(notification.title ?? "",
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: OMColorScheme.textColor,
                              fontSize: 16,
                              overflow: TextOverflow.ellipsis)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${notification.date} ${notification.time}",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(fontWeight: FontWeight.w400, fontSize: 12),
                          ),
                        ],
                      ),
                      trailing: CircleAvatar(
                        backgroundColor: AppColor.SkyColor,
                        radius: 18.r,
                        child: const Icon(
                          Icons.info_outline,
                          color: AppColor.secondColor,
                          size: 20,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}
