import 'package:flutter/material.dart';
import '../../../core/app_ui.dart';
import '../../../core/components.dart';

class UpdateAdminScreen extends StatelessWidget {
  const UpdateAdminScreen({Key? key}) : super(key: key);

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
                Center(
                  child: Container(
                    width: 230,
                    height: 32,
                    child: CustomInput(
                        hint: 'Matteo',
                        hintStyle: TextStyle(
                          fontSize: 18,
                          color: AppUI.basicColor,
                          fontWeight: FontWeight.w400,
                        ),
                        controller: TextEditingController(),
                        textInputType: TextInputType.text),
                  ),
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
                Center(
                  child: Container(
                    width: 230,
                    height: 32,
                    child: CustomInput(
                        hint: 'George',
                        hintStyle: TextStyle(
                          fontSize: 18,
                          color: AppUI.basicColor,
                          fontWeight: FontWeight.w400,
                        ),
                        controller: TextEditingController(),
                        textInputType: TextInputType.text),
                  ),
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
                      hint: '01003234560',
                      hintStyle: TextStyle(
                        fontSize: 18,
                        color: AppUI.basicColor,
                        fontWeight: FontWeight.w400,
                      ),
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
                      hint: 'Matteo@gmail.com',
                      hintStyle: TextStyle(
                        fontSize: 18,
                        color: AppUI.basicColor,
                        fontWeight: FontWeight.w400,
                      ),
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
                  text: 'Can Post  :',
                  fontSize: 18,
                  color: AppUI.basicColor,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(
                  width: 4,
                ),
                CustomText(
                  text: ' Yes',
                  fontSize: 18,
                  color: AppUI.basicColor,
                  fontWeight: FontWeight.w400,
                ),
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
                    text: 'Update',
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
