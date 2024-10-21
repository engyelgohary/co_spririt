import 'package:co_spirit/core/components/helper_functions.dart';
import 'package:co_spirit/core/theme/app_colors.dart';
import 'package:co_spirit/data/api/apimanager.dart';
import 'package:co_spirit/data/repository/remote_data_source.dart';
import 'package:co_spirit/ui/solutions/cubit/project_overview_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SolutionsScreen extends StatefulWidget {
  const SolutionsScreen({Key? key}) : super(key: key);

  @override
  State<SolutionsScreen> createState() => _SolutionsScreenState();
}

class _SolutionsScreenState extends State<SolutionsScreen> {
  Map solutions = {};
  String selectedTaskService = '';
  String selected = '';
  SolutionCubit solutionCubit = SolutionCubit(
    smDataSource: SMDataSourceRemote(apiManager: ApiManager.getInstance()),
  );
  @override
  void initState() {
    super.initState();
    solutionCubit.getSolutions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SMColorScheme.background,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 28.0, 15.0, 0),
        child: RefreshIndicator(
          onRefresh: () async => solutionCubit.getSolutions(),
          child: BlocBuilder<SolutionCubit, SolutionsState>(
            bloc: solutionCubit,
            builder: (context, state) {
              if (state is SolutionsLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SolutionsSuccessfulState) {
                solutions = state.solutions;

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
                                SizedBox(height: 15),
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
                                            value: e,
                                            child: Text(e),
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
                                SizedBox(height: 15),
                                const Text(
                                  "Solutions",
                                  style: TextStyle(color: SMColorScheme.main, fontSize: 18),
                                ),
                                SizedBox(height: 15),
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
                                                    value: e,
                                                    child: Text(e),
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
                                        "N/A"),
                                  ),
                                  const Text(
                                    "Target Customer/User :",
                                    style: TextStyle(color: ODColorScheme.mainColor, fontSize: 16),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(solutions[selectedTaskService][selected]
                                            ["targetCustomerUser"] ??
                                        "N/A"),
                                  ),
                                  const Text(
                                    "Co-working Customer :",
                                    style: TextStyle(color: ODColorScheme.mainColor, fontSize: 16),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(solutions[selectedTaskService][selected]
                                            ["coWorkingCustomer"] ??
                                        "N/A"),
                                  ),
                                  const Text(
                                    "Phase (Proposal / PoC / on Service) :",
                                    style: TextStyle(color: ODColorScheme.mainColor, fontSize: 16),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(
                                        solutions[selectedTaskService][selected]["phase"] ?? "N/A"),
                                  ),
                                  const Text(
                                    "Co-working Stakeholder :",
                                    style: TextStyle(color: ODColorScheme.mainColor, fontSize: 16),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(solutions[selectedTaskService][selected]
                                            ["coWorkingStakeHolder"] ??
                                        "N/A"),
                                  ),
                                ],
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                );
              }
              return Center(
                child: buildErrorIndicator(
                  "Some error occurred, Please try again.",
                  () => solutionCubit.getSolutions(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
