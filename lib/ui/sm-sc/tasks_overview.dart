import 'package:co_spirit/data/api/apimanager.dart';
import 'package:co_spirit/utils/helper_functions.dart';
import 'package:co_spirit/utils/theme/appColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/components.dart';

class TasksOverview extends StatefulWidget {
  final bool isSm;
  const TasksOverview({Key? key, required this.isSm}) : super(key: key);

  @override
  State<TasksOverview> createState() => _TasksOverviewState();
}

class _TasksOverviewState extends State<TasksOverview> {
  final LoadingStateNotifier loadingNotifier = LoadingStateNotifier();
  final ApiManager apiManager = ApiManager.getInstance();
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 28.0, 15.0, 0),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  "assets/images/logo-corelia.png",
                  width: 110.w,
                  height: 56.h,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search, color: Color(0xFF000080)),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.message_outlined, color: Color(0xFF000080)),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF000080)),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            ListenableBuilder(
                listenable: loadingNotifier,
                builder: (context, child) {
                  if (loadingNotifier.loading) {
                    homeList(apiManager, loadingNotifier);
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
                  final Map tasks = loadingNotifier.response![0];
                  // print(tasks);
                  List<Widget> output = [];
                  print(tasks);
                  // return SingleChildScrollView(child: Column(children: output,),);
                  for (var project in tasks.keys) {
                    output.add(Text(
                      "$project:",
                      style: const TextStyle(
                          fontSize: 24,
                          color: SCColorScheme.mainColor,
                          fontWeight: FontWeight.bold),
                    ));
                    output.add(const SizedBox(height: 8));

                    List<Widget> temp = [];

                    for (var task in tasks[project]) {
                      temp.add(GestureDetector(
                        onTap: () => showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  backgroundColor: Colors.white,
                                  content: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        task["taskName"],
                                        style: const TextStyle(
                                            fontSize: 20, fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      const Text(
                                        "Project Name:",
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8, top: 4),
                                        child: Text(task["projectName"] ?? "N/A"),
                                      ),
                                      const Text(
                                        "Category:",
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8, top: 4),
                                        child: Text(task["category"] ?? "n/a"),
                                      ),
                                      const Text(
                                        "Milestone:",
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8, top: 4),
                                        child: Text(task["milestone"] ?? "N/A"),
                                      ),
                                      const Text(
                                        "priority:",
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8, top: 4),
                                        child: Text(task["priority"] ?? "N/A"),
                                      ),
                                      const Text(
                                        "progress:",
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8, top: 4),
                                        child: Text("${task["progress"]}%"),
                                      ),
                                      const Text(
                                        "status:",
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8, top: 4),
                                        child: Text(task["status"] ?? "N/A"),
                                      ),
                                      const Text(
                                        "Team members:",
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                      ),
                                      if (task["taskMember"].isNotEmpty)
                                        Padding(
                                            padding: const EdgeInsets.only(left: 8, top: 4),
                                            child: Text(
                                                // "${task["taskMember"][0]["memberNAme"]}:     ${task["taskMember"][0]["responsibility"]}\n${task["taskMember"][1]["memberNAme"]}:     ${task["taskMember"][1]["responsibility"]}\n${task["taskMember"][2]["memberNAme"]}:     ${task["taskMember"][2]["responsibility"]}\n${task["taskMember"][3]["memberNAme"]}:     ${task["taskMember"][3]["responsibility"]}"

                                                task["taskMember"]
                                                    .map((e) =>
                                                        "${e["memberNAme"]} - ${e["responsibility"]}")
                                                    .toList()
                                                    .join("\n"))),
                                    ],
                                  ),
                                )),
                        child: TaskCard(
                          taskName: task["taskName"],
                          status: task["status"] ?? "N/A",
                          progress: task["progress"] ?? 0,
                        ),
                      ));
                      temp.add(const SizedBox(width: 8));
                    }
                    output.add(
                      Flexible(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: temp,
                          ),
                        ),
                      ),
                    );
                    output.add(const SizedBox(height: 16));
                  }
                  return SingleChildScrollView(
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: output,
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
      bottomNavigationBar: widget.isSm
          ? BottomNavBarSM(
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
            )
          : BottomNavBar(
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
            ),
    );
  }
}
