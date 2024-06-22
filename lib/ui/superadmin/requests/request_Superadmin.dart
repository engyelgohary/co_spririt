import 'package:co_spririt/utils/components/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/theme/appColors.dart';

class RequestSuperAdmin extends StatelessWidget {
  static const String routeName = 'Request Super admin';
  const RequestSuperAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Requests',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 20),
        ),
        leading: AppBarCustom(),
        actions: [
          AppBarCustomIcon(),
        ],
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
              title: Padding(
                padding:  EdgeInsets.symmetric(vertical: 4.h),
                child: Text("Title",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontSize: 15,fontWeight: FontWeight.w700)),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Type', style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontSize: 12)),
                  SizedBox(height: 5.h,),
                  Text('Pending', style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontSize: 14)),
                  SizedBox(height: 3.h,),

                ],
              ),
              trailing:CircleAvatar(
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
      )
    );
  }
}