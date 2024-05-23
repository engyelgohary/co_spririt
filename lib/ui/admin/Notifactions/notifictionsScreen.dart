import 'package:co_spririt/utils/theme/appColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotifactionScreenAdmin extends StatefulWidget {
  static const String routName = 'Notifaction';
  const NotifactionScreenAdmin({super.key});

  @override
  State<NotifactionScreenAdmin> createState() => _NotifactionScreenAdminState();
}

class _NotifactionScreenAdminState extends State<NotifactionScreenAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alerts',style: Theme.of(context).textTheme.titleSmall,),
        leading: Padding(
          padding:  EdgeInsets.only(left: 1.w),
          child: IconButton(
            icon: CircleAvatar(
              radius: 25.r, // Adjust the radius as needed
              backgroundColor: AppColor.secondColor,
              child:  Padding(
                padding:  EdgeInsets.only(left: 4.w),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 15,
                ),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
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
