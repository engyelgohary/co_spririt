import 'package:co_spirit/data/dip.dart';
import 'package:co_spirit/ui/om/requests/cubit/types_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/theme/appColors.dart';

class AddStatusDialog extends StatefulWidget {
  final VoidCallback onOpportunityAdded;
  const AddStatusDialog({super.key, required this.onOpportunityAdded});
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
        if (state is TypesLoading) {
          const CircularProgressIndicator();
        } else if (state is TypesError) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.errorMessage ?? ""),
          ));
        } else if (state is TypesSuccess) {
          widget.onOpportunityAdded(); // Call the callback
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Type Added Successfully"),
          ));
        }
      },
      builder: (context, state) {
        return Container(
          height: 155,
          width: 319,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
          ),
          child: AlertDialog(
            title: Text(
              "Add Type",
              style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 15),
            ),
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
                        contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
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
                  SizedBox(
                    height: 30,
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontSize: 16, color: AppColor.thirdColor),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.greyColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  SizedBox(
                    height: 30,
                    width: 115,
                    child: ElevatedButton(
                      onPressed: () {
                        viewModel.addType();
                      },
                      child: Center(
                        child: Text(
                          'Add',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontSize: 16, color: AppColor.whiteColor),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.buttonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
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
