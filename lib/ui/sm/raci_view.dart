import 'package:co_spirit/utils/components/textFormField.dart';
import 'package:co_spirit/utils/helper_functions.dart';
import 'package:flutter/material.dart';

import '../../utils/theme/appColors.dart';

class RACIViewPage extends StatelessWidget {
  const RACIViewPage({super.key});

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
      body: Padding(
        padding: EdgeInsets.all(width / 25),
        child: Table(
          children: [
            TableRow(children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                padding: EdgeInsets.symmetric(vertical: width / 30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: const Text(
                        "Project",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: ODColorScheme.mainColor),
                      ),
                    ),
                    Flexible(
                        flex: 3,
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
            ]),
            TableRow(children: [
              Container(
                color: Colors.grey.shade300,
                padding: EdgeInsets.symmetric(vertical: width / 25),
                child: const Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Project",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Text("Milestone"),
                    Expanded(
                        child: Text(
                      "Progress",
                      textAlign: TextAlign.start,
                    )),
                    Expanded(child: Text("Status"))
                  ],
                ),
              )
            ]),
            TableRow(children: [
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
                    padding: EdgeInsets.symmetric(vertical: 0.0),
                    child: ExpansionTile(
                      title: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                        Expanded(
                            flex: 2,
                            child: Text(
                              "AGL",
                              textAlign: TextAlign.center,
                            )),
                        Expanded(
                            flex: 2,
                            child: Text(
                              "70%",
                              textAlign: TextAlign.center,
                            )),
                        Expanded(
                            flex: 2,
                            child: Text(
                              "In progress",
                              textAlign: TextAlign.center,
                            )),
                      ]),
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: width / 35),
                          decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              color: Colors.white),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("Project1"),
                              Text("Project1"),
                              Text("Project1"),
                              Text("Project1")
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: width / 35),
                          decoration: BoxDecoration(color: Colors.white),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("Project2"),
                              Text("Project2"),
                              Text("Project2"),
                              Text("Project2")
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ]),
            TableRow(children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: width / 35),
                decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(15), bottomLeft: Radius.circular(15)),
                    color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [Text("Project"), Text("Project"), Text("Project"), Text("Project")],
                ),
              )
            ])
          ],
        ),
      ),
    );
  }
}
