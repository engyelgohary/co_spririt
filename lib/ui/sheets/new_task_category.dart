import 'package:co_spirit/core/app_util.dart';
import 'package:co_spirit/core/components/helper_functions.dart';
import 'package:co_spirit/core/components/text_form_field.dart';
import 'package:co_spirit/core/theme/app_colors.dart';
import 'package:co_spirit/data/api/apimanager.dart';
import 'package:co_spirit/data/repository/remote_data_source.dart';
import 'package:co_spirit/ui/sheets/cubit/new_task_category_cubit.dart';
import 'package:co_spirit/ui/sheets/cubit/sheet_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewTaskCategorySheet extends StatefulWidget {
  const NewTaskCategorySheet({super.key});

  @override
  State<NewTaskCategorySheet> createState() => _NewProjectSheetState();
}

class _NewProjectSheetState extends State<NewTaskCategorySheet> {
  final taskCategory = TextEditingController();
  final projectName = TextEditingController();
  NewTaskCategoryCubit newTaskCategoryCubit = NewTaskCategoryCubit(
    smDataSource: SMDataSourceRemote(apiManager: ApiManager.getInstance()),
  );

  final map = {};
  @override
  void initState() {
    newTaskCategoryCubit.taskServiceList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = AppUtil.responsiveWidth(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder(
        bloc: newTaskCategoryCubit,
        builder: (context, state) {
          if (state is SheetLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SheetSuccessfulState) {
            for (var element in state.response) {
              map.addAll({element["name"]: element["id"]});
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OpportunityDropDownMenu(
                  fieldName: 'Project',
                  controller: null,
                  hintText: "",
                  selection: projectName,
                  dropDownOptions: map.keys.toList(),
                  textColor: ODColorScheme.mainColor,
                ),
                OpportunityTextFormField(
                  fieldName: 'Task Category',
                  controller: taskCategory,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 15, vertical: 32),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: ODColorScheme.disabledColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Cancel',
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontSize: 16,
                                    color: AppColor.whiteColor,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      Expanded(
                        flex: 3,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (projectName.text.trim().isEmpty ||
                                taskCategory.text.trim().isEmpty) {
                              return;
                            }
                            loadingIndicatorDialog(context);
                            try {
                              await ApiManager.getInstance()
                                  .addCategoryName(taskCategory.text.trim(), map[projectName.text]);
                              snackBar(context, "Done");
                              Navigator.of(context).pop();
                            } catch (e) {
                              snackBar(context, "Error $e");
                            }
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: ODColorScheme.buttonColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Submit',
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontSize: 16,
                                    color: AppColor.whiteColor,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return Center(
            child: buildErrorIndicator(
              "Some error occurred, Please try again.",
              () => newTaskCategoryCubit.taskServiceList(),
            ),
          );
        },
      ),
    );
  }
}
