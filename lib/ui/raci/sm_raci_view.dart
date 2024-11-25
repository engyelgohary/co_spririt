import 'package:co_spirit/core/components/appbar.dart';
import 'package:co_spirit/core/components/helper_functions.dart';
import 'package:co_spirit/core/components/text_form_field.dart';
import 'package:co_spirit/data/api/apimanager.dart';
import 'package:co_spirit/data/repository/remote_data_source.dart';
import 'package:co_spirit/ui/raci/cubit/raci_cubit.dart';
import 'package:co_spirit/ui/sheets/update_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_colors.dart';

class SMRACIViewPage extends StatefulWidget {
  const SMRACIViewPage({super.key});

  @override
  State<SMRACIViewPage> createState() => _SMRACIViewPageState();
}

class _SMRACIViewPageState extends State<SMRACIViewPage> {
  final TextEditingController project = TextEditingController();
  final TextEditingController category = TextEditingController();

  RACICubit raciCubit = RACICubit(
    smDataSource: SMDataSourceRemote(apiManager: ApiManager.getInstance()),
  );

  List projects = [];
  Map categories = {};
  Map tasks = {};

  @override
  void initState() {
    super.initState();
    raciCubit.getRACI();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: customAppBarNeo(
        title: "RACI",
        context: context,
        textColor: Colors.black,
        backgroundColor: SMColorScheme.background,
      ),
      backgroundColor: SMColorScheme.background,
      body: BlocBuilder<RACICubit, RACIState>(
        bloc: raciCubit,
        builder: (context, state) {
          if (state is RACILoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RACISuccessfulState) {
            projects = state.response[0];
            categories = state.response[1];
            tasks = state.response[2];

            return Padding(
              padding: EdgeInsets.all(width / 25),
              child: SingleChildScrollView(
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
                                      style:
                                          TextStyle(fontSize: 16, color: ODColorScheme.mainColor),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 3,
                                    child: RaciDropDownMenu(
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
                                      style:
                                          TextStyle(fontSize: 16, color: ODColorScheme.mainColor),
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
                          color: SMColorScheme.background,
                          padding: EdgeInsets.symmetric(vertical: width / 25),
                          child: const Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Task",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(child: Text("Progress", textAlign: TextAlign.center)),
                              Expanded(child: Text("Status", textAlign: TextAlign.center)),
                              Expanded(child: Text("Milestone", textAlign: TextAlign.center))
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
                                  decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      color: Colors.white),
                                  child: Theme(
                                    data: Theme.of(context)
                                        .copyWith(dividerColor: Colors.transparent),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 0.0),
                                      child: ExpansionTile(
                                        trailing: SizedBox(
                                          width: width * 0.25,
                                          child: Text(
                                            e["milestone"] ?? "N/A ",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontSize: 16, fontWeight: FontWeight.w400),
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
                                                  const Text("Comments:"),
                                                  Text(e["comments"].join("\n"))
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
                                                print(e);
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
                                                  builder: (context) => Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(vertical: 16),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        const Padding(
                                                            padding:
                                                                EdgeInsets.symmetric(vertical: 16),
                                                            child: Icon(
                                                                Icons.horizontal_rule_rounded)),
                                                        Flexible(
                                                          child: UpdateTaskSheet(
                                                            id: e["id"],
                                                            projectName: e["projectName"],
                                                            taskCategory: e["category"],
                                                            taskName: e["taskName"],
                                                            progress: e["progress"],
                                                            status: e["status"],
                                                            milestone: e["milestone"],
                                                            priority: e["priority"],
                                                            teams: e["taskMember"],
                                                            raciCubit: raciCubit,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                padding: const EdgeInsets.symmetric(vertical: 16),
                                                backgroundColor: ODColorScheme.buttonColor,
                                                shape: const RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(30),
                                                  ),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Update',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall!
                                                      .copyWith(
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
                            color: Colors.white,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }
          return Center(
            child: buildErrorIndicator(
              "Some error occurred, Please try again.",
              () => raciCubit.getRACI(),
            ),
          );
        },
      ),
    );
  }
}