import 'package:co_spirit/data/api/apimanager.dart';
import 'package:co_spirit/utils/components/textFormField.dart';
import 'package:co_spirit/utils/helper_functions.dart';
import 'package:flutter/material.dart';

import '../../utils/theme/appColors.dart';
import 'sheets/new_project.dart';
import 'sheets/new_solution.dart';
import 'sheets/new_subtask.dart';
import 'sheets/new_task.dart';
import 'sheets/new_task_category.dart';
import 'sheets/new_team.dart';

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
  Map projects = {};
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
                    // const PopupMenuItem(
                    //   value: 2,
                    //   child: Text(
                    //     'New Task',
                    //     textAlign: TextAlign.center,
                    //     style: TextStyle(color: SCColorScheme.mainColor),
                    //   ),
                    // ),
                    const PopupMenuItem(
                      value: 3,
                      child: Text(
                        "New Task",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: SCColorScheme.mainColor),
                      ),
                    ),
                    const PopupMenuItem(
                      value: 4,
                      child: Text(
                        "New Team Members",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: SCColorScheme.mainColor),
                      ),
                    ),
                    // const PopupMenuItem(
                    //   value: 5,
                    //   child: Text(
                    //     "Download",
                    //     textAlign: TextAlign.center,
                    //     style: TextStyle(color: SCColorScheme.mainColor),
                    //   ),
                    // ),
                  ];
                },
                onSelected: (value) {
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
                        if (value == 0) const Flexible(child: NewProjectSheetSM()),
                        if (value == 1) const Flexible(child: NewTaskCategorySheetSM()),
                        if (value == 2) const Flexible(child: NewTaskSheetSM()),
                        if (value == 3) const Flexible(child: NewSubTaskSheetSM()),
                        if (value == 4) const Flexible(child: NewTeamSheetSM()),
                      ],
                    ),
                  );
                },
                icon: Icon(
                  Icons.add_circle_outline,
                  color: ODColorScheme.buttonColor,
                ),
              ),
            )
          ]),
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
          tasks = loadingNotifier.response![1];
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
                      child: Row(
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
                              dropDownOptions: projects.keys.toList(),
                              selection: project,
                              textColor: SCColorScheme.mainColor,
                              callback: () => setState(
                                () {},
                              ),
                            ),
                          )
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
                if (project.text.isNotEmpty && tasks.containsKey(project.text))
                  ...tasks[project.text]
                      .map((e) => TableRow(children: [
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
                                          Expanded(
                                              flex: 2,
                                              child: Text(
                                                e["milestone"] ?? "N/A ",
                                                textAlign: TextAlign.center,
                                              )),
                                        ]),
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(vertical: width / 35),
                                        decoration: BoxDecoration(
                                            border: Border(
                                              top: BorderSide(
                                                color: Colors.grey.shade300,
                                              ),
                                            ),
                                            color: Colors.white),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [Text("Task Category:"), Text(e["category"])],
                                        ),
                                      ),
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
                                              Text("RACI:"),
                                              Text(
                                                  "${e["taskMember"][0]["memberNAme"]}:     ${e["taskMember"][0]["responsibility"]}\n${e["taskMember"][1]["memberNAme"]}:     ${e["taskMember"][1]["responsibility"]}\n${e["taskMember"][2]["memberNAme"]}:     ${e["taskMember"][2]["responsibility"]}\n${e["taskMember"][3]["memberNAme"]}:     ${e["taskMember"][3]["responsibility"]}")
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ]))
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
                              bottomRight: Radius.circular(15), bottomLeft: Radius.circular(15)),
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
