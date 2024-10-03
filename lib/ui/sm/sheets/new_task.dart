import 'package:co_spirit/core/app_util.dart';
import 'package:co_spirit/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../utils/components/textFormField.dart';
import '../../../../utils/theme/appColors.dart';
import '../../../data/api/apimanager.dart';

class NewTaskSheetSM extends StatefulWidget {
  const NewTaskSheetSM({super.key});

  @override
  State<NewTaskSheetSM> createState() => _NewProjectSheetState();
}

class _NewProjectSheetState extends State<NewTaskSheetSM> {
  final projectName = TextEditingController();
  final taskCategory = TextEditingController();
  final taskName = TextEditingController();
  final ApiManager apiManager = ApiManager.getInstance();
  final LoadingStateNotifier loadingNotifier = LoadingStateNotifier();
  Map projectsMap = {};
  Map projectsSubTaskMap = {};

  @override
  Widget build(BuildContext context) {
    double width = AppUtil.responsiveWidth(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListenableBuilder(
        listenable: loadingNotifier,
        builder: (context, child) {
          if (loadingNotifier.loading) {
            taskList(apiManager, loadingNotifier);
            return const Center(child: CircularProgressIndicator());
          } else if (loadingNotifier.response == null) {
            return Expanded(
              child: Center(
                child: buildErrorIndicator(
                  "Some error occurred, Please try again.",
                  () => loadingNotifier.change(),
                ),
              ),
            );
          }

          projectsMap = loadingNotifier.response![0];
          projectsSubTaskMap = loadingNotifier.response![1];

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              OpportunityDropDownMenu(
                fieldName: 'Project',
                hintText: "",
                selection: projectName,
                dropDownOptions: projectsMap.keys.toList(),
                textColor: ODColorScheme.mainColor,
                callback: () => setState(() {}),
              ),
              OpportunityDropDownMenu(
                fieldName: 'Task Category',
                hintText: "",
                selection: taskCategory,
                dropDownOptions: projectName.text.trim().isEmpty
                    ? []
                    : projectsSubTaskMap[projectName.text].keys.toList(),
                textColor: ODColorScheme.mainColor,
              ),
              OpportunityTextFormField(
                fieldName: 'Task Name',
                controller: taskName,
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
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          backgroundColor: ODColorScheme.disabledColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.r),
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
                              taskCategory.text.trim().isEmpty ||
                              taskName.text.trim().isEmpty) {
                            return;
                          }
                          loadingIndicatorDialog(context);
                          try {
                            await apiManager.addTaskName(taskName.text.trim(),
                                projectsSubTaskMap[projectName.text][taskCategory.text]);
                            snackBar(context, "Done");
                            Navigator.of(context).pop();
                          } catch (e) {
                            snackBar(context, "Error $e");
                          }
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          backgroundColor: ODColorScheme.buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.r),
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
        },
      ),
    );
  }
}
