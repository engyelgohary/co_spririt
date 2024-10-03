import 'package:co_spirit/core/app_util.dart';
import 'package:co_spirit/data/api/apimanager.dart';
import 'package:co_spirit/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/components/textFormField.dart';
import '../../../utils/theme/appColors.dart';

class NewTaskCategorySheetSC extends StatefulWidget {
  const NewTaskCategorySheetSC({super.key});

  @override
  State<NewTaskCategorySheetSC> createState() => _NewProjectSheetState();
}

class _NewProjectSheetState extends State<NewTaskCategorySheetSC> {
  final taskCategory = TextEditingController();
  final projectName = TextEditingController();
  final ApiManager apiManager = ApiManager.getInstance();
  final LoadingStateNotifier loadingNotifier = LoadingStateNotifier();
  final map = {};

  @override
  Widget build(BuildContext context) {
    double width = AppUtil.responsiveWidth(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListenableBuilder(
        listenable: loadingNotifier,
        builder: (context, child) {
          if (loadingNotifier.loading) {
            taskCategoryList(apiManager, loadingNotifier);
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

          for (var element in loadingNotifier.response!) {
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
                // hintText: "Opportunity title",
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
                          if (projectName.text.trim().isEmpty || taskCategory.text.trim().isEmpty) {
                            return;
                          }
                          loadingIndicatorDialog(context);
                          try {
                            await apiManager.addCategoryName(
                                taskCategory.text.trim(), map[projectName.text.trim()]);
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
