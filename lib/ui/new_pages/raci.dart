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
        backArrowColor: OAColorScheme.buttonColor,
        textColor: OAColorScheme.mainColor,
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
              padding: EdgeInsets.only(left: width / 25, top: width / 30, bottom: width / 30),
              child:
                  const Text("AGL", style: TextStyle(fontSize: 16, color: SMColorScheme.mainColor)),
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
