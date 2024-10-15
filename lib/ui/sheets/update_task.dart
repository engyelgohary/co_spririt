import 'package:co_spirit/core/app_util.dart';
import 'package:co_spirit/core/components/helper_functions.dart';
import 'package:co_spirit/core/components/text_form_field.dart';
import 'package:co_spirit/core/theme/app_colors.dart';
import 'package:co_spirit/data/api/apimanager.dart';
import 'package:flutter/material.dart';

class UpdateTaskSheet extends StatefulWidget {
  final dynamic projectName;
  final dynamic taskCategory;
  final dynamic taskName;
  final dynamic progress;
  final dynamic priority;
  final dynamic milestone;
  final dynamic status;
  final dynamic teams;
  final dynamic id;
  final dynamic loadingNotifier;

  const UpdateTaskSheet({
    super.key,
    required this.id,
    required this.projectName,
    required this.taskCategory,
    required this.taskName,
    required this.progress,
    required this.status,
    required this.milestone,
    required this.priority,
    required this.teams,
    required this.loadingNotifier,
  });

  @override
  State<UpdateTaskSheet> createState() => _NewProjectSheetState();
}

class _NewProjectSheetState extends State<UpdateTaskSheet> {
  final projectName = TextEditingController();
  final taskCategory = TextEditingController();
  final taskName = TextEditingController();
  final subTask = TextEditingController();
  final milestone = TextEditingController();
  final priority = TextEditingController();
  final progress = TextEditingController();
  final status = TextEditingController();
  final ApiManager apiManager = ApiManager.getInstance();
  final LoadingStateNotifier loadingNotifier = LoadingStateNotifier();
  Map projectsMap = {};
  Map projectsSubTaskMap = {};
  Map projectsTasksMap = {};
  Map teamsMap = {};
  Map statusMap = {};
  Map raciMap = {"R": 1, "ِِA": 2, "ِِC": 3, "ِِI": 4};
  int count = 1;
  List<TextEditingController> teams = [];
  List<TextEditingController> responsibilities = [];
  List<Widget> rows = [];

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
            print("object");
            projectsMap = loadingNotifier.response![0];
            projectsSubTaskMap = loadingNotifier.response![1];
            projectsTasksMap = loadingNotifier.response![2];
            teamsMap = loadingNotifier.response![3];
            statusMap = loadingNotifier.response![4];

            if (rows.isEmpty) {
              projectName.text = widget.projectName;
              taskCategory.text = widget.taskCategory;
              taskName.text = widget.taskName;
              milestone.text = widget.milestone;
              priority.text = widget.priority;
              progress.text = widget.progress;
              status.text = widget.status;

              for (var team in widget.teams) {
                teams.add(TextEditingController(text: team["memberNAme"]));
                responsibilities.add(TextEditingController(text: team["responsibility"]));
                rows.add(
                  Row(
                    children: [
                      Expanded(
                        child: OpportunityDropDownMenu(
                          fieldName: "",
                          selection: teams[count - 1],
                          dropDownOptions: teamsMap.keys.toList(),
                          textColor: ODColorScheme.mainColor,
                        ),
                      ),
                      Expanded(
                        child: OpportunityDropDownMenu(
                          fieldName: "",
                          selection: responsibilities[count - 1],
                          dropDownOptions: raciMap.keys.toList(),
                          textColor: ODColorScheme.mainColor,
                        ),
                      )
                    ],
                  ),
                );
                count++;
              }
            }
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  OpportunityDropDownMenu(
                    fieldName: 'Project',
                    selection: projectName,
                    dropDownOptions: projectsMap.keys.toList(),
                    textColor: ODColorScheme.mainColor,
                    callback: () => setState(() {}),
                  ),
                  OpportunityDropDownMenu(
                    fieldName: 'Task Category',
                    selection: taskCategory,
                    dropDownOptions: projectName.text.trim().isEmpty
                        ? []
                        : projectsSubTaskMap[projectName.text].keys.toList(),
                    textColor: ODColorScheme.mainColor,
                    callback: () => setState(() {}),
                  ),
                  OpportunityTextFormField(
                    fieldName: 'Task',
                    controller: taskName,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: width / 15),
                          child: const Text(
                            "Assigned Team",
                            style: TextStyle(fontSize: 16, color: ODColorScheme.mainColor),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: width / 15, right: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "RACI",
                                style: TextStyle(fontSize: 16, color: ODColorScheme.mainColor),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      if (count == 1) {
                                        return;
                                      }
                                      setState(() {
                                        teams.removeLast();
                                        responsibilities.removeLast();
                                        rows.removeLast();
                                        count--;
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.remove_circle,
                                      color: ODColorScheme.buttonColor,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        teams.add(TextEditingController());
                                        responsibilities.add(TextEditingController());
                                        rows.add(
                                          Row(
                                            children: [
                                              Expanded(
                                                child: OpportunityDropDownMenu(
                                                  fieldName: "",
                                                  selection: teams[count - 1],
                                                  dropDownOptions: teamsMap.keys.toList(),
                                                  textColor: ODColorScheme.mainColor,
                                                ),
                                              ),
                                              Expanded(
                                                child: OpportunityDropDownMenu(
                                                  fieldName: "",
                                                  selection: responsibilities[count - 1],
                                                  dropDownOptions: raciMap.keys.toList(),
                                                  textColor: ODColorScheme.mainColor,
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      });
                                      count++;
                                    },
                                    icon: const Icon(
                                      Icons.add_circle,
                                      color: ODColorScheme.buttonColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  ...rows,
                  OpportunityTextFormField(
                    fieldName: 'Milestone',
                    controller: milestone,
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
                    textColor: ODColorScheme.mainColor,
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
                              List assignTasks = [];
                              if (projectName.text.trim().isEmpty ||
                                  taskCategory.text.trim().isEmpty ||
                                  taskName.text.trim().isEmpty ||
                                  projectName.text.trim().isEmpty ||
                                  priority.text.trim().isEmpty ||
                                  progress.text.trim().isEmpty ||
                                  status.text.trim().isEmpty ||
                                  milestone.text.trim().isEmpty) {
                                return;
                              }

                              for (var i = 0; i < teams.length; i++) {
                                if (teams[i].text.isEmpty || responsibilities[i].text.isEmpty) {
                                  return;
                                }
                                assignTasks.add(
                                  {
                                    "temMemberId": teamsMap[teams[i].text],
                                    "responsibilityId": raciMap[responsibilities[i].text]
                                  },
                                );
                              }

                              loadingIndicatorDialog(context);
                              try {
                                await apiManager.UpdateTask(
                                    id: widget.id,
                                    projectId: projectsMap[projectName.text],
                                    categoryId: projectsSubTaskMap[projectName.text]
                                        [taskCategory.text],
                                    subTaskId: 1,
                                    taskName: taskName.text,
                                    assignTasks: assignTasks,
                                    milestone: milestone.text.trim(),
                                    priority: priority.text.trim(),
                                    taskStatusId: statusMap[status.text],
                                    progress: int.tryParse(progress.text.trim()) ?? 0);
                                snackBar(context, "Done");
                                Navigator.of(context).pop();
                                widget.loadingNotifier.change();
                              } catch (e) {
                                snackBar(context, "Error $e");
                              }
                              Navigator.of(context).pop();
                              return;
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
                                'Update',
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
