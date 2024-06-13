import 'package:flutter/material.dart';

import '../../../core/app_ui.dart';


class DropDownAdminItem extends StatefulWidget {
  DropDownAdminItem({super.key});

  @override
  State<DropDownAdminItem> createState() => _DropDownAdminItemState();
}

class _DropDownAdminItemState extends State<DropDownAdminItem> {
  List<String> items = [
    "Admin 1",
    "Admin 2"
  ];

  String? selectedItem = "Admin 1";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 18),
      child: Container(
        width: 343,
        height: 48,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: AppUI.whiteColor,
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
                blurStyle: BlurStyle.normal // changes position of shadow
                ),
          ],
        ),
        child: DropdownButton<String>(
          value: selectedItem,
          items: items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(
                      color: AppUI.blackColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: (item) => setState(() => selectedItem = item),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
