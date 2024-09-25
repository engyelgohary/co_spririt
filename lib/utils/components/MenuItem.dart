import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/app_util.dart';
import '../theme/appColors.dart';

class CustomMenuCard extends StatelessWidget {
  String name;
  Function onFunction;
  Color iconColor;
  Color textColor;
  CustomMenuCard(
      {super.key,
      required this.name,
      required this.onFunction,
      this.iconColor = AppColor.basicColor,
      this.textColor = AppColor.basicColor});

  @override
  Widget build(BuildContext context) {
    double width = AppUtil.responsiveWidth(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width / 25),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              onFunction();
            },
            child: Card(
              color: AppColor.backgroundColor,
              elevation: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      name,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontSize: 16, color: textColor),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: iconColor,
                    size: 20,
                  )
                ],
              ),
            ),
          ),
          const Divider(
            color: AppColor.whiteColor,
            thickness: 2,
          ),
        ],
      ),
    );
  }
}
