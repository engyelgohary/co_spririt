
import 'package:co_spririt/utils/theme/appColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/app_ui.dart';
import 'assign_to_admin.dart';

class DialogPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(itemBuilder: (context) =><PopupMenuEntry<String>>[
      PopupMenuItem<String>(
        value: 'Assign to admin',
        child: Text('Assign to admin',style: Theme.of(context).textTheme.titleSmall!.copyWith(color: AppColor.borderColor,fontSize: 12),),
      ),
      PopupMenuItem<String>(
        value: 'Assign to client',
        child: Text('Assign to client',style: Theme.of(context).textTheme.titleSmall!.copyWith(color: AppColor.borderColor,fontSize: 12),),
      ),
    ],
      icon:  Container(
        alignment: Alignment.center,
        height: 29,
        width: 29,
        decoration: BoxDecoration(
          borderRadius:
          BorderRadius.circular(30),
          color: AppUI.opacityColor,
        ),
        child: ImageIcon(
          AssetImage(
            '${AppUI.iconPath}assignto.png',
          ),
          color: AppUI.secondColor,
          size: 14,
        ),
      ),
      offset: Offset(0, 30.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.r),
      ),
      onSelected:  (String result) {
        if (result == 'Assign to admin') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AssignToAdmin(); // Show the custom dialog
            },
          );
        } else if (result == 'Assign to client') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AssignToAdmin(); // Show the custom dialog
            },
          );
        }
      },
    );
  }
 }
