import 'package:co_spirit/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../app_util.dart';

class CustomMenuCard extends StatelessWidget {
  String name;
  Function onFunction;
  Color iconColor;
  Color textColor;
  bool enableDivider;
  CustomMenuCard({
    super.key,
    required this.name,
    required this.onFunction,
    this.iconColor = AppColor.basicColor,
    this.textColor = AppColor.basicColor,
    this.enableDivider = true,
  });

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
          if (enableDivider)
            const Divider(
              color: AppColor.whiteColor,
              thickness: 2,
            ),
        ],
      ),
    );
  }
}
