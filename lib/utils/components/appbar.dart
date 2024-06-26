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
      height: 50.h,
      width: 60.w,
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
              return AddStatusDialog(title: "Add Status",hintText: 'status',name: 'Status',); // Show the custom dialog
            },
          );
        } else if (result == 'Add Type') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddStatusDialog(title: "Add Type",hintText: 'type',name: 'Type',); // Show the custom dialog
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
  String hintText;
  AddStatusDialog({required this.name,required this.title,required this.hintText});
  @override
  _AddStatusDialogState createState() => _AddStatusDialogState();
}

class _AddStatusDialogState extends State<AddStatusDialog> {
  TextEditingController statusController = TextEditingController();
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
        content:  Row(
          children: [
            Text("${widget.name} :", style: Theme.of(context).textTheme.titleMedium),
            Expanded(
              child: TextField(
                controller: statusController,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: Theme.of(context).textTheme.titleMedium,
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 8.0), // Adjust padding
                ),
              ),
            ),
          ],
        ),
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
        ],
      ),
    );
  }
}