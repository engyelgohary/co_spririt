import 'package:co_spirit/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../app_util.dart';

class CustomMenuCard extends StatelessWidget {
  final String name;
  final Function onFunction;
  final Map colorMap;
  final bool enableDivider;
  const CustomMenuCard({
    super.key,
    required this.name,
    required this.onFunction,
    required this.colorMap,
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
                          .copyWith(fontSize: 16, color: colorMap["mainColor"]),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: colorMap["buttonColor"],
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
