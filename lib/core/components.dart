import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_ui.dart';
import 'app_util.dart';

class RaciCard extends StatelessWidget {
  const RaciCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "AGL",
            style:
                TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold, color: Color(0xFF000080)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("InProgress", style: TextStyle(fontSize: 18.sp, color: Colors.grey)),
              Spacer(),
              Image.asset(
                "${AppUI.iconPath}progress.png",
                height: 30.h,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color focusColor = Color(0xFF228B22);

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.09,
      color: Color(0xFF000080),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () => onItemTapped(0),
            icon: Icon(Icons.menu),
            color: selectedIndex == 0 ? focusColor : Colors.white,
            focusColor: focusColor,
            tooltip: "Menu",
          ),
          IconButton(
            onPressed: () => onItemTapped(1),
            icon: Image.asset(
              "${AppUI.iconPath}RACI.png",
              color: selectedIndex == 1 ? focusColor : Colors.white,
            ),
            tooltip: "RACI",
            focusColor: focusColor,
          ),
          IconButton(
            onPressed: () => onItemTapped(2),
            icon: Image.asset(
              "${AppUI.iconPath}puzzle.png",
              color: selectedIndex == 2 ? focusColor : Colors.white,
            ),
            color: selectedIndex == 2 ? focusColor : Colors.white,
            focusColor: focusColor,
            tooltip: "Solutions",
          ),
          IconButton(
            onPressed: () => onItemTapped(3),
            icon: Icon(Icons.message_outlined),
            color: selectedIndex == 3 ? focusColor : Colors.white,
            focusColor: focusColor,
          ),
        ],
      ),
    );
  }
}

class BottomNavBarSC extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBarSC({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color focusColor = Color(0xFF228B22);

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.09,
      color: Color(0xFF000080),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () => onItemTapped(0),
            icon: Icon(Icons.menu),
            color: selectedIndex == 0 ? focusColor : Colors.white,
            focusColor: focusColor,
            tooltip: "Menu",
          ),
          IconButton(
            onPressed: () => onItemTapped(1),
            icon: Image.asset(
              "${AppUI.iconPath}RACI.png",
              color: selectedIndex == 1 ? focusColor : Colors.white,
            ),
            tooltip: "RACI",
            focusColor: focusColor,
          ),
          PopupMenuButton(
            itemBuilder: (context) {
              if (selectedIndex == 3) {
                return <PopupMenuEntry>[
                  const PopupMenuItem(
                    value: 0,
                    child: Text('New solutions'),
                  ),
                  const PopupMenuItem(
                    value: 1,
                    child: Text('Download'),
                  ),
                ];
              } else {
                return <PopupMenuEntry>[
                  const PopupMenuItem(
                    value: 0,
                    child: Text('New Task Category'),
                  ),
                  const PopupMenuItem(
                    value: 1,
                    child: Text('New Task'),
                  ),
                  const PopupMenuItem(
                    value: 2,
                    child: Text("New Subtask"),
                  ),
                  const PopupMenuItem(
                    value: 3,
                    child: Text("New Team Members"),
                  ),
                  const PopupMenuItem(
                    value: 4,
                    child: Text("Download"),
                  ),
                ];
              }
            },
            icon: Icon(
              Icons.add_box_outlined,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () => onItemTapped(3),
            icon: Image.asset(
              "${AppUI.iconPath}puzzle.png",
              color: selectedIndex == 3 ? focusColor : Colors.white,
            ),
            color: selectedIndex == 3 ? focusColor : Colors.white,
            focusColor: focusColor,
            tooltip: "Solutions",
          ),
        ],
      ),
    );
  }
}

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
      textAlign: textAlign,
      style: TextStyle(
          color: color ?? AppUI.basicColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
          decoration: textDecoration),
      textDirection: textDirection,
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
    this.textColor = AppUI.whiteColor,
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
          height: height ?? 35,
          margin: const EdgeInsets.all(0),
          width: width ?? AppUtil.responsiveWidth(context) * 0.85,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(double.parse("$radius")),
            color: color,
            border: borderColor == null ? null : Border.all(color: borderColor!),
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

  // final TextAlign? textAlign;
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
              ? 60
              : 80
          : null,
      child: TextFormField(
        focusNode: focusNode,
        controller: controller,
        obscureText: obscureText,
        onTap: onTap,
        readOnly: readOnly,
        keyboardType: textInputType,
        textDirection: textDirection,
        onChanged: onChange,
        onFieldSubmitted: onSubmitted ??
            (v) {
              FocusScope.of(context).requestFocus(FocusNode());
            },
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
          hintStyle: hintStyle ?? const TextStyle(color: AppUI.buttonColor, fontSize: 12),
          suffixIcon: suffixIcon,
          labelText: lable,
          counterStyle: TextStyle(color: counterColor ?? AppUI.whiteColor),
          filled: true,
          fillColor: fillColor ?? AppUI.whiteColor,
          suffixIconConstraints: BoxConstraints(minWidth: suffixWidth),
          prefixIconConstraints: BoxConstraints(minWidth: prefixWidth, maxHeight: 35),
          prefixIcon: prefixIcon,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 12, vertical: contentPaddingVertical ?? 0),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(radius)),
              borderSide: const BorderSide(color: ui.Color.fromARGB(150, 0, 0, 0))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(radius)),
              borderSide: const BorderSide(color: ui.Color.fromARGB(150, 0, 0, 0))),
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final Widget child;
  final double? height, width;
  final Color? color;
  final double? elevation, radius, padding;
  final Color? border;
  final Function()? onTap;

  const CustomCard(
      {Key? key,
      required this.child,
      this.height,
      this.width,
      this.color,
      this.elevation,
      this.border,
      this.onTap,
      this.radius,
      this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius ?? 15)),
        elevation: elevation ?? 1,
        child: Container(
          padding: EdgeInsets.all(padding ?? 0),
          width: width,
          height: height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius ?? 15),
            border: border != null ? Border.all(color: border!, width: 0.7) : null,
            color: color ?? AppUI.whiteColor,
          ),
          child: child,
        ),
      ),
    );
  }
}

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
                "${AppUI.imgPath}Shape.png",
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
