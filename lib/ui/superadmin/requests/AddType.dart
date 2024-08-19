import 'package:co_spririt/data/dip.dart';
import 'package:co_spririt/ui/superadmin/requests/cubit/types_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/theme/appColors.dart';

class AddStatusDialog extends StatefulWidget {
  final VoidCallback onOpportunityAdded;
  AddStatusDialog({required this.onOpportunityAdded});
  @override
  _AddStatusDialogState createState() => _AddStatusDialogState();
}

class _AddStatusDialogState extends State<AddStatusDialog> {
  late TypesCubit viewModel;
  @override
  void initState() {
    super.initState();
    viewModel = TypesCubit(typesRepository: injectTypesRepository());
  }

  Widget build(BuildContext context) {
    return BlocConsumer<TypesCubit, TypesState>(
      bloc: viewModel,
      listener: (context, state) {
        if (state is  TypesLoading) {
          CircularProgressIndicator();
        } else if (state is TypesError) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.errorMessage ?? ""),
          ));
          print(state.errorMessage);
        } else if (state is TypesSuccess) {
          widget.onOpportunityAdded(); // Call the callback
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Type Added Successfully"),
          ));
        }
      },
      builder: (context, state) {
        return Container(
          height: 155.h,
          width: 319.w,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35.r)
          ),
          child: AlertDialog(
            title: Text("Add Type",style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 15),),
            content: Form(
              key: viewModel.formKey,
              child: Row(
                children: [
                  Text("Type : ", style: Theme.of(context).textTheme.titleMedium),
                  Expanded(
                    child: TextField(
                      controller: viewModel.Type_controller,
                      decoration: InputDecoration(
                        hintText: "type",
                        hintStyle: Theme.of(context).textTheme.titleMedium,
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 8.0), // Adjust padding
                      ),
                    ),
                  ),
                ],
              ),
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
                        viewModel.addType();
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
      },

    );

  }
}