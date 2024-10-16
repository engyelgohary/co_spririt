import 'package:co_spirit/data/model/Type.dart';
import 'package:co_spirit/ui/om/requests/cubit/types_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/components/textFormField.dart';
import '../../../utils/theme/appColors.dart';

class UpdateType extends StatefulWidget {
  Types type;

  UpdateType({super.key, required this.type});

  @override
  State<UpdateType> createState() => _UpdateTypeState();
}

class _UpdateTypeState extends State<UpdateType> {
  late TextEditingController typeController;

  @override
  void initState() {
    super.initState();
    typeController = TextEditingController(text: widget.type.type);
  }

  @override
  void dispose() {
    typeController.dispose();
    super.dispose();
  }

  void updateType() {
    context.read<TypesCubit>().updateType(
          widget.type.id ?? 1,
          typeController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 500,
        child: Column(
          children: [
            const SizedBox(height: 20),
            CustomText(
              keyboardType: TextInputType.name,
              fieldName: 'Type :',
              controller: typeController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your Type';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 35,
                  width: 135,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Center(
                        child: Text('Cancel',
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                fontSize: 16,
                                color: AppColor.thirdColor,
                                fontWeight: FontWeight.w400))),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.greyColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.r)))),
                  ),
                ),
                SizedBox(
                  height: 35,
                  width: 135,
                  child: ElevatedButton(
                    onPressed: () {
                      updateType();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Type Update Successfully"),
                      ));
                    },
                    child: Center(
                        child: Text('Update',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(fontSize: 16, color: AppColor.whiteColor))),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.buttonColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.r)))),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
