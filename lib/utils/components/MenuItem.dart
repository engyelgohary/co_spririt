import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/appColors.dart';

class CustomMenuCard extends StatelessWidget {
  String name;
   Function onFunction;
   Color color;
   CustomMenuCard({super.key,required this.name,required this.onFunction,this.color =AppColor.basicColor });

  @override
  Widget build(BuildContext context) {
    return
      Padding(
        padding: EdgeInsets.symmetric(vertical:10.h,horizontal:12.w,),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                onFunction();
              },
              child: Card(
                color: AppColor.backgroundColor,
                elevation: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name,style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 16,color: color),),
                    Icon(Icons.arrow_forward_ios,color: AppColor.basicColor,size: 20,)
                  ],
                ),
              ),
            ),
            const Divider(
            color: AppColor.whiteColor,
            thickness: 2,
    ),
          ],
        ),
      );
  }
}

class CustomProfileUser extends StatelessWidget {
  String name;
  String role;
   CustomProfileUser({super.key,required this.name,required this.role});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 25.h),
        child: ListTile(
          leading:  CircleAvatar(
            backgroundColor: AppColor.secondColor,
            radius:35.r,
          ),
          title: Text(name,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontSize: 17)),
          subtitle:  Padding(
            padding:  EdgeInsets.only(top: 8.h),
            child: Text(role,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontWeight: FontWeight.w400, fontSize: 12,color: AppColor.borderColor)),
          ),
        )
    );
  }
}

