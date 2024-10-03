import 'dart:developer';

import 'package:co_spirit/core/app_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../utils/components/textFormField.dart';
import '../../../../utils/theme/appColors.dart';
import '../../../data/api/apimanager.dart';
import '../../../utils/helper_functions.dart';

class NewSubTaskSheetSM extends StatefulWidget {
  const NewSubTaskSheetSM({super.key});

  @override
  State<NewSubTaskSheetSM> createState() => _NewProjectSheetState();
}

class _NewProjectSheetState extends State<NewSubTaskSheetSM> {
  final projectName = TextEditingController();
  final taskCategory = TextEditingController();
  final taskName = TextEditingController();
  final subTask = TextEditingController();
  final mileStone = TextEditingController();
  final priority = TextEditingController();
  final progress = TextEditingController();
  final status = TextEditingController();
  final team1 = TextEditingController();
  final team2 = TextEditingController();
  final team3 = TextEditingController();
  final team4 = TextEditingController();
  final raci1 = TextEditingController();
  final raci2 = TextEditingController();
  final raci3 = TextEditingController();
  final raci4 = TextEditingController();
  final ApiManager apiManager = ApiManager.getInstance();
  final LoadingStateNotifier loadingNotifier = LoadingStateNotifier();
  Map projectsMap = {};
  Map projectsSubTaskMap = {};
  Map projectsTasksMap = {};
  Map teamsMap = {};
  Map statusMap = {};
  Map raciMap = {"R": 1, "A": 2, "C": 3, "I": 4};

  @override
  Widget build(BuildContext context) {
    double width = AppUtil.responsiveWidth(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListenableBuilder(
          listenable: loadingNotifier,
          builder: (context, child) {
            if (loadingNotifier.loading) {
              subTaskList(apiManager, loadingNotifier);
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
            projectsTasksMap = loadingNotifier.response![2];
            teamsMap = loadingNotifier.response![3];
            statusMap = loadingNotifier.response![4];

            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  OpportunityDropDownMenu(
                    fieldName: 'Project',
                    selection: projectName,
                    dropDownOptions: projectsMap.keys.toList(),
                    textColor: OMColorScheme.mainColor,
                    callback: () => setState(() {}),
                  ),
                  OpportunityDropDownMenu(
                    fieldName: 'Task Category',
                    selection: taskCategory,
                    dropDownOptions: projectName.text.trim().isEmpty
                        ? []
                        : projectsSubTaskMap[projectName.text].keys.toList(),
                    textColor: OMColorScheme.mainColor,
                    callback: () => setState(() {}),
                  ),
                  // OpportunityDropDownMenu(
                  //   fieldName: 'Task',
                  //   selection: subTask,
                  //   dropDownOptions: taskCategory.text.trim().isEmpty
                  //       ? []
                  //       : projectsTasksMap[taskCategory.text].keys.toList(),
                  //   textColor: OMColorScheme.mainColor,
                  // ),
                  OpportunityTextFormField(
                    fieldName: 'Task',
                    controller: taskName,
                  ),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: Padding(
                  //         padding: EdgeInsets.symmetric(horizontal: width / 15),
                  //         child: const Text(
                  //           "Assigned Team",
                  //           style: TextStyle(fontSize: 16, color: OMColorScheme.mainColor),
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: Padding(
                  //         padding: EdgeInsets.symmetric(horizontal: width / 15),
                  //         child: Text(
                  //           "RACI",
                  //           style: TextStyle(fontSize: 16, color: OMColorScheme.mainColor),
                  //         ),
                  //       ),
                  //     )
                  //   ],
                  // ),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: OpportunityDropDownMenu(
                  //         fieldName: "",
                  //         selection: team2,
                  //         dropDownOptions: teamsMap.keys.toList(),
                  //         textColor: OMColorScheme.mainColor,
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: OpportunityDropDownMenu(
                  //         fieldName: "",
                  //         selection: team2,
                  //         dropDownOptions: teamsMap.keys.toList(),
                  //         textColor: OMColorScheme.mainColor,
                  //       ),
                  //     )
                  //   ],
                  // ),
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              OpportunityDropDownMenu(
                                fieldName: "Assigned Team",
                                selection: team1,
                                dropDownOptions: teamsMap.keys.toList(),
                                textColor: OMColorScheme.mainColor,
                              ),
                              OpportunityDropDownMenu(
                                fieldName: "",
                                selection: team2,
                                dropDownOptions: teamsMap.keys.toList(),
                                textColor: OMColorScheme.mainColor,
                              ),
                              OpportunityDropDownMenu(
                                fieldName: "",
                                selection: team3,
                                dropDownOptions: teamsMap.keys.toList(),
                                textColor: OMColorScheme.mainColor,
                              ),
                              OpportunityDropDownMenu(
                                fieldName: "",
                                selection: team4,
                                dropDownOptions: teamsMap.keys.toList(),
                                textColor: OMColorScheme.mainColor,
                              )
                            ],
                          ),
                        ),
                        Flexible(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              OpportunityDropDownMenu(
                                fieldName: "RACI",
                                selection: raci1,
                                dropDownOptions: ["R", "A", "C", "I"],
                                textColor: OMColorScheme.mainColor,
                              ),
                              OpportunityDropDownMenu(
                                fieldName: "",
                                selection: raci2,
                                dropDownOptions: ["R", "A", "C", "I"],
                                textColor: OMColorScheme.mainColor,
                              ),
                              OpportunityDropDownMenu(
                                fieldName: "",
                                selection: raci3,
                                dropDownOptions: ["R", "A", "C", "I"],
                                textColor: OMColorScheme.mainColor,
                              ),
                              OpportunityDropDownMenu(
                                fieldName: "",
                                selection: raci4,
                                dropDownOptions: ["R", "A", "C", "I"],
                                textColor: OMColorScheme.mainColor,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  OpportunityTextFormField(
                    fieldName: 'Milestone',
                    controller: mileStone,
                  ),
                  OpportunityTextFormField(
                    fieldName: 'Priority',
                    controller: priority,
                  ),
                  OpportunityTextFormField(
                    fieldName: 'Progress',
                    controller: progress,
                  ),
                  OpportunityDropDownMenu(
                    fieldName: 'Status',
                    selection: status,
                    dropDownOptions: statusMap.keys.toList(),
                    textColor: OMColorScheme.mainColor,
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
                                  taskName.text.trim().isEmpty ||
                                  projectName.text.trim().isEmpty ||
                                  priority.text.trim().isEmpty ||
                                  progress.text.trim().isEmpty ||
                                  status.text.trim().isEmpty ||
                                  team1.text.trim().isEmpty ||
                                  team2.text.trim().isEmpty ||
                                  team3.text.trim().isEmpty ||
                                  team4.text.trim().isEmpty ||
                                  raci1.text.trim().isEmpty ||
                                  raci2.text.trim().isEmpty ||
                                  raci3.text.trim().isEmpty ||
                                  raci4.text.trim().isEmpty ||
                                  mileStone.text.trim().isEmpty) {
                                return;
                              }
                              loadingIndicatorDialog(context);
                              try {
                                print(subTask.text);
                                await apiManager.AddNewTask(
                                    projectId: projectsMap[projectName.text],
                                    categoryId: projectsSubTaskMap[projectName.text]
                                        [taskCategory.text],
                                    subTaskId: 1,
                                    taskName: taskName.text,
                                    assignTasks: [
                                      {
                                        "temMemberId": teamsMap[team1.text],
                                        "responsibilityId": raciMap[raci1.text]
                                      },
                                      {
                                        "temMemberId": teamsMap[team2.text],
                                        "responsibilityId": raciMap[raci2.text]
                                      },
                                      {
                                        "temMemberId": teamsMap[team3.text],
                                        "responsibilityId": raciMap[raci3.text]
                                      },
                                      {
                                        "temMemberId": teamsMap[team4.text],
                                        "responsibilityId": raciMap[raci4.text]
                                      },
                                    ],
                                    milestone: mileStone.text.trim(),
                                    priority: priority.text.trim(),
                                    taskStatusId: statusMap[status.text],
                                    progress: int.tryParse(progress.text.trim()) ?? 0);
                                snackBar(context, "Done");
                                Navigator.of(context).pop();
                              } catch (e) {
                                snackBar(context, "Error $e");
                              }
                              Navigator.of(context).pop();
                              return;
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
              ),
            );
          }),
    );
  }
}
