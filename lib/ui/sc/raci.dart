import 'package:co_spirit/ui/sc/new_subtask.dart';
import 'package:co_spirit/ui/sc/new_task.dart';
import 'package:co_spirit/ui/sc/new_task_category.dart';
import 'package:co_spirit/ui/sc/new_team.dart';
import 'package:co_spirit/utils/components/textFormField.dart';
import 'package:co_spirit/utils/helper_functions.dart';
import 'package:flutter/material.dart';

import '../../utils/theme/appColors.dart';

class RACIPage extends StatelessWidget {
  const RACIPage({super.key});

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
                icon: Icon(Icons.add_circle_outline),
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
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Icon(Icons.horizontal_rule_rounded),
                        ),
                        if (value == 0) Flexible(child: NewTaskCategorySheet()),
                        if (value == 1) Flexible(child: NewTaskSheet()),
                        if (value == 2) Flexible(child: NewSubTaskSheet()),
                        if (value == 3) Flexible(child: NewTeamSheet()),
                      ],
                    ),
                  );
                },
              ),
            ),
          ]),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: width / 25),
            child: Row(
              children: [
                const Text(
                  "Project   ",
                  style: TextStyle(fontSize: 16, color: ODColorScheme.mainColor),
                ),
                Flexible(
                    child: OpportunityDropDownMenu(
                  fieldName: "",
                  controller: TextEditingController(),
                  dropDownOptions: [],
                  selection: null,
                  textColor: SMColorScheme.mainColor,
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
                  dropDownOptions: [],
                  selection: null,
                  textColor: SMColorScheme.mainColor,
                ))
              ],
            ),
          ),
          Container(
            color: Colors.white,
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width / 25, vertical: width / 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("AGL", style: TextStyle(fontSize: 16, color: SMColorScheme.mainColor)),
                  Icon(
                    Icons.chat_outlined,
                    color: ODColorScheme.buttonColor,
                  )
                ],
              ),
            ),
          ),
          Container(
            color: SMColorScheme.mainColor,
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(left: width / 25, top: width / 30, bottom: width / 30),
              child: const Text("AGL", style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
          Container(
            color: SMColorScheme.secondColor,
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(left: width / 25, top: width / 30, bottom: width / 30),
              child: const Text("AGL", style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
          Container(
            color: SMColorScheme.thirdColor,
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
                      bottom: BorderSide(color: SMColorScheme.fifthColor),
                    ),
                    color: SMColorScheme.forthColor,
                  ),
                  child: const Text(
                    textAlign: TextAlign.center,
                    "title",
                    style: TextStyle(fontSize: 16, color: SMColorScheme.mainColor),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  padding: EdgeInsets.only(left: width / 25, top: width / 30, bottom: width / 30),
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Colors.green),
                      bottom: BorderSide(color: SMColorScheme.forthColor),
                    ),
                    color: Colors.white,
                  ),
                  child: const Text(
                    "data",
                    style: TextStyle(fontSize: 16, color: SMColorScheme.mainColor),
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
                      bottom: BorderSide(color: SMColorScheme.fifthColor),
                    ),
                    color: SMColorScheme.forthColor,
                  ),
                  child: const Text(
                    textAlign: TextAlign.center,
                    "title",
                    style: TextStyle(fontSize: 16, color: SMColorScheme.mainColor),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  padding: EdgeInsets.only(left: width / 25, top: width / 30, bottom: width / 30),
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Colors.green),
                      bottom: BorderSide(color: SMColorScheme.forthColor),
                    ),
                    color: Colors.white,
                  ),
                  child: const Text(
                    "data",
                    style: TextStyle(fontSize: 16, color: SMColorScheme.mainColor),
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
                      bottom: BorderSide(color: SMColorScheme.fifthColor),
                    ),
                    color: SMColorScheme.forthColor,
                  ),
                  child: const Text(
                    textAlign: TextAlign.center,
                    "title",
                    style: TextStyle(fontSize: 16, color: SMColorScheme.mainColor),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  padding: EdgeInsets.only(left: width / 25, top: width / 30, bottom: width / 30),
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Colors.green),
                      bottom: BorderSide(color: SMColorScheme.forthColor),
                    ),
                    color: Colors.white,
                  ),
                  child: const Text(
                    "data",
                    style: TextStyle(fontSize: 16, color: SMColorScheme.mainColor),
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
                      bottom: BorderSide(color: SMColorScheme.fifthColor),
                    ),
                    color: SMColorScheme.forthColor,
                  ),
                  child: const Text(
                    textAlign: TextAlign.center,
                    "title",
                    style: TextStyle(fontSize: 16, color: SMColorScheme.mainColor),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  padding: EdgeInsets.only(left: width / 25, top: width / 30, bottom: width / 30),
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Colors.green),
                      bottom: BorderSide(color: SMColorScheme.forthColor),
                    ),
                    color: Colors.white,
                  ),
                  child: const Text(
                    "data",
                    style: TextStyle(fontSize: 16, color: SMColorScheme.mainColor),
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
                      bottom: BorderSide(color: SMColorScheme.fifthColor),
                    ),
                    color: SMColorScheme.forthColor,
                  ),
                  child: const Text(
                    textAlign: TextAlign.center,
                    "title",
                    style: TextStyle(fontSize: 16, color: SMColorScheme.mainColor),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  padding: EdgeInsets.only(left: width / 25, top: width / 30, bottom: width / 30),
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Colors.green),
                      bottom: BorderSide(color: SMColorScheme.forthColor),
                    ),
                    color: Colors.white,
                  ),
                  child: const Text(
                    "data",
                    style: TextStyle(fontSize: 16, color: SMColorScheme.mainColor),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
