import 'dart:io';

import 'package:co_spirit/data/api/apimanager.dart';
import 'package:co_spirit/ui/sm-sc/sheets/update_task.dart';
import 'package:co_spirit/utils/components/textFormField.dart';
import 'package:co_spirit/utils/helper_functions.dart';
import 'package:excel/excel.dart' hide Border;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../../utils/theme/appColors.dart';
import '../sm-sc/sheets/new_project.dart';
import '../sm-sc/sheets/new_subtask.dart';
import '../sm-sc/sheets/new_task_category.dart';
import '../sm-sc/sheets/new_team.dart';

class RACIViewPageSM extends StatefulWidget {
  const RACIViewPageSM({super.key});

  @override
  State<RACIViewPageSM> createState() => _RACIViewPageSMState();
}

class _RACIViewPageSMState extends State<RACIViewPageSM> {
  final LoadingStateNotifier loadingNotifier = LoadingStateNotifier();
  final ApiManager apiManager = ApiManager.getInstance();
  final TextEditingController project = TextEditingController();
  final TextEditingController category = TextEditingController();
  List projects = [];
  Map categories = {};
  Map tasks = {};
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: customAppBar(
        title: "RACI",
        context: context,
        backArrowColor: ODColorScheme.buttonColor,
        textColor: ODColorScheme.mainColor,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: width / 25),
            child: PopupMenuButton(
              color: Colors.white,
              itemBuilder: (context) {
                return <PopupMenuEntry>[
                  const PopupMenuItem(
                    textStyle: TextStyle(color: SCColorScheme.mainColor),
                    value: 0,
                    child: Text(
                      'New Project',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: SCColorScheme.mainColor),
                    ),
                  ),
                  const PopupMenuItem(
                    textStyle: TextStyle(color: SCColorScheme.mainColor),
                    value: 1,
                    child: Text(
                      'New Task Category',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: SCColorScheme.mainColor),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 2,
                    child: Text(
                      "New Task",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: SCColorScheme.mainColor),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 3,
                    child: Text(
                      "New Team Members",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: SCColorScheme.mainColor),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 4,
                    child: Text(
                      "Download",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: SCColorScheme.mainColor),
                    ),
                  ),
                ];
              },
              onSelected: (value) async {
                if (value == 4) {
                  if (project.text.isEmpty) {
                    return;
                  }

                  String? excelPath;

                  var excel = Excel.createExcel();
                  Sheet sheetObject = excel['Sheet1'];

                  sheetObject.appendRow([
                    TextCellValue("Project Name"),
                    TextCellValue("Task Category"),
                    TextCellValue("Task Name"),
                    TextCellValue("Milestone"),
                    TextCellValue("RACI"),
                    TextCellValue("progress"),
                    TextCellValue("Status"),
                    TextCellValue("Comments"),
                  ]);
                  for (var projectCategory in categories[project.text]) {
                    for (var task in tasks["${project.text}-$projectCategory"]) {
                      sheetObject.appendRow([
                        TextCellValue(project.text),
                        TextCellValue(projectCategory),
                        TextCellValue(task["taskName"] ?? "N/A"),
                        TextCellValue(task["milestone"] ?? "N/A"),
                        TextCellValue(
                          task["taskMember"]
                              .map((e) => "${e["memberNAme"]} - ${e["responsibility"]}")
                              .toList()
                              .join(" \n"),
                        ),
                        IntCellValue(task["progress"] ?? 0),
                        TextCellValue(task["status"] ?? "N/A"),
                        TextCellValue(task["comments"].join(" \n") ?? "N/A"),
                      ]);
                    }
                  }
                  var fileBytes = excel.save();

                  final res = await FilePicker.platform
                      .getDirectoryPath(dialogTitle: "Select save directory");

                  print("before");
                  if (res != null) {
                    excelPath = res.toString();
                    File(join(excelPath, "output.xlsx"))
                      ..createSync(recursive: true)
                      ..writeAsBytesSync(fileBytes ?? [], flush: true);
                  }
                  print("after");
                  snackBar(context, "Done");
                  return;
                }
                showModalBottomSheet(
                  backgroundColor: Colors.white,
                  isScrollControlled: true,
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.90,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  context: context,
                  builder: (context) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Icon(Icons.horizontal_rule_rounded),
                      ),
                      if (value == 0) const Flexible(child: NewProjectSheet()),
                      if (value == 1) const Flexible(child: NewTaskCategorySheet()),
                      if (value == 2) const Flexible(child: NewSubTaskSheet()),
                      if (value == 3) const Flexible(child: NewTeamSheet()),
                    ],
                  ),
                );
              },
              icon: const Icon(
                Icons.add_circle_outline,
                color: ODColorScheme.buttonColor,
              ),
            ),
          )
        ],
      ),
      body: ListenableBuilder(
        listenable: loadingNotifier,
        builder: (context, child) {
          if (loadingNotifier.loading) {
            raciList(apiManager, loadingNotifier);
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

          projects = loadingNotifier.response![0];
          categories = loadingNotifier.response![1];
          tasks = loadingNotifier.response![2];

          return Padding(
            padding: EdgeInsets.all(width / 25),
            child: Table(
              children: [
                TableRow(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                      padding: EdgeInsets.symmetric(vertical: width / 30),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Expanded(
                                child: Text(
                                  "Project",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16, color: ODColorScheme.mainColor),
                                ),
                              ),
                              Flexible(
                                flex: 3,
                                child: OpportunityDropDownMenu(
                                  fieldName: "",
                                  dropDownOptions: projects,
                                  selection: project,
                                  textColor: SCColorScheme.mainColor,
                                  callback: () => setState(() => category.clear()),
                                ),
                              )
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Expanded(
                                child: Text(
                                  "Category",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16, color: ODColorScheme.mainColor),
                                ),
                              ),
                              Flexible(
                                flex: 3,
                                child: RaciDropDownMenu(
                                  fieldName: "",
                                  dropDownOptions: categories[project.text] ?? [],
                                  selection: category,
                                  textColor: SCColorScheme.mainColor,
                                  callback: () => setState(() {}),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Container(
                      color: Colors.grey.shade300,
                      padding: EdgeInsets.symmetric(vertical: width / 25),
                      child: const Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Task",
                              textAlign: TextAlign.center,
                            ),
                          ),
                          // Text("Milestone"),
                          Expanded(
                              child: Text(
                            "Progress",
                            textAlign: TextAlign.start,
                          )),
                          Expanded(child: Text("Status")),
                          Expanded(child: Text("Milestone"))
                        ],
                      ),
                    )
                  ],
                ),
                if (project.text.isNotEmpty &&
                    category.text.isNotEmpty &&
                    tasks.containsKey("${project.text}-${category.text}"))
                  ...tasks["${project.text}-${category.text}"]
                      .map(
                        (e) => TableRow(
                          children: [
                            Container(
                              // padding: EdgeInsets.symmetric(vertical: width / 35),
                              decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  color: Colors.white),
                              child: Theme(
                                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                                  child: ExpansionTile(
                                    trailing: SizedBox(
                                      width: width * 0.25,
                                      child: Text(
                                        e["milestone"] ?? "N/A ",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    title: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                              flex: 2,
                                              child: Text(
                                                e["taskName"],
                                                textAlign: TextAlign.center,
                                              )),
                                          Expanded(
                                              flex: 2,
                                              child: Text(
                                                "${e["progress"] ?? 0}%",
                                                textAlign: TextAlign.center,
                                              )),
                                          Expanded(
                                              flex: 2,
                                              child: Text(
                                                e["status"] ?? "N/A ",
                                                textAlign: TextAlign.center,
                                              )),
                                        ]),
                                    children: [
                                      // Container(
                                      //   padding: EdgeInsets.symmetric(vertical: width / 35),
                                      //   decoration: BoxDecoration(
                                      //       border: Border(
                                      //         top: BorderSide(
                                      //           color: Colors.grey.shade300,
                                      //         ),
                                      //       ),
                                      //       color: Colors.white),
                                      //   child: Row(
                                      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      //     children: [
                                      //       const Text("Task Category:"),
                                      //       Text(e["category"])
                                      //     ],
                                      //   ),
                                      // ),
                                      if (e["taskMember"].isNotEmpty)
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical: width / 35),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border(
                                              top: BorderSide(
                                                color: Colors.grey.shade300,
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              const Text("RACI:"),
                                              Text(
                                                e["taskMember"]
                                                    .map((e) =>
                                                        "${e["memberNAme"]} - ${e["responsibility"]}")
                                                    .toList()
                                                    .join("\n"),
                                              ),
                                            ],
                                          ),
                                        ),
                                      Container(
                                        padding: EdgeInsets.symmetric(vertical: width / 35),
                                        width: width * 0.25,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border(
                                            top: BorderSide(
                                              color: Colors.grey.shade300,
                                            ),
                                          ),
                                        ),
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            showModalBottomSheet(
                                              backgroundColor: Colors.white,
                                              isScrollControlled: true,
                                              constraints: BoxConstraints(
                                                maxHeight:
                                                    MediaQuery.of(context).size.height * 0.90,
                                              ),
                                              shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.vertical(
                                                  top: Radius.circular(30),
                                                ),
                                              ),
                                              clipBehavior: Clip.antiAliasWithSaveLayer,
                                              context: context,
                                              builder: (context) => Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(vertical: 16),
                                                    child: Icon(Icons.horizontal_rule_rounded),
                                                  ),
                                                  Flexible(
                                                      child: UpdateTaskSheet(
                                                    loadingNotifier: loadingNotifier,
                                                    id: e["id"],
                                                    projectName: project.text,
                                                    taskCategory: category.text,
                                                    taskName: e["taskName"],
                                                    progress: e["progress"].toString(),
                                                    status: e["status"],
                                                    milestone: e["milestone"],
                                                    priority: e["priority"],
                                                    teams: e["taskMember"],
                                                  ))
                                                ],
                                              ),
                                            );
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
                                              style:
                                                  Theme.of(context).textTheme.titleSmall!.copyWith(
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
                              ),
                            )
                          ],
                        ),
                      )
                      .toList(),
                TableRow(
                  children: [
                    Container(
                      height: 15,
                      padding: EdgeInsets.symmetric(vertical: width / 35),
                      decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                          ),
                          color: Colors.white),
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
