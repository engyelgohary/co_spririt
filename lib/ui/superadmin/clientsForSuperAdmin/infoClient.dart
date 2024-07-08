import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/model/Client.dart';
import '../adminforsuperadmin/infoAdmin.dart';

class InfoClient extends StatelessWidget {
  Client? client;
  InfoClient({this.client});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240.h,
      width: 369.w,
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20.h),
          CustomTextInfo(
              fieldName: 'First Name :', data: "${client!.firstName}"),
          SizedBox(
            height: 16.h,
          ),
          CustomTextInfo(
              fieldName: 'Last Name : ', data: "${client!.lastName}"),
          SizedBox(
            height: 16.h,
          ),
          CustomTextInfo(
              fieldName: 'Mobile : ', data: "${client!.contactNumber}"),
          SizedBox(
            height: 16.h,
          ),
          CustomTextInfo(fieldName: 'E-mail : ', data: "${client!.email}"),
          SizedBox(
            height: 16.h,
          ),
          CustomTextInfo(
              fieldName: 'Collaborator Name:',
              data: "${client!.collaboratorId}"),
        ],
      ),
    );
  }
}
