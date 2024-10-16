import 'package:co_spirit/data/model/Type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../adminforsuperadmin/infoAdmin.dart';

class InfoType extends StatelessWidget {
  Types? types;
  InfoType(this.types, {super.key});

  @override
  Widget build(BuildContext context) {
    if (types == null) {
      return const CircularProgressIndicator();
    }
    return Container(
      height: 100,
      width: 369,
      padding: const EdgeInsets.all(20),
      child: CustomTextInfo(fieldName: 'Type :', data: "${types!.type}"),
    );
  }
}
