import 'package:co_spririt/utils/theme/appColors.dart';
import 'package:flutter/material.dart';

class NotifactionScreenSuperAdmin extends StatefulWidget {
  static const String routName = 'Notifaction';
  const NotifactionScreenSuperAdmin({super.key});

  @override
  State<NotifactionScreenSuperAdmin> createState() =>
      _NotifactionScreenSuperAdminState();
}

class _NotifactionScreenSuperAdminState
    extends State<NotifactionScreenSuperAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Alerts',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 20),
        ),
        leading: IconButton(
          icon: const Padding(
            padding: EdgeInsets.all(3.0),
            child: CircleAvatar(
              radius: 20, // Adjust the radius as needed
              backgroundColor: AppColor.secondColor,
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 13,
              ),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) {
          return const Divider(
            color: AppColor.whiteColor,
            thickness: 2,
          );
        },
        itemCount: 10,
        itemBuilder: (context, index) {
          return Card(
            color: AppColor.backgroundColor,
            elevation: 0,
            margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColor.secondColor,
                radius: 25,
              ),
              title: Text('Matteo',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.w700)),
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
                      color: index % 2 == 0
                          ? AppColor.errorColor
                          : AppColor.secondColor,
                    ),
                  ),
                ],
              ),
              trailing: const CircleAvatar(
                backgroundColor: AppColor.secondColor,
                radius: 15,
                child: Icon(
                  Icons.info_outline,
                  color: AppColor.whiteColor,
                  size: 18,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
