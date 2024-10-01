import 'package:co_spirit/core/app_util.dart';
import 'package:co_spirit/utils/theme/appColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatelessWidget {
  String fieldName;
  String? hintText;
  Widget? suffixIcon;
  bool enabled;
  bool isObscure;
  int? maxLines;
  TextInputType keyboardType;
  String? Function(String?)? validator;
  TextEditingController controller;
  double borderRadius;
  Color borderColor;
  Color textColor;

  CustomTextFormField({
    super.key,
    this.validator,
    this.suffixIcon,
    this.hintText,
    this.maxLines = 1,
    this.enabled = true,
    this.isObscure = false,
    this.keyboardType = TextInputType.text,
    this.borderRadius = 5,
    this.borderColor = Colors.white,
    this.textColor = Colors.black,
    required this.fieldName,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    double width = AppUtil.responsiveWidth(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 15),
          child: Text(
            fieldName,
            style: TextStyle(fontSize: 16, color: textColor),
            textAlign: TextAlign.start,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8.h, bottom: 24.h, left: width / 15, right: width / 15),
          child: TextFormField(
            enabled: enabled,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hintText,
              fillColor: AppColor.whiteColor,
              filled: true,
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: borderColor),
                  borderRadius: BorderRadius.circular(borderRadius)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(borderRadius)),
              focusedErrorBorder:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(borderRadius)),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: borderColor),
              ),
              suffixIcon: suffixIcon,
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

class OpportunityTextFormField extends StatelessWidget {
  String fieldName;
  String? hintText;
  Widget? suffixIcon;
  bool isObscure;
  int? maxLines;
  int? minLines;
  TextInputType keyboardType;
  String? Function(String?)? validator;
  TextEditingController controller;

  OpportunityTextFormField({
    super.key,
    this.validator,
    this.suffixIcon,
    this.hintText,
    this.maxLines = 1,
    this.minLines = 1,
    this.isObscure = false,
    this.keyboardType = TextInputType.text,
    required this.fieldName,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    double width = AppUtil.responsiveWidth(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 15),
          child: Text(
            fieldName,
            style: const TextStyle(fontSize: 16, color: ODColorScheme.mainColor),
            textAlign: TextAlign.start,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8.h, bottom: 16.h, left: width / 15, right: width / 15),
          child: TextFormField(
            maxLines: maxLines,
            minLines: minLines,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(16),
              hintText: hintText,
              hintStyle: const TextStyle(color: Color.fromARGB(150, 0, 0, 0)),
              fillColor: AppColor.whiteColor,
              filled: true,
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color.fromARGB(150, 0, 0, 0)),
                  borderRadius: BorderRadius.circular(30)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              suffixIcon: suffixIcon,
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

class OpportunityCommentTextFormField extends StatelessWidget {
  String fieldName;
  Color textColor;
  String? hintText;
  int? maxLines;
  int? minLines;
  String? Function(String?)? validator;
  TextEditingController controller;

  OpportunityCommentTextFormField({
    super.key,
    this.validator,
    this.hintText,
    this.maxLines = 1,
    this.minLines = 1,
    required this.fieldName,
    required this.textColor,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    double width = AppUtil.responsiveWidth(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          fieldName,
          style: TextStyle(fontSize: 16, color: textColor),
          textAlign: TextAlign.start,
        ),
        Padding(
          padding: EdgeInsets.only(top: 8.h, bottom: 16.h, left: width / 50, right: width / 50),
          child: TextFormField(
            maxLines: maxLines,
            minLines: minLines,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(16),
              hintText: hintText,
              hintStyle: const TextStyle(color: Color.fromARGB(150, 0, 0, 0)),
              fillColor: AppColor.whiteColor,
              filled: true,
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color.fromARGB(150, 0, 0, 0)),
                  borderRadius: BorderRadius.circular(30)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
            ),
            style: const TextStyle(color: AppColor.blackColor),
            validator: validator,
            controller: controller,
          ),
        )
      ],
    );
  }
}

class AuthTextFormField extends StatelessWidget {
  String fieldName;
  String? hintText;
  Widget? suffixIcon;
  bool isObscure;
  TextInputType? keyboardType;
  String? Function(String?)? validator;
  TextEditingController controller;

  AuthTextFormField({
    super.key,
    this.validator,
    this.suffixIcon,
    this.hintText,
    this.isObscure = false,
    this.keyboardType,
    required this.fieldName,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    double width = AppUtil.responsiveWidth(context);
    final borderRadius = 30.r;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 11),
          child: Text(
            fieldName,
            style: const TextStyle(fontSize: 16, color: ODColorScheme.mainColor),
            textAlign: TextAlign.start,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8.h, bottom: 15.h, left: width / 12, right: width / 12),
          child: TextFormField(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 16),
              hintText: hintText,
              hintStyle: const TextStyle(color: Color.fromARGB(150, 0, 0, 0)),
              fillColor: AppColor.whiteColor,
              filled: true,
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColor.whiteColor),
                  borderRadius: BorderRadius.circular(borderRadius)),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(150, 0, 0, 0)),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(borderRadius)),
              focusedErrorBorder:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(borderRadius)),
              disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(borderRadius)),
              suffixIcon: suffixIcon,
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
        SizedBox(
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

class OpportunityDropDownMenu extends StatefulWidget {
  final String fieldName;
  final String? initialSelection;
  final String? hintText;
  final List dropDownOptions;
  final TextEditingController? controller;
  final TextEditingController? selection;
  final Color textColor;
  final Color? backgroundColor;
  final VoidCallback? callback;

  const OpportunityDropDownMenu({
    super.key,
    this.controller,
    this.initialSelection,
    this.hintText,
    this.backgroundColor,
    this.callback,
    required this.fieldName,
    required this.selection,
    required this.dropDownOptions,
    required this.textColor,
  });

  @override
  State<OpportunityDropDownMenu> createState() => _OpportunityDropDownMenuState();
}

class _OpportunityDropDownMenuState extends State<OpportunityDropDownMenu> {
  String? selected;

  @override
  Widget build(BuildContext context) {
    double width = AppUtil.responsiveWidth(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.fieldName.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width / 15),
            child: Text(
              widget.fieldName,
              style: TextStyle(fontSize: 16, color: widget.textColor),
              textAlign: TextAlign.start,
            ),
          ),
        Padding(
          padding: EdgeInsets.only(top: 8.h, bottom: 16.h, left: width / 15, right: width / 15),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: widget.backgroundColor ?? AppColor.whiteColor,
            ),
            child: DropdownMenu(
              hintText: widget.hintText,
              inputDecorationTheme: InputDecorationTheme(
                contentPadding: const EdgeInsets.all(16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              menuHeight: 200,
              width: width * 0.85,
              controller: widget.selection,
              initialSelection: widget.initialSelection,
              dropdownMenuEntries: widget.dropDownOptions
                  .map((e) => DropdownMenuEntry(
                        label: e.toString(),
                        value: e,
                      ))
                  .toList(),
              onSelected: (value) => setState(() {
                selected = value;
                if (widget.callback != null) {
                  widget.callback!();
                }
              }),
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
