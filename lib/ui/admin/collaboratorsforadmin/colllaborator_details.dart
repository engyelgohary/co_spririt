import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/app_ui.dart';
import '../../../core/components.dart';



class CollaboratorAdminDetails extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUI.whiteColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Image.asset(
                '${AppUI.imgPath}bigphoto.png',
                height: 117.h,
                width: 120.w,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                CustomText(
                  text: 'Frist Name :',
                  fontSize: 18,
                  color: AppUI.basicColor,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(
                  width: 4,
                ),
                CustomText(
                  text: 'Olivier',
                  fontSize: 18,
                  color: AppUI.basicColor,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              children: [
                CustomText(
                  text: 'Last Name :',
                  fontSize: 18,
                  color: AppUI.basicColor,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(
                  width: 4,
                ),
                CustomText(
                  text: 'George',
                  fontSize: 18,
                  color: AppUI.basicColor,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              children: [
                CustomText(
                  text: 'Mobile : ',
                  fontSize: 18,
                  color: AppUI.basicColor,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(
                  width: 4,
                ),
                CustomText(
                  text: '01003234560',
                  fontSize: 18,
                  color: AppUI.basicColor,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              children: [
                CustomText(
                  text: 'E-mail :',
                  fontSize: 18,
                  color: AppUI.basicColor,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(
                  width: 4,
                ),
                CustomText(
                  text: 'JG@gmail.com',
                  fontSize: 18,
                  color: AppUI.basicColor,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              children: [
                CustomText(
                  text: 'Assign to :',
                  fontSize: 18,
                  color: AppUI.basicColor,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(
                  width: 4,
                ),
                CustomText(
                  text: 'Client 1',
                  fontSize: 18,
                  color: AppUI.basicColor,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }
}
