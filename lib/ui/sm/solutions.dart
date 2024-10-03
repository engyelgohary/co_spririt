import 'package:co_spirit/ui/sm/raci_view.dart';
import 'package:co_spirit/ui/sm/raci_view_old.dart';
import 'package:co_spirit/ui/sm/tasks_overview.dart';
import 'package:co_spirit/ui/sm/menu.dart';
import 'package:co_spirit/utils/helper_functions.dart';
import 'package:co_spirit/utils/theme/appColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/components.dart';
import '../../data/api/apimanager.dart';

class SolutionsScreenSM extends StatefulWidget {
  const SolutionsScreenSM({Key? key}) : super(key: key);

  @override
  State<SolutionsScreenSM> createState() => _SolutionsScreenSMState();
}

class _SolutionsScreenSMState extends State<SolutionsScreenSM> {
  final LoadingStateNotifier loadingNotifier = LoadingStateNotifier();
  final ApiManager apiManager = ApiManager.getInstance();
  Map solutions = {};
  String selected = '';
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => RACIViewPageSM()));
      return;
    }

    if (index == 1) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TasksOverviewSM()));
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
                    solutionsList(apiManager, loadingNotifier);
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
                  solutions = loadingNotifier.response![0];
                  // if (solutions.isNotEmpty) {
                  //   selected = solutions.keys.first;
                  // }
                  return Container(
                    decoration:
                        BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: const Color(0xFFEEEEEE),
                              borderRadius: BorderRadius.circular(10)),
                          width: MediaQuery.of(context).size.width,
                          // height: MediaQuery.of(context).size.height * 0.16,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "Solutions",
                                  style: TextStyle(color: Color(0xFF000080), fontSize: 18),
                                ),
                                SizedBox(height: 15.h),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                  child: DropdownButton<String>(
                                    value: selected.isNotEmpty ? selected : null,
                                    hint: const Text(
                                      "Select an option",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    isExpanded: true,
                                    items: solutions.keys
                                        .map(
                                          (e) => DropdownMenuItem<String>(
                                            child: Text(e),
                                            value: e,
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selected = value ?? '';
                                      });
                                    },
                                    dropdownColor: Colors.white,
                                    icon: const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.grey,
                                    ),
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (selected.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: SingleChildScrollView(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Customer Value:",
                                  style: TextStyle(color: ODColorScheme.mainColor, fontSize: 16),
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(solutions[selected]["customerValue"] ?? "N/A")),
                                const Text(
                                  "Target Customer/User :",
                                  style: TextStyle(color: ODColorScheme.mainColor, fontSize: 16),
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child:
                                        Text(solutions[selected]["targetCustomerUser"] ?? "N/A")),
                                const Text(
                                  "Co-working Customer :",
                                  style: TextStyle(color: ODColorScheme.mainColor, fontSize: 16),
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(solutions[selected]["coWorkingCustomer"] ?? "N/A")),
                                const Text(
                                  "Phase (Proposal / PoC / on Service) :",
                                  style: TextStyle(color: ODColorScheme.mainColor, fontSize: 16),
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(solutions[selected]["phase"] ?? "N/A")),
                                const Text(
                                  "Co-working Stakeholder :",
                                  style: TextStyle(color: ODColorScheme.mainColor, fontSize: 16),
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child:
                                        Text(solutions[selected]["coWorkingStakeHolder"] ?? "N/A")),
                                const Text(
                                  "Target Co-R&D :",
                                  style: TextStyle(color: ODColorScheme.mainColor, fontSize: 16),
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(solutions[selected]["targetCoRD"] ?? "N/A")),
                              ],
                            )),
                          )
                      ],
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
