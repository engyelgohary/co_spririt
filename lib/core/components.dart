import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:co_spirit/ui/sm/sheets/new_project.dart';
import 'package:co_spirit/ui/sm/sheets/new_solution.dart';
import 'package:co_spirit/utils/theme/appColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../ui/sm/menu.dart';
import '../ui/sm/sheets/new_subtask.dart';
import '../ui/sm/sheets/new_task_category.dart';
import '../ui/sm/sheets/new_team.dart';
import '../utils/helper_functions.dart';
import 'app_ui.dart';
import 'app_util.dart';

class TaskCard extends StatelessWidget {
  final String taskName;
  final String status;
  final int progress;
  const TaskCard({Key? key, required this.taskName, required this.status, required this.progress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width * 0.40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            taskName,
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000080),
                overflow: TextOverflow.ellipsis),
          ),
          Text(
            status,
            style: TextStyle(fontSize: 14, color: Colors.grey, overflow: TextOverflow.ellipsis),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CircularPercentIndicator(
                radius: 30.0,
                lineWidth: 5.0,
                percent: progress / 100,
                center: new Text("$progress%"),
                progressColor: Colors.green,
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
    Color focusColor = const Color(0xFF228B22);

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.09,
      color: SCColorScheme.mainColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () => onItemTapped(0),
            icon: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.menu),
                SizedBox(height: 4),
                Text(
                  "Menu",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            color: selectedIndex == 0 ? focusColor : Colors.white,
            focusColor: focusColor,
            tooltip: "Menu",
          ),
          IconButton(
            onPressed: () => onItemTapped(1),
            icon: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "${AppUI.iconPath}RACI.png",
                  color: selectedIndex == 1 ? focusColor : Colors.white,
                ),
                const SizedBox(height: 4),
                Text(
                  "RACI",
                  style: TextStyle(color: selectedIndex == 1 ? focusColor : Colors.white),
                ),
              ],
            ),
            tooltip: "RACI",
            focusColor: focusColor,
          ),
          IconButton(
            onPressed: () => onItemTapped(2),
            icon: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "${AppUI.iconPath}puzzle.png",
                  color: selectedIndex == 2 ? focusColor : Colors.white,
                ),
                const SizedBox(height: 4),
                Text(
                  "Solutions",
                  style: TextStyle(color: selectedIndex == 2 ? focusColor : Colors.white),
                ),
              ],
            ),
            color: selectedIndex == 2 ? focusColor : Colors.white,
            focusColor: focusColor,
            tooltip: "Solutions",
          ),
          IconButton(
            onPressed: () => onItemTapped(3),
            icon: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.message_outlined),
                SizedBox(height: 4),
                Text(
                  "Message",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            color: selectedIndex == 3 ? focusColor : Colors.white,
            focusColor: focusColor,
          ),
        ],
      ),
    );
  }
}

class BottomNavBarSM extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final LoadingStateNotifier? loadingNotifier;

  const BottomNavBarSM({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
    this.loadingNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color focusColor = const Color(0xFF228B22);

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.09,
      color: const Color(0xFF000080),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () => onItemTapped(0),
            icon: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "${AppUI.iconPath}RACI.png",
                  color: selectedIndex == 0 ? focusColor : Colors.white,
                ),
                const SizedBox(height: 4),
                Text(
                  "RACI",
                  style: TextStyle(color: selectedIndex == 0 ? focusColor : Colors.white),
                )
              ],
            ),
            color: selectedIndex == 0 ? focusColor : Colors.white,
            focusColor: focusColor,
            tooltip: "RACI",
          ),
          IconButton(
            onPressed: () => onItemTapped(1),
            icon: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.task_outlined,
                  color: selectedIndex == 1 ? focusColor : Colors.white,
                ),
                const SizedBox(height: 4),
                Text(
                  "Tasks",
                  style: TextStyle(color: selectedIndex == 1 ? focusColor : Colors.white),
                ),
              ],
            ),
            tooltip: "Tasks",
            focusColor: focusColor,
          ),
          PopupMenuButton(
            itemBuilder: (context) {
              if (selectedIndex == 3) {
                return <PopupMenuEntry>[
                  const PopupMenuItem(
                    textStyle: TextStyle(color: SCColorScheme.mainColor),
                    value: 0,
                    child: Text(
                      'New solutions',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: SCColorScheme.mainColor),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 1,
                    child: Text(
                      'Download',
                      style: TextStyle(color: SCColorScheme.mainColor),
                    ),
                  ),
                ];
              } else {
                return <PopupMenuEntry>[
                  const PopupMenuItem(
                    textStyle: TextStyle(color: SCColorScheme.mainColor),
                    value: 0,
                    child: Text(
                      'New Project',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: SCColorScheme.mainColor),
                    ),
                  ),
                  const PopupMenuItem(
                    textStyle: TextStyle(color: SCColorScheme.mainColor),
                    value: 1,
                    child: Text(
                      'New Task Category',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: SCColorScheme.mainColor),
                    ),
                  ),
                  // const PopupMenuItem(
                  //   value: 2,
                  //   child: Text(
                  //     'New Task',
                  //     textAlign: TextAlign.center,
                  //     style: TextStyle(color: SCColorScheme.mainColor),
                  //   ),
                  // ),
                  const PopupMenuItem(
                    value: 3,
                    child: Text(
                      "New Task",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: SCColorScheme.mainColor),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 4,
                    child: Text(
                      "New Team Members",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: SCColorScheme.mainColor),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 5,
                    child: Text(
                      "Download",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: SCColorScheme.mainColor),
                    ),
                  ),
                ];
              }
            },
            onSelected: (value) {
              if (selectedIndex == 1) {
                if (value == 5) {
                  snackBar(context, "not implemented");
                  return;
                }
                showModalBottomSheet(
                  backgroundColor: Colors.white,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.90),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  context: context,
                  builder: (context) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Icon(Icons.horizontal_rule_rounded),
                      ),
                      if (value == 0) const Flexible(child: NewProjectSheetSM()),
                      if (value == 1) const Flexible(child: NewTaskCategorySheetSM()),
                      // if (value == 2) const Flexible(child: NewTaskSheetSM()),
                      if (value == 3) const Flexible(child: NewSubTaskSheetSM()),
                      if (value == 4) const Flexible(child: NewTeamSheetSM()),
                    ],
                  ),
                );
              }
              if (selectedIndex == 3) {
                if (value == 1) {
                  snackBar(context, "not implemented");
                  return;
                }
                showModalBottomSheet(
                  backgroundColor: Colors.white,
                  isScrollControlled: true,
                  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.90),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  context: context,
                  builder: (context) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Icon(Icons.horizontal_rule_rounded),
                      ),
                      if (value == 0) const Flexible(child: NewSolutionSM()),
                    ],
                  ),
                );
              }
            },
            icon: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_box_outlined,
                  color: Colors.white,
                  size: 40,
                ),
                SizedBox(
                  height: 16,
                )
              ],
            ),
          ),
          IconButton(
            onPressed: () => onItemTapped(3),
            icon: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "${AppUI.iconPath}puzzle.png",
                  color: selectedIndex == 3 ? focusColor : Colors.white,
                ),
                const SizedBox(height: 4),
                Text(
                  "Solutions",
                  style: TextStyle(color: selectedIndex == 3 ? focusColor : Colors.white),
                ),
              ],
            ),
            color: selectedIndex == 3 ? focusColor : Colors.white,
            focusColor: focusColor,
            tooltip: "Solutions",
          ),
          IconButton(
            onPressed: () => Navigator.of(context).push(CupertinoPageRoute(
              builder: (context) => MenuScreenSM(ODId: "2"),
            )),
            icon: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.settings),
                const SizedBox(height: 4),
                Text(
                  "Settings",
                  style: TextStyle(color: selectedIndex == 4 ? focusColor : Colors.white),
                ),
              ],
            ),
            color: selectedIndex == 4 ? focusColor : Colors.white,
            focusColor: focusColor,
            tooltip: "Settings",
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
