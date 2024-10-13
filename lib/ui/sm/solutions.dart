import 'package:co_spirit/utils/helper_functions.dart';
import 'package:co_spirit/utils/theme/appColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/api/apimanager.dart';

class SolutionsScreenNeo extends StatefulWidget {
  final bool isSM;
  const SolutionsScreenNeo({Key? key, required this.isSM}) : super(key: key);

  @override
  State<SolutionsScreenNeo> createState() => _SolutionsScreenNeoState();
}

class _SolutionsScreenNeoState extends State<SolutionsScreenNeo> {
  final LoadingStateNotifier loadingNotifier = LoadingStateNotifier();
  final ApiManager apiManager = ApiManager.getInstance();
  Map solutions = {};
  String selectedTaskService = '';
  String selected = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SMColorScheme.background,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 28.0, 15.0, 0),
        child: RefreshIndicator(
          onRefresh: () async => loadingNotifier.change(),
          child: ListenableBuilder(
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

              return SingleChildScrollView(
                child: Container(
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
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Task Service",
                                style: TextStyle(color: SMColorScheme.main, fontSize: 18),
                              ),
                              SizedBox(height: 15.h),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                child: DropdownButton<String>(
                                  value:
                                      selectedTaskService.isNotEmpty ? selectedTaskService : null,
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
                                      selectedTaskService = value ?? '';
                                      selected = "";
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
                              SizedBox(height: 15.h),
                              const Text(
                                "Solutions",
                                style: TextStyle(color: SMColorScheme.main, fontSize: 18),
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
                                  items: selectedTaskService.isEmpty
                                      ? []
                                      : List<DropdownMenuItem<String>>.from(
                                          solutions[selectedTaskService].keys.map(
                                                (e) => DropdownMenuItem<String>(
                                                  child: Text(e),
                                                  value: e,
                                                ),
                                              )),
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
                                    child: Text(solutions[selectedTaskService][selected]
                                            ["customerValue"] ??
                                        "N/A")),
                                const Text(
                                  "Target Customer/User :",
                                  style: TextStyle(color: ODColorScheme.mainColor, fontSize: 16),
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(solutions[selectedTaskService][selected]
                                            ["targetCustomerUser"] ??
                                        "N/A")),
                                const Text(
                                  "Co-working Customer :",
                                  style: TextStyle(color: ODColorScheme.mainColor, fontSize: 16),
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(solutions[selectedTaskService][selected]
                                            ["coWorkingCustomer"] ??
                                        "N/A")),
                                const Text(
                                  "Phase (Proposal / PoC / on Service) :",
                                  style: TextStyle(color: ODColorScheme.mainColor, fontSize: 16),
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(solutions[selectedTaskService][selected]["phase"] ??
                                        "N/A")),
                                const Text(
                                  "Co-working Stakeholder :",
                                  style: TextStyle(color: ODColorScheme.mainColor, fontSize: 16),
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(solutions[selectedTaskService][selected]
                                            ["coWorkingStakeHolder"] ??
                                        "N/A")),
                              ],
                            ),
                          ),
                        )
                    ],
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
