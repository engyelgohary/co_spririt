import 'package:co_spririt/data/model/Type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../adminforsuperadmin/infoAdmin.dart';

class InfoType extends StatelessWidget {
  Types? types;
  InfoType(this.types);

  @override
  Widget build(BuildContext context) {
    if (types == null) {
      return CircularProgressIndicator();
    }
    return Container(
      height: 100.h,
      width: 369.w,
      padding: EdgeInsets.all(20),
      child: CustomTextInfo(fieldName:'Type :' ,data:"${types!.type}"),
    );
  }
}
