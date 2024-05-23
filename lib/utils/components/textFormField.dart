import 'package:co_spririt/utils/theme/appColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatelessWidget {
  String fieldName;
  Widget? suffixIcon;
  bool isObscure;
  var keyboardType;
  String? Function(String?)? validator;
  TextEditingController controller;
   CustomTextFormField({super.key,required this.fieldName,
     this.suffixIcon,
     this.isObscure = false,
     this.validator,
     required this.controller,
     this.keyboardType = TextInputType.text});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding:EdgeInsets.symmetric(horizontal: 15.w) ,
          child: Text(
            fieldName,
            style: Theme.of(context)
                .textTheme
                .titleSmall,
            textAlign: TextAlign.start,
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 15.h,bottom: 20.h,right: 12.w,left: 12.w),
          child: TextFormField(
            decoration: InputDecoration(
              fillColor: AppColor.whiteColor,
              filled: true,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.r)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.r),),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.r)),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.r)),
                disabledBorder:  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.r)),
                focusColor: AppColor.basicColor,
                hoverColor: AppColor.basicColor,
                suffixIconColor: AppColor.basicColor,

                suffixIcon: suffixIcon
            ),
            style: const TextStyle(color: AppColor.blackColor),
            validator: validator,
            controller: controller,
            obscureText: isObscure,
            keyboardType: keyboardType,
          ),
        )
      ],
    );
  }
}
