import 'package:co_spririt/utils/theme/appColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ListRequestsCustom extends StatelessWidget {
  int flex;
  String name;
   ListRequestsCustom({super.key,this.flex = 1,required this.name});

  @override
  Widget build(BuildContext context) {
    return   Expanded(
      flex: flex,
      child: ListView.separated(
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
              title: Text(name,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontSize: 15)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundColor: AppColor.SkyColor,
                    radius: 18.r,
                    child: Icon(
                      Icons.replay,
                      color: AppColor.secondColor,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 8.w,),
                  CircleAvatar(
                    backgroundColor: AppColor.SkyColor,
                    radius: 18.r,
                    child: Icon(
                      Icons.info_outline,
                      color: AppColor.secondColor,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
