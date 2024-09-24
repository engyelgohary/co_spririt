import 'package:co_spririt/data/dip.dart';
import 'package:co_spririt/ui/od/requests/cubit/requests_cubit.dart';
import 'package:co_spririt/ui/superadmin/requests/cubit/types_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/model/Type.dart';
import '../../../utils/theme/appColors.dart';

class RequestDetailDialog extends StatefulWidget {
  final VoidCallback onOpportunityAdded;
RequestDetailDialog({required this.onOpportunityAdded});
  @override
  _RequestDetailDialogState createState() => _RequestDetailDialogState();
}

class _RequestDetailDialogState extends State<RequestDetailDialog> {

  String? selectedType;
  TextEditingController titleController = TextEditingController();
  late RequestsCubit viewModel;
  late TypesCubit typesCubit;
  bool isTypeLoading = true;
  @override
  void initState() {
    super.initState();
    viewModel = RequestsCubit(requestsRepository: injectRequestsRepository(),typesRepository: injectTypesRepository(),adminRepository: injectAdminRepository(),collaboratorRepository: injectCollaboratorRepository());
  typesCubit = TypesCubit(typesRepository: injectTypesRepository());
  typesCubit.fetchTypes(1).then((_){
    setState(() {
      isTypeLoading = false;
    });
  });
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => viewModel,
      child: BlocBuilder<TypesCubit, TypesState>(
        bloc: typesCubit,
        builder: (context, state) {
          if (state is TypesLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is TypesSuccess) {
            return buildDialog(state.getType ?? []);
          } else if (state is TypesError) {
            return Center(child: Text('Failed to load types'));
          }
          return Container();
        },
      ),
    );
  }
  @override
  Widget buildDialog(List<Types> types) {
    return BlocConsumer<RequestsCubit, RequestsState>(
      bloc: viewModel,
      listener: (context, state) {
        if (state is  RequestsLoading) {
          CircularProgressIndicator();
        } else if (state is RequestsError) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.errorMessage ?? ""),
          ));
          print(state.errorMessage);
        } else if (state is RequestsSuccess) {
          widget.onOpportunityAdded(); // Call the callback
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Request Added Successfully"),
          ));
        }
      },
      builder: (context, state) {
        return Container(
          width: 319.w,
          height: 254.h,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(40.r)),
          child: AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: viewModel.formKey,
                  child: Row(
                    children: [
                      Text('Request Title : ', style: Theme.of(context).textTheme.titleMedium),
                      Expanded(
                        child: TextField(
                          controller: viewModel.title_controller,
                          decoration: InputDecoration(
                            hintText: 'Title',
                            hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                Text('Request Type', style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 8.h),
                Container(
                  height: 32.h,
                  width: 300.w,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.borderColor, width: 1.w),
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.borderColor, width: 1.w),
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                    ),
                    value: selectedType,
                    hint: Text(
                      "Select Type",
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 12, color: AppColor.blackColor),
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedType = newValue;
                        viewModel.selectedTypeId = types.firstWhere((type) => type.type == newValue).id;
                      });
                    },
                    items: types.map((Types type) {
                      return DropdownMenuItem<String>(
                        value: type.type,
                        child: Text(
                          type.type ?? "",
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 12, color: AppColor.blackColor),
                        ),
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
                  Flexible(
                    child: Container(
                      height: 35.h,
                      width: 120.w,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Center(
                          child: Text('Cancel', style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 16, color: AppColor.thirdColor)),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.greyColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.r))),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Flexible(
                    child: Container(
                      height: 35.h,
                      width: 120.w,
                      child: ElevatedButton(
                        onPressed: () {
                          viewModel.addRequest();
                        },
                        child: Center(
                          child: Text('Submit', style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 16, color: AppColor.whiteColor)),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.buttonColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.r))),
                        ),
                      ),
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