import 'package:co_spirit/data/api/apimanager.dart';
import 'package:co_spirit/utils/helper_functions.dart';
import 'package:co_spirit/utils/theme/appColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/components.dart';

class ProjectsOverviewNeo extends StatefulWidget {
  final bool isSm;
  const ProjectsOverviewNeo({Key? key, required this.isSm}) : super(key: key);

  @override
  State<ProjectsOverviewNeo> createState() => _ProjectsOverviewNeoState();
}

class _ProjectsOverviewNeoState extends State<ProjectsOverviewNeo> {
  final LoadingStateNotifier loadingNotifier = LoadingStateNotifier();
  final ApiManager apiManager = ApiManager.getInstance();
  int color = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SMColorScheme.background,
      body: RefreshIndicator(
        onRefresh: () async => loadingNotifier.change(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0),
          child: ListenableBuilder(
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

              List<Widget> output = [SizedBox(height: 20)];

              for (var project in tasks.keys) {
                output.add(Text(
                  "$project:",
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
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
                                    style:
                                        const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
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
                                        task["taskMember"]
                                            .map((e) =>
                                                "${e["memberNAme"]} - ${e["responsibility"]}")
                                            .toList()
                                            .join("\n"),
                                      ),
                                    ),
                                ],
                              ),
                            )),
                    child: TaskCard(
                      taskName: task["taskName"],
                      status: task["status"] ?? "N/A",
                      progress: task["progress"] ?? 0,
                    ),
                  ));
                  temp.add(const SizedBox(width: 16));
                }
                temp.removeLast();
                color++;
                output.add(
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: color % 2 == 0
                              ? SMColorScheme.third.withOpacity(0.45)
                              : SMColorScheme.main.withOpacity(0.45)),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: temp,
                        ),
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
            },
          ),
        ),
      ),
    );
  }
}
