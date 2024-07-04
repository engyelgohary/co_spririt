import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/components/textFormField.dart';
import '../../../utils/theme/appColors.dart';



class AddClientScreen extends StatelessWidget {
  const AddClientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 482.h,
      width: 369.w,
      margin: EdgeInsets.all(20),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: AppColor.disableColor,
              child: Icon(Icons.cameraswitch_outlined,
                  size: 40, color: AppColor.blackColor),
            ),
            SizedBox(height: 20),
            CustomText(
                fieldName: 'First Name :',
                controller: TextEditingController()),
            SizedBox(height: 11),
            CustomText(
              fieldName: 'Mobile :',
              controller: TextEditingController(),
              width: 35,
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 11),
            CustomText(
              fieldName: 'E-mail :',
              controller: TextEditingController(),
              width: 38,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 11),
            CustomText(
              fieldName: 'Assign To:',
              controller: TextEditingController(),
              width: 18,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 26.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: 35.h,
                  width: 135.w,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Center(
                        child: Text('Cancel',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                fontSize: 16,
                                color: AppColor.thirdColor,
                                fontWeight: FontWeight.w400))),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.greyColor,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(5.r)))),
                  ),
                ),
                Container(
                  height: 35.h,
                  width: 135.w,
                  child: ElevatedButton(
                    onPressed: () {
                    },
                    child: Center(
                        child: Text('Add',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                fontSize: 16,
                                color: AppColor.whiteColor))),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.buttonColor,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(5.r)))),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
