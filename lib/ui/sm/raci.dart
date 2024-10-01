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
      ),
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
                  textColor: SCColorScheme.mainColor,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("AGL", style: TextStyle(fontSize: 16, color: SCColorScheme.mainColor)),
                  Icon(Icons.chat_outlined)
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
                      bottom: BorderSide(color: SCColorScheme.fifthColor),
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
                  padding: EdgeInsets.only(left: width / 25, top: width / 30, bottom: width / 30),
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
                      bottom: BorderSide(color: SCColorScheme.fifthColor),
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
                  padding: EdgeInsets.only(left: width / 25, top: width / 30, bottom: width / 30),
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
                      bottom: BorderSide(color: SCColorScheme.fifthColor),
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
                  padding: EdgeInsets.only(left: width / 25, top: width / 30, bottom: width / 30),
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
                      bottom: BorderSide(color: SCColorScheme.fifthColor),
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
                  padding: EdgeInsets.only(left: width / 25, top: width / 30, bottom: width / 30),
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
                      bottom: BorderSide(color: SCColorScheme.fifthColor),
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
                  padding: EdgeInsets.only(left: width / 25, top: width / 30, bottom: width / 30),
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
      ),
    );
  }
}
