import 'package:flutter/material.dart';


AppBar customAppBar({
  required BuildContext context,
  required String title,
  required Color textColor,
  required Color backArrowColor,
  Color? backgroundColor,
  List<Widget>? actions,
}) {
  double height = MediaQuery.of(context).size.height;
  double width = MediaQuery.of(context).size.width;

  return AppBar(
    scrolledUnderElevation: 0,
    backgroundColor: backgroundColor,
    leading: Padding(
      padding: EdgeInsets.only(left: width / 25),
      child: Center(
        child: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
    ),
    actions: actions,
    title: Text(title, style: TextStyle(fontSize: 22, color: textColor)),
    toolbarHeight: height / 8,
    iconTheme: IconThemeData(color: backArrowColor),
  );
}

AppBar customAppBarNeo({
  required BuildContext context,
  required String title,
  required Color textColor,
  Color? backgroundColor,
}) {
  double height = MediaQuery.of(context).size.height;

  return AppBar(
    scrolledUnderElevation: 0,
    backgroundColor: backgroundColor,
    title: Text(title, style: TextStyle(fontSize: 22, color: textColor)),
    toolbarHeight: height / 8,
  );
}
