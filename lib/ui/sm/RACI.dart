import 'package:co_spirit/data/api/apimanager.dart';
import 'package:co_spirit/ui/sm/menu.dart';
import 'package:co_spirit/ui/sm/solutions.dart';
import 'package:co_spirit/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/components.dart';

class RaciOverviewSM extends StatefulWidget {
  const RaciOverviewSM({Key? key}) : super(key: key);

  @override
  State<RaciOverviewSM> createState() => _RaciOverviewSMState();
}

class _RaciOverviewSMState extends State<RaciOverviewSM> {
  final LoadingStateNotifier loadingNotifier = LoadingStateNotifier();
  final ApiManager apiManager = ApiManager.getInstance();
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => MenuScreenSM(ODId: "2")));
      return;
    }

    if (index == 3) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => SolutionsScreenSM()));
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
                Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.search, color: Color(0xFF000080)),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.message_outlined, color: Color(0xFF000080)),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.notifications_none_rounded, color: Color(0xFF000080)),
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
                  final tasks = loadingNotifier.response![0];

                  return Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.w,
                        mainAxisSpacing: 10.h,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        return RaciCard(
                          taskName: tasks[index]["projectName"],
                          status: tasks[index]["status"] ?? "N/A",
                          progress: tasks[index]["progress"] ?? 0,
                        );
                      },
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
