import 'package:flutter/material.dart';

import '../../../core/app_ui.dart';
import '../../../core/components.dart';



class CollaboratorDetailsScreen extends StatelessWidget {
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
                height: 117,
                width: 120,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 24,
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
              height: 18,
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
              height: 18,
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
              height: 18,
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
              height: 18,
            ),
            Row(
              children: [
                CustomText(
                  text: 'Client :',
                  fontSize: 18,
                  color: AppUI.basicColor,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(
                  width: 4,
                ),
                CustomText(
                  text: ' Client name',
                  fontSize: 18,
                  color: AppUI.basicColor,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            SizedBox(
              height: 18,
            ),
            Row(
              children: [
                CustomText(
                  text: 'Admin :',
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
              height: 18,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Contract Time :',
                  fontSize: 18,
                  color: AppUI.basicColor,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(
                  width: 4,
                ),
                CustomText(
                  text: '3 Month',
                  fontSize: 18,
                  color: AppUI.basicColor,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            SizedBox(
              height: 18,
            ),
            Row(
              children: [
                CustomText(
                  text: 'Status :',
                  fontSize: 18,
                  color: AppUI.basicColor,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(
                  width: 4,
                ),
                CustomText(
                  text: 'Ended',
                  fontSize: 18,
                  color: AppUI.errorColor,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            SizedBox(
              height: 18,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Can massage :',
                  fontSize: 18,
                  color: AppUI.basicColor,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(
                  width: 4,
                ),
                CustomText(
                  text: 'Yes',
                  fontSize: 18,
                  color: AppUI.basicColor,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            SizedBox(
              height: 18,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Last communication :',
                  fontSize: 18,
                  color: AppUI.basicColor,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(
                  width: 4,
                ),
                CustomText(
                  text: '17/12/2019',
                  fontSize: 18,
                  color: AppUI.basicColor,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            SizedBox(
              height: 18,
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Center(
                child: Row(
                  children: [
                    CustomText(
                      text: 'CV',
                      fontSize: 18,
                      color: AppUI.basicColor,
                      fontWeight: FontWeight.w700,
                    ),
                    Spacer(),
                    CustomButton(
                      text: 'Download',
                      color: AppUI.secondColor,
                      textColor: AppUI.whiteColor,
                      width: 135,
                      height: 35,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
