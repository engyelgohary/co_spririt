import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/components/appbar.dart';
import '../../../utils/theme/appColors.dart';

class RequestCollaborator extends StatelessWidget {
  static const String routeName = 'Request Collaborator';
  final List<String> requests = List.generate(10, (index) => 'Title1');
  RequestCollaborator({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Requests',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 20),
          ),
          leading: AppBarCustom(),
          actions: [
            Padding(
              padding:  EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return RequestDetailDialog();
                    },
                  );
                },
                child: CircleAvatar(
                  radius: 18.r, // Adjust the radius as needed
                  backgroundColor: AppColor.secondColor,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: ListView.separated(
          separatorBuilder: (context, index) {
            return const Divider(
              color: AppColor.whiteColor,
              thickness: 2,
            );
          },
          itemCount: 10,
          itemBuilder: (context, index) {
            return Card(
              color: AppColor.backgroundColor,
              elevation: 0,
              margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              child: ListTile(
                title: Padding(
                  padding:  EdgeInsets.symmetric(vertical: 4.h),
                  child: Text("Title",
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontSize: 15,fontWeight: FontWeight.w700)),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Type', style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontSize: 12)),
                    SizedBox(height: 5.h,),
                    Text('Pending', style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontSize: 14)),
                    SizedBox(height: 3.h,),

                  ],
                ),
                trailing: CircleAvatar(
                  backgroundColor: AppColor.SkyColor,
                  radius: 18.r,
                  child: Icon(
                    Icons.info_outline,
                    color: AppColor.secondColor,
                    size: 20,
                  ),
                ),
              ),
            );
          },
        )
    );
  }
}



class RequestDetailDialog extends StatefulWidget {
  @override
  _RequestDetailDialogState createState() => _RequestDetailDialogState();
}

class _RequestDetailDialogState extends State<RequestDetailDialog> {
  String? selectedStatus;
  List<String> statusOptions = ['Status 1', 'Status 2', 'Status 3'];
  TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 319.w,
      height: 254.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40.r)
      ),
      child: AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Request Title : ', style: Theme.of(context).textTheme.titleMedium),
                Expanded(
                  child: TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: 'Title',
                      hintStyle: Theme.of(context).textTheme.titleMedium,
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8.0), // Adjust padding
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text('Request Type', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 8.h),
            Container(
              height:32.h ,
              width: 300.w,
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5), // Adjust padding as needed
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColor.borderColor, width: 1.w),
                      borderRadius: BorderRadius.circular(5.r)// Border color and width can be customized
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColor.borderColor, width: 1.w),
                      borderRadius: BorderRadius.circular(5.r)
                  ),
                ),
                value: selectedStatus,
                hint: Text("Status 1",style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 12,color: AppColor.blackColor),),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height:35.h,
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
                height:35.h,
                width: 120.w,
                child: ElevatedButton(
                  onPressed: () {
                  },
                  child: Center(child: Text('Submit',style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 16,color: AppColor.whiteColor))),
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

