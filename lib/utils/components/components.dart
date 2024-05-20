import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:co_spririt/utils/theme/appColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_util.dart';


class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final TextAlign? textAlign;
  final FontWeight fontWeight;
  final Color? color;
  final TextDecoration? textDecoration;
  final ui.TextDirection? textDirection;

  const CustomText(
      {Key? key,
        required this.text,
        this.fontSize = 14,
        this.textAlign,
        this.textDirection,
        this.fontWeight = FontWeight.w400,
        this.color,
        this.textDecoration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign ??
          (AppUtil.rtlDirection(context) ? TextAlign.right : TextAlign.left),
      style: TextStyle(
          color: color ?? AppColor.basicColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
          decoration: textDecoration),
      textDirection: textDirection ??
          (AppUtil.rtlDirection(context)
              ? ui.TextDirection.rtl
              : ui.TextDirection.ltr),
    );
  }
}

class CustomButton extends StatelessWidget {
  final Color? color;
  final int radius;
  final String text;
  final Color? textColor, borderColor;
  final Function()? onPressed;
  final double? width, height;
  final Widget? child;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.color,
    this.borderColor,
    this.radius = 8,
    this.textColor = AppColor.whiteColor,
    this.width,
    this.child,
    this.height,
// required LinearGradient gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
          height: height ?? 56,
          margin: const EdgeInsets.all(0),
          width: width ?? AppUtil.responsiveWidth(context) * 0.91,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(double.parse("$radius")),
            color: color,
            border:
            borderColor == null ? null : Border.all(color: borderColor!),
            // gradient: color==null?const LinearGradient(
            //     colors: [
            //       Color(0xff006168),
            //       Color(0xff00C0CE),
            //     ]
            // ):null,
          ),
          alignment: Alignment.center,
          child: child ??
              CustomText(
                text: text,
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
                color: textColor,
              )),
    );
  }
}

class CustomInput extends StatelessWidget {
  final String? hint, lable;
  final TextEditingController controller;
  final TextInputType textInputType;
  final Function()? onTap;
  final Function(String v)? onChange;
  final Function(String v)? onSubmitted;
  final bool obscureText, readOnly, autofocus, validation;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int? maxLines, maxLength;
  final double radius, prefixWidth, suffixWidth;
  final double? contentPaddingVertical;
  final TextAlign? textAlign;
  final FocusNode? focusNode;
  final ui.TextDirection? textDirection;
  final TextStyle? hintStyle;
  final List<TextInputFormatter>? inputFormatters;
  final Color? borderColor, fillColor, counterColor;

  const CustomInput(
      {Key? key,
        required this.controller,
        this.hint,
        this.prefixWidth = 50,
        this.suffixWidth = 50,
        this.inputFormatters,
        this.hintStyle,
        this.textDirection,
        this.lable,
        required this.textInputType,
        this.obscureText = false,
        this.prefixIcon,
        this.suffixIcon,
        this.onTap,
        this.onChange,
        this.maxLines,
        this.textAlign,
        this.readOnly = false,
        this.autofocus = false,
        this.radius = 8.0,
        this.maxLength,
        this.focusNode,
        this.validation = true,
        this.borderColor,
        this.fillColor,
        this.counterColor,
        this.onSubmitted,
        this.contentPaddingVertical})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: maxLines == null
          ? maxLength == null
          ? 45
          : 65
          : null,
      child: TextFormField(
        focusNode: focusNode,
        controller: controller,
        obscureText: obscureText,
        onTap: onTap,
        readOnly: readOnly,
        // maxLength: maxLength,
        keyboardType: textInputType,
        textAlign: textAlign ??
            (AppUtil.rtlDirection(context) ? TextAlign.right : TextAlign.left),
        textDirection: textDirection,
        onChanged: onChange,
        onFieldSubmitted: onSubmitted ??
                (v) {
              FocusScope.of(context).requestFocus(FocusNode());
            },
        // cursorHeight: 27,
        validator: validation
            ? (v) {
          if (v!.isEmpty) {
            return "fieldRequired";
          }
          return null;
        }
            : null,
        autofocus: autofocus,
        maxLines: maxLines ?? 1,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: hintStyle ??
              const TextStyle(color: AppColor.basicColor, fontSize: 18),
          suffixIcon: suffixIcon,
          labelText: lable,
          counterStyle: TextStyle(color: counterColor ?? AppColor.whiteColor),
          // labelStyle: TextStyle(color: AppUI.secondColor),
          filled: true,
          fillColor: fillColor ?? AppColor.whiteColor,
          suffixIconConstraints: BoxConstraints(minWidth: suffixWidth),
          prefixIconConstraints:
          BoxConstraints(minWidth: prefixWidth, maxHeight: 35),
          prefixIcon: prefixIcon,
          contentPadding: EdgeInsets.symmetric(
              horizontal: 12, vertical: contentPaddingVertical ?? 0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(radius),
                  bottomLeft: Radius.circular(radius),
                  bottomRight: Radius.circular(radius),
                  topRight: Radius.circular(radius)),
              borderSide: const BorderSide(color: AppColor.borderColor)),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(radius),
                  bottomLeft: Radius.circular(radius),
                  bottomRight: Radius.circular(radius),
                  topRight: Radius.circular(radius)),
              borderSide: const BorderSide(color: AppColor.secondColor)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(radius),
                  bottomLeft: Radius.circular(radius),
                  bottomRight: Radius.circular(radius),
                  topRight: Radius.circular(radius)),
              borderSide: BorderSide(color: borderColor ?? AppColor.borderColor)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(radius),
                  bottomLeft: Radius.circular(radius),
                  bottomRight: Radius.circular(radius)),
              borderSide: BorderSide(color: borderColor ?? AppColor.secondColor)),
        ),
      ),
    );
  }
}

// class FullScreenLoading extends StatelessWidget {
//   const FullScreenLoading({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: double.infinity,width: double.infinity,alignment: Alignment.center,color: AppUI.shimmerColor.withOpacity(0.5),
//       child: const CircularProgressIndicator(),
//     );
//   }
//
// }

Widget imageUI(img, double width, double height, double radius, story) {
  return Container(
    padding: EdgeInsets.all(story ? 2 : 0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      //color: AppUI.mainColor
    ),
    child: Container(
      padding: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        //color: Colors.white
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // CircularProgressIndicator(),
            CachedNetworkImage(
              imageUrl: img,
              // placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Image.asset(
                "${AppColor.imgPath}Shape.png",
                fit: BoxFit.cover,
              ),
              fit: BoxFit.cover,
              height: height,
              width: width,
            ),
          ],
        ),
      ),
    ),
  );
}
