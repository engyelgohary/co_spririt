import 'package:co_spririt/utils/theme/appColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBarCustom extends StatelessWidget {
  const AppBarCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: IconButton(
        icon: CircleAvatar(
          radius: 25.r, // Adjust the radius as needed
          backgroundColor: AppColor.secondColor,
          child: Padding(
            padding: EdgeInsets.only(left: 4.w),
            child: Icon(
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
class AppBarCustomIcon extends StatelessWidget {
  const AppBarCustomIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(itemBuilder: (context) =><PopupMenuEntry<String>>[
      PopupMenuItem<String>(
        value: 'Add Status',
        child: Text('Add Status',style: Theme.of(context).textTheme.titleSmall!.copyWith(color: AppColor.borderColor,fontSize: 12),),
      ),
      PopupMenuItem<String>(
        value: 'Add Type',
        child: Text('Add Type',style: Theme.of(context).textTheme.titleSmall!.copyWith(color: AppColor.borderColor,fontSize: 12),),
      ),
    ],
    icon:  Container(
      height: 100.h,
      width: 100.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColor.secondColor,
      ),
      child: Icon(
        Icons.add,
        color: Colors.white,
        size: 20,
      ),
    ),
      offset: Offset(0, 30.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.r),
      ),
      onSelected:  (String result) {
        if (result == 'Add Status') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddStatusDialog(title: "Add Status",name: 'Status 1',); // Show the custom dialog
            },
          );
        } else if (result == 'Add Type') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddStatusDialog(title: "Add Type",name: 'Type 1',); // Show the custom dialog
            },
          );
        }
      },
    );
  }
}
class AddStatusDialog extends StatefulWidget {
  String title;
  String name;
  AddStatusDialog({required this.title,required this.name});
  @override
  _AddStatusDialogState createState() => _AddStatusDialogState();
}

class _AddStatusDialogState extends State<AddStatusDialog> {
  String? selectedStatus;
  List<String> statusOptions = ['Status 1', 'Status 2', 'Status 3']; // Example options

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 155.h,
      width: 319.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35.r)
      ),
      child: AlertDialog(
        title: Text(widget.title,style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 15),),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height:32.h ,
              width: 294.w,
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5), // Adjust padding as needed
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.borderColor, width: 1.w), // Border color and width can be customized
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.borderColor, width: 1.w),
                  ),
                ),
                value: selectedStatus,
                hint: Text(widget.name,style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 12,color: AppColor.blackColor),),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedStatus = newValue;
                  });
                },
                items: statusOptions.map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status,style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 12,color: AppColor.blackColor),),
                  );
                }).toList(),
              ),
            ),


          ],
        ),
        actions: [
          Padding(
            padding:  EdgeInsets.only(left: 1.w,bottom:10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height:30.h,
                  width: 130.w,
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
                  width: 130.w,
                  child: ElevatedButton(
                    onPressed: () {
                    },
                    child: Center(child: Text('Add',style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 16,color: AppColor.whiteColor))),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.buttonColor,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(5.r)))),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}