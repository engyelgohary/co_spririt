import 'package:co_spririt/utils/theme/appColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/app_ui.dart';
import '../../../core/components.dart';
import 'drop_down_admin_item.dart';
class AssignToAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 155.h,
      width: 319.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35.r)
      ),
      child: AlertDialog(
        title: Text('Select Admin',style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 15),),
        content: DropDownAdminItem(),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height:30.h,
                width: 120.w,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Center(child: Text('Cancel',style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 16,color: AppColor.thirdColor))),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.greyColor,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(5.r)))),
                ),
              ),
              SizedBox(width: 5.w,),
              Container(
                height:30.h,
                width: 120.w,
                child: ElevatedButton(
                  onPressed: () {
                  },
                  child: Center(child: Text('Assign',style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 16,color: AppColor.whiteColor))),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.buttonColor,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(5.r)))),
                ),
              ),
            ],
          ),
        ],
      ),
    );
    // return Container(
    //   height: 155.h,
    //   width: 319.w,
    //   decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(35.r)
    //   ),
    //   child: AlertDialog(
    //     content: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: <Widget>[
    //         CustomText(
    //           text: 'Select Admin',
    //           fontSize: 15,
    //           color: AppUI.basicColor,
    //           fontWeight: FontWeight.w400,
    //         ),
    //         SizedBox(
    //           height: 12,
    //         ),
    //         DropDownAdminItem(),
    //         // Spacer(),
    //       ],
    //     ),
    //     actions: [
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             Container(
    //               height:30.h,
    //               width: 120.w,
    //               child: ElevatedButton(
    //                 onPressed: () {
    //                   Navigator.of(context).pop(); // Close the dialog
    //                 },
    //                 child: Center(child: Text('Cancel',style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 16,color: AppColor.thirdColor))),
    //                 style: ElevatedButton.styleFrom(
    //                     backgroundColor: AppColor.greyColor,
    //                     shape: RoundedRectangleBorder(
    //                         borderRadius:
    //                         BorderRadius.all(Radius.circular(5.r)))),
    //               ),
    //             ),
    //             SizedBox(width: 5.w,),
    //             Container(
    //               height:30.h,
    //               width: 120.w,
    //               child: ElevatedButton(
    //                 onPressed: () {
    //                 },
    //                 child: Center(child: Text('Add',style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 16,color: AppColor.whiteColor))),
    //                 style: ElevatedButton.styleFrom(
    //                     backgroundColor: AppColor.buttonColor,
    //                     shape: RoundedRectangleBorder(
    //                         borderRadius:
    //                         BorderRadius.all(Radius.circular(5.r)))),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ],
    //   ),
    // );
  }}