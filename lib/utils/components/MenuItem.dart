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
        padding: EdgeInsets.only(top:10.h,left: 20.w,right: 20.w),
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
                    Icon(Icons.arrow_forward_ios,color:color,size: 20,)
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
        padding: EdgeInsets.only(top: 20.h),
        child: ListTile(
          leading: Container(
            width: 70.0,
            height: 70.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/images/Rectangle 5.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          title: Text(name,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontSize: 17)),
          subtitle:  Text(role,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontWeight: FontWeight.w400, fontSize: 12,color: AppColor.borderColor)),
        )
    );
  }
}

