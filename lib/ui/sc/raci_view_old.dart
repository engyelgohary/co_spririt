import 'package:co_spirit/data/api/apimanager.dart';
import 'package:co_spirit/ui/sc/new_subtask.dart';
import 'package:co_spirit/ui/sc/new_task.dart';
import 'package:co_spirit/ui/sc/new_task_category.dart';
import 'package:co_spirit/ui/sc/new_team.dart';
import 'package:co_spirit/utils/components/textFormField.dart';
import 'package:co_spirit/utils/helper_functions.dart';
import 'package:flutter/material.dart';

import '../../utils/theme/appColors.dart';

class RACIPageSC extends StatefulWidget {
  RACIPageSC({super.key});

  @override
  State<RACIPageSC> createState() => _RACIPageSCState();
}

class _RACIPageSCState extends State<RACIPageSC> {
  final LoadingStateNotifier loadingNotifier = LoadingStateNotifier();
  final ApiManager apiManager = ApiManager.getInstance();
  final TextEditingController project = TextEditingController();
  final TextEditingController category = TextEditingController();
  Map projects = {};
  Map categories = {};

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
              padding: const EdgeInsets.only(right: 16.0),
              child: PopupMenuButton(
                icon: const Icon(Icons.add_circle_outline),
                itemBuilder: (context) => <PopupMenuEntry>[
                  const PopupMenuItem(
                    value: 0,
                    child: Text('New Task Category'),
                  ),
                  const PopupMenuItem(
                    value: 1,
                    child: Text('New Task'),
                  ),
                  const PopupMenuItem(
                    value: 2,
                    child: Text("New Subtask"),
                  ),
                  const PopupMenuItem(
                    value: 3,
                    child: Text("New Team Members"),
                  ),
                  const PopupMenuItem(
                    value: 4,
                    child: Text("Download"),
                  ),
                ],
                onSelected: (value) {
                  if (value == 4) {
                    snackBar(context, "not implemented");
                    return;
                  }
                  showModalBottomSheet(
                    backgroundColor: Colors.white,
                    isScrollControlled: true,
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
                        if (value == 0) const Flexible(child: NewTaskCategorySheetSC()),
                        if (value == 1) const Flexible(child: NewTaskSheetSC()),
                        if (value == 2) const Flexible(child: NewSubTaskSheetSC()),
                        if (value == 3) const Flexible(child: NewTeamSheetSC()),
                      ],
                    ),
                  );
                },
              ),
            ),
          ]),
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
            projects = loadingNotifier.response![0];
            categories = loadingNotifier.response![1];
            print(projects);
            print(categories);

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: width / 25),
                  child: Row(
                    children: [
                      const Flexible(
                        child: Text(
                          "Project   ",
                          style: TextStyle(fontSize: 16, color: ODColorScheme.mainColor),
                        ),
                      ),
                      Flexible(
                          child: OpportunityDropDownMenu(
                        fieldName: "",
                        controller: TextEditingController(),
                        dropDownOptions: projects.keys.toList(),
                        selection: project,
                        textColor: SCColorScheme.mainColor,
                        callback: () => setState(() {}),
                      ))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: width / 25),
                  child: Row(
                    children: [
                      const Text("Category",
                          style: TextStyle(fontSize: 16, color: ODColorScheme.mainColor)),
                      Flexible(
                          child: OpportunityDropDownMenu(
                        fieldName: "",
                        controller: TextEditingController(),
                        dropDownOptions: project.text.trim().isEmpty
                            ? []
                            : categories[project.text].keys.toList(),
                        selection: category,
                        textColor: SCColorScheme.mainColor,
                      ))
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width / 25, vertical: width / 30),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("AGL", style: TextStyle(fontSize: 16, color: SCColorScheme.mainColor)),
                        Icon(
                          Icons.chat_outlined,
                          color: ODColorScheme.buttonColor,
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  color: SCColorScheme.mainColor,
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.only(left: width / 25, top: width / 30, bottom: width / 30),
                    child: const Text("AGL", style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
                Container(
                  color: SCColorScheme.secondColor,
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.only(left: width / 25, top: width / 30, bottom: width / 30),
                    child: const Text("AGL", style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
                Container(
                  color: SCColorScheme.thirdColor,
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.only(left: width / 25, top: width / 30, bottom: width / 30),
                    child: const Text("AGL", style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.only(top: width / 30, bottom: width / 30),
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(color: Colors.green.shade700),
                            bottom: const BorderSide(color: SCColorScheme.fifthColor),
                          ),
                          color: SCColorScheme.forthColor,
                        ),
                        child: const Text(
                          textAlign: TextAlign.center,
                          "title",
                          style: TextStyle(fontSize: 16, color: SCColorScheme.mainColor),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        padding:
                            EdgeInsets.only(left: width / 25, top: width / 30, bottom: width / 30),
                        decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(color: Colors.green),
                            bottom: BorderSide(color: SCColorScheme.forthColor),
                          ),
                          color: Colors.white,
                        ),
                        child: const Text(
                          "data",
                          style: TextStyle(fontSize: 16, color: SCColorScheme.mainColor),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.only(top: width / 30, bottom: width / 30),
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(color: Colors.green.shade700),
                            bottom: const BorderSide(color: SCColorScheme.fifthColor),
                          ),
                          color: SCColorScheme.forthColor,
                        ),
                        child: const Text(
                          textAlign: TextAlign.center,
                          "title",
                          style: TextStyle(fontSize: 16, color: SCColorScheme.mainColor),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        padding:
                            EdgeInsets.only(left: width / 25, top: width / 30, bottom: width / 30),
                        decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(color: Colors.green),
                            bottom: BorderSide(color: SCColorScheme.forthColor),
                          ),
                          color: Colors.white,
                        ),
                        child: const Text(
                          "data",
                          style: TextStyle(fontSize: 16, color: SCColorScheme.mainColor),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.only(top: width / 30, bottom: width / 30),
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(color: Colors.green.shade700),
                            bottom: const BorderSide(color: SCColorScheme.fifthColor),
                          ),
                          color: SCColorScheme.forthColor,
                        ),
                        child: const Text(
                          textAlign: TextAlign.center,
                          "title",
                          style: TextStyle(fontSize: 16, color: SCColorScheme.mainColor),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        padding:
                            EdgeInsets.only(left: width / 25, top: width / 30, bottom: width / 30),
                        decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(color: Colors.green),
                            bottom: BorderSide(color: SCColorScheme.forthColor),
                          ),
                          color: Colors.white,
                        ),
                        child: const Text(
                          "data",
                          style: TextStyle(fontSize: 16, color: SCColorScheme.mainColor),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.only(top: width / 30, bottom: width / 30),
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(color: Colors.green.shade700),
                            bottom: const BorderSide(color: SCColorScheme.fifthColor),
                          ),
                          color: SCColorScheme.forthColor,
                        ),
                        child: const Text(
                          textAlign: TextAlign.center,
                          "title",
                          style: TextStyle(fontSize: 16, color: SCColorScheme.mainColor),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        padding:
                            EdgeInsets.only(left: width / 25, top: width / 30, bottom: width / 30),
                        decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(color: Colors.green),
                            bottom: BorderSide(color: SCColorScheme.forthColor),
                          ),
                          color: Colors.white,
                        ),
                        child: const Text(
                          "data",
                          style: TextStyle(fontSize: 16, color: SCColorScheme.mainColor),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.only(top: width / 30, bottom: width / 30),
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(color: Colors.green.shade700),
                            bottom: const BorderSide(color: SCColorScheme.fifthColor),
                          ),
                          color: SCColorScheme.forthColor,
                        ),
                        child: const Text(
                          textAlign: TextAlign.center,
                          "title",
                          style: TextStyle(fontSize: 16, color: SCColorScheme.mainColor),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        padding:
                            EdgeInsets.only(left: width / 25, top: width / 30, bottom: width / 30),
                        decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(color: Colors.green),
                            bottom: BorderSide(color: SCColorScheme.forthColor),
                          ),
                          color: Colors.white,
                        ),
                        child: const Text(
                          "data",
                          style: TextStyle(fontSize: 16, color: SCColorScheme.mainColor),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            );
          }),
    );
  }
}
