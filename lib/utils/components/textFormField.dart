import 'package:co_spririt/utils/theme/appColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatelessWidget {
  String fieldName;
  String? hintText;
  Widget? suffixIcon;
  bool isObscure;
  int? maxLines;
  TextInputType keyboardType;
  String? Function(String?)? validator;
  TextEditingController controller;

  CustomTextFormField({
    super.key,
    this.validator,
    this.suffixIcon,
    this.hintText,
    this.maxLines = 1,
    this.isObscure = false,
    this.keyboardType = TextInputType.text,
    required this.fieldName,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Text(
            fieldName,
            style: Theme.of(context).textTheme.titleSmall,
            textAlign: TextAlign.start,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 15.h, bottom: 20.h, right: 12.w, left: 12.w),
          child: TextFormField(
            maxLines: maxLines,
            decoration: InputDecoration(
                hintText: hintText,
                fillColor: AppColor.whiteColor,
                filled: true,
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColor.whiteColor),
                    borderRadius: BorderRadius.circular(5.r)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.r),
                ),
                errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.r)),
                focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.r)),
                disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.r)),
                focusColor: AppColor.basicColor,
                hoverColor: AppColor.basicColor,
                suffixIconColor: AppColor.basicColor,
                suffixIcon: suffixIcon),
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

class CustomText extends StatefulWidget {
  String fieldName;
  double? width;
  var keyboardType;
  String? Function(String?)? validator;
  TextEditingController controller;

  CustomText({
    super.key,
    this.validator,
    this.width = 6,
    this.keyboardType = TextInputType.text,
    required this.fieldName,
    required this.controller,
  });

  @override
  State<CustomText> createState() => _CustomTextState();
}

class _CustomTextState extends State<CustomText> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          widget.fieldName,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontSize: 18, fontWeight: FontWeight.w700, color: AppColor.basicColor),
        ),
        SizedBox(
          width: widget.width!.w,
        ),
        Container(
          height: 32.h,
          width: 230.w,
          child: TextFormField(
            keyboardType: widget.keyboardType,
            controller: widget.controller,
            validator: widget.validator,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 4.0.h, horizontal: 10.0.w),
              fillColor: AppColor.whiteColor,
              filled: true,
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColor.borderColor),
                  borderRadius: BorderRadius.circular(5.r)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.r),
              ),
              errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColor.errorColor),
                  borderRadius: BorderRadius.circular(5.r)),
              focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.r)),
              disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.r)),
              focusColor: AppColor.basicColor,
              hoverColor: AppColor.basicColor,
            ),
          ),
        ),
      ],
    );
  }
}

class CustomDropDownMenu extends StatefulWidget {
  final String fieldName;
  final String? initialSelection;
  final List dropDownOptions;
  final TextEditingController? controller;
  final TextEditingController? selection;

  const CustomDropDownMenu({
    super.key,
    this.controller,
    this.initialSelection,
    required this.fieldName,
    required this.selection,
    required this.dropDownOptions,
  });

  @override
  State<CustomDropDownMenu> createState() => _CustomDropDownMenuState();
}

class _CustomDropDownMenuState extends State<CustomDropDownMenu> {
  String? selected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Text(
            widget.fieldName,
            style: Theme.of(context).textTheme.titleSmall,
            textAlign: TextAlign.start,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 15.h, bottom: 20.h, right: 12.w, left: 12.w),
          child: Container(
            color: AppColor.whiteColor,
            child: DropdownMenu(
              menuHeight: 200,
              width: double.maxFinite,
              controller: widget.selection,
              initialSelection: widget.initialSelection,
              dropdownMenuEntries: widget.dropDownOptions
                  .map((e) => DropdownMenuEntry(label: e.toString(), value: e))
                  .toList(),
              onSelected: (value) => setState(() => selected = value),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomDoubleTextFormField extends StatelessWidget {
  String fieldName;
  String? hintText1;
  String? hintText2;
  Widget? suffixIcon;
  bool isObscure;
  int? maxLines;
  TextInputType keyboardType;
  String? Function(String?)? validator;
  TextEditingController controller1;
  TextEditingController controller2;

  CustomDoubleTextFormField({
    super.key,
    this.validator,
    this.suffixIcon,
    this.hintText1,
    this.hintText2,
    this.maxLines = 1,
    this.isObscure = false,
    this.keyboardType = TextInputType.text,
    required this.fieldName,
    required this.controller1,
    required this.controller2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Text(
            fieldName,
            style: Theme.of(context).textTheme.titleSmall,
            textAlign: TextAlign.start,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 15.h, bottom: 20.h, right: 12.w, left: 12.w),
          child: Row(
            children: [
              Flexible(
                child: TextFormField(
                  maxLines: maxLines,
                  decoration: InputDecoration(
                      hintText: hintText1,
                      fillColor: AppColor.whiteColor,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: AppColor.whiteColor),
                          borderRadius: BorderRadius.circular(5.r)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.r)),
                      focusedErrorBorder:
                          OutlineInputBorder(borderRadius: BorderRadius.circular(5.r)),
                      disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.r)),
                      focusColor: AppColor.basicColor,
                      hoverColor: AppColor.basicColor,
                      suffixIconColor: AppColor.basicColor,
                      suffixIcon: suffixIcon),
                  style: const TextStyle(color: AppColor.blackColor),
                  validator: validator,
                  controller: controller1,
                  obscureText: isObscure,
                  keyboardType: keyboardType,
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Flexible(
                child: TextFormField(
                  maxLines: maxLines,
                  decoration: InputDecoration(
                      hintText: hintText2,
                      fillColor: AppColor.whiteColor,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: AppColor.whiteColor),
                          borderRadius: BorderRadius.circular(5.r)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.r)),
                      focusedErrorBorder:
                          OutlineInputBorder(borderRadius: BorderRadius.circular(5.r)),
                      disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.r)),
                      focusColor: AppColor.basicColor,
                      hoverColor: AppColor.basicColor,
                      suffixIconColor: AppColor.basicColor,
                      suffixIcon: suffixIcon),
                  style: const TextStyle(color: AppColor.blackColor),
                  validator: validator,
                  controller: controller2,
                  obscureText: isObscure,
                  keyboardType: keyboardType,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
