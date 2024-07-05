import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/model/GetAdmin.dart';
import '../../../utils/theme/appColors.dart';

class InfoAdmin extends StatelessWidget {
   GetAdmin? admin;
   InfoAdmin(this.admin);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 482.h,
      width: 369.w,
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 16.h),
          CachedNetworkImage(
            imageUrl: 'http://10.10.99.13:3090${admin!.pictureLocation}',
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
            imageBuilder: (context, imageProvider) => CircleAvatar(
              radius: 75.r,
              backgroundImage: imageProvider,
            ),
          ),
          SizedBox(height: 20.h),
          CustomTextInfo(fieldName:'First Name :' ,data:"${admin!.firstName}"),
          SizedBox(height: 16.h,),
          CustomTextInfo(fieldName:'Last Name : ' ,data:"${admin!.lastName}"),
          SizedBox(height: 16.h,),
          CustomTextInfo(fieldName:'Mobile : ' ,data:"${admin!.phone}"),
          SizedBox(height: 16.h,),
          CustomTextInfo(fieldName:'E-mail : ' ,data:"${admin!.email}"),
          SizedBox(height: 16.h,),
          CustomTextInfo(fieldName:'Can Post:' ,data:"${admin!.canPost}"),
        ],
      ),
    );
  }
}
class CustomTextInfo extends StatelessWidget {
  String fieldName;
  double? width;
  String data;
   CustomTextInfo({required this.fieldName,this.width = 6,required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(fieldName,style: Theme.of(context)
            .textTheme
            .titleLarge!.copyWith(fontSize: 18,fontWeight: FontWeight.w700,color: AppColor.basicColor),),
        SizedBox(
          width: width!.w,
        ),
        Text(data,style: Theme.of(context)
            .textTheme
            .titleLarge!.copyWith(fontSize: 18,fontWeight: FontWeight.w400,color: AppColor.basicColor),),
      ],
    );
  }
}
