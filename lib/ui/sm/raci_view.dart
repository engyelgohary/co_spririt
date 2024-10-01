import 'package:co_spirit/data/api/apimanager.dart';
import 'package:co_spirit/utils/components/textFormField.dart';
import 'package:co_spirit/utils/helper_functions.dart';
import 'package:flutter/material.dart';

import '../../utils/theme/appColors.dart';

class RACIViewPage extends StatefulWidget {
  const RACIViewPage({super.key});

  @override
  State<RACIViewPage> createState() => _RACIViewPageState();
}

class _RACIViewPageState extends State<RACIViewPage> {
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
                                                e["projectName"],
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
                                      Container(
                                        padding: EdgeInsets.symmetric(vertical: width / 35),
                                        decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Colors.grey.shade300,
                                              ),
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
                                          children: [Text("Task:"), Text(e["taskName"])],
                                        ),
                                      ),
                                      if (e["taskMember"].isNotEmpty)
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical: width / 35),
                                          decoration: const BoxDecoration(color: Colors.white),
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
