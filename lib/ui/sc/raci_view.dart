import 'package:co_spirit/core/components.dart';
import 'package:co_spirit/data/api/apimanager.dart';
import 'package:co_spirit/utils/components/textFormField.dart';
import 'package:co_spirit/utils/helper_functions.dart';
import 'package:flutter/material.dart';

import '../../utils/theme/appColors.dart';

class RACIViewPageSC extends StatefulWidget {
  const RACIViewPageSC({super.key});

  @override
  State<RACIViewPageSC> createState() => _RACIViewPageSCState();
}

class _RACIViewPageSCState extends State<RACIViewPageSC> {
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
      ),
      body: ListenableBuilder(
        listenable: loadingNotifier,
        builder: (context, child) {
          print("loading status: ${loadingNotifier.loading}");
          if (loadingNotifier.loading) {
            raciList(apiManager, loadingNotifier);
            return const Center(child: CircularProgressIndicator());
          } else if (loadingNotifier.response == null) {
            return Center(
              child: buildErrorIndicator(
                "Some error occurred, Please try again.",
                () => loadingNotifier.change(),
              ),
            );
          }

          print("object");
          projects = loadingNotifier.response![0];
          print("object");
          categories = loadingNotifier.response![1];
          print("object");
          tasks = loadingNotifier.response![2];
          print("object");

          return SingleChildScrollView(
            child: Padding(
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
                                  child: OpportunityDropDownMenu(
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
                    ...tasks["${project.text}-${category.text}"].map(
                      (e) {
                        final TextEditingController comment = TextEditingController();
                        return TableRow(
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
                                      ],
                                    ),
                                    children: [
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
                                      if (e["comments"].isNotEmpty)
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical: width / 35),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                top: BorderSide(
                                                  color: Colors.grey.shade300,
                                                ),
                                                bottom: BorderSide(
                                                  color: Colors.grey.shade300,
                                                ),
                                              ),
                                              color: Colors.white),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text("Comments:"),
                                              Text(e["comments"].join("\n"))
                                            ],
                                          ),
                                        ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 32, right: 32, top: 16),
                                        child: CustomInput(
                                          contentPaddingVertical: 16,
                                          fillColor: const Color.fromRGBO(241, 241, 241, 1),
                                          radius: 30,
                                          controller: comment,
                                          hint: "Write your comment  ...",
                                          textInputType: TextInputType.text,
                                          suffixIcon: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                onPressed: () async {
                                                  if (comment.text.isEmpty) {
                                                    return;
                                                  }
                                                  loadingIndicatorDialog(context);
                                                  try {
                                                    await apiManager.AddCommentToTask(
                                                      taskId: e["id"],
                                                      comment: comment.text,
                                                    );
                                                    if (context.mounted) {
                                                      snackBar(context, "Done");
                                                      loadingNotifier.change();
                                                    }
                                                  } catch (e) {
                                                    if (context.mounted) {
                                                      snackBar(context, "Error $e");
                                                    }
                                                  }
                                                  if (context.mounted) {
                                                    Navigator.of(context).pop();
                                                  }
                                                },
                                                icon: const Icon(
                                                  Icons.send,
                                                  color: ODColorScheme.buttonColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    ).toList(),
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
            ),
          );
        },
      ),
    );
  }
}
