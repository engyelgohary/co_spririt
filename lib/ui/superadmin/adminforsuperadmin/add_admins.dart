import 'package:co_spririt/ui/superadmin/adminforsuperadmin/single_check_box.dart';
import 'package:flutter/material.dart';

import '../../../core/app_ui.dart';
import '../../../core/components.dart';



class AddAdminsScreen extends StatelessWidget {
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
                '${AppUI.imgPath}addphoto.png',
                height: 117,
                width: 120,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                CustomText(
                  text: 'Frist Name :',
                  fontSize: 18,
                  color: AppUI.basicColor,
                  fontWeight: FontWeight.w700,
                ),
                Spacer(),
                Container(
                  width: 230,
                  height: 32,
                  child: CustomInput(
                      controller: TextEditingController(),
                      textInputType: TextInputType.text),
                )
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
                Spacer(),
                Container(
                  width: 230,
                  height: 32,
                  child: CustomInput(
                      controller: TextEditingController(),
                      textInputType: TextInputType.number),
                )
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
                Spacer(),
                Container(
                  width: 230,
                  height: 32,
                  child: CustomInput(
                      controller: TextEditingController(),
                      textInputType: TextInputType.number),
                )
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
                Spacer(),
                Container(
                  width: 230,
                  height: 32,
                  child: CustomInput(
                      controller: TextEditingController(),
                      textInputType: TextInputType.emailAddress),
                )
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              children: [
                CustomText(
                  text: 'Can Post :',
                  fontSize: 18,
                  color: AppUI.basicColor,
                  fontWeight: FontWeight.w700,
                ),
                //Spacer(),
                SizedBox(width: 35,),
                Container(
                    width: 200,
                    height: 32,
                    child: SingleCheckBox(isSelectedList: []))
              ],
            ),
            Spacer(),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomButton(
                    text: 'Cancel',
                    color: AppUI.buttonColor,
                    textColor: AppUI.textButtonColor,
                    width: 135,
                    height: 35,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  CustomButton(
                    text: 'Add',
                    color: AppUI.secondColor,
                    textColor: AppUI.whiteColor,
                    width: 135,
                    height: 35,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
