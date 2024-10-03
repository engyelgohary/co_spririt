import 'package:co_spirit/data/api/apimanager.dart';
import 'package:co_spirit/ui/sm/menu.dart';
import 'package:co_spirit/ui/sm/raci_view.dart';
import 'package:co_spirit/ui/sm/solutions.dart';
import 'package:co_spirit/utils/helper_functions.dart';
import 'package:co_spirit/utils/theme/appColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/components.dart';

class TasksOverviewSM extends StatefulWidget {
  const TasksOverviewSM({Key? key}) : super(key: key);

  @override
  State<TasksOverviewSM> createState() => _TasksOverviewSMState();
}

class _TasksOverviewSMState extends State<TasksOverviewSM> {
  final LoadingStateNotifier loadingNotifier = LoadingStateNotifier();
  final ApiManager apiManager = ApiManager.getInstance();
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RACIViewPageSM()));
      return;
    }

    if (index == 3) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const SolutionsScreenSM()));
      return;
    }

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
                      temp.add(TaskCard(
                        taskName: task["taskName"],
                        status: task["status"] ?? "N/A",
                        progress: task["progress"] ?? 0,
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
      bottomNavigationBar: BottomNavBarSM(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
