import 'package:co_spirit/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppBarCustom extends StatelessWidget {
  const AppBarCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 4),
      child: IconButton(
        icon: CircleAvatar(
          radius: 25, // Adjust the radius as needed
          backgroundColor: AppColor.secondColor,
          child: Padding(
            padding: EdgeInsets.only(left: 4),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 15,
            ),
          ),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
