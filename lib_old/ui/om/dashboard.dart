import 'package:co_spirit/utils/helper_functions.dart';
import 'package:co_spirit/utils/theme/appColors.dart';
import 'package:flutter/material.dart';

import '../../data/api/apimanager.dart';
import '../../data/model/TopODs.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<int> statusCounts = [];
  List<dynamic> statuses = [];
  List<dynamic> scores = [];
  String _riskAverage = 'Insights not available ';
  String _feasibilityAverage = 'Insights not available ';
  late ApiManager apiManager;
  late List<Top5ODs> top5ODs =[];

  @override
  void initState() {
    super.initState();
    apiManager = ApiManager.getInstance();
    fetchStatuses();
    fetchScores();
    fetchAverages();
    fetchTop5ODs();
  }

  Future<void> fetchStatuses() async {
    try {
      List<dynamic> fetchedStatuses = await apiManager.fetchAllStatus();
      for (var status in fetchedStatuses) {
      }
      setState(() {
        statuses = fetchedStatuses;
        statusCounts = List.filled(statuses.length, 0);
      });

      await fetchCountsForStatuses();
    } catch (e) {
      debugPrint('Error fetching statuses: $e');
    }
  }

  Future<void> fetchCountsForStatuses() async {
    if (statuses.isEmpty) return;

    for (var status in statuses) {
      int statusId = status['id'];

      int opportunityCount = await apiManager.fetchLeaderBoardByStatus(statusId.toString());

      if (opportunityCount >= 0) {
        setState(() {
          statusCounts[statuses.indexOf(status)] = opportunityCount;
        });
      } else {
        debugPrint('No valid data for status ID: $statusId');
      }
    }
  }

  Future<void> fetchScores() async {
    try {
      List<dynamic> fetchedScores = await apiManager.fetchLeaderBoardByAverageScore();

      if (fetchedScores == null || fetchedScores.isEmpty) {
        setState(() {
          scores = [];
        });
        return;
      }

      setState(() {
        scores = fetchedScores;
      });
    } catch (e) {
      debugPrint('Error fetching scores: $e');
    }
  }

  Future<void> fetchAverages() async {
    try {
      String riskAverage = await apiManager.getRiskAverage();
      String feasibilityAverage = await apiManager.getFeasibilityAverage();

      setState(() {
        _riskAverage = riskAverage;
        _feasibilityAverage = feasibilityAverage;
      });
    } catch (e) {
      debugPrint('Error fetching averages: $e');
    }
  }

  Future<void> fetchTop5ODs() async {
    try {
      top5ODs = await apiManager.getTop5Od(3);
      setState(() {});
    } catch (e) {
      debugPrint('Error fetching top 5 ODs: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
          title: "Dashboard",
          context: context,
          textColor: OMColorScheme.buttonColor,
          backArrowColor: OMColorScheme.mainColor),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Breakdown by Status",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(fontSize: 15, color: OMColorScheme.textColor),
                            ),
                          ],
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            statuses.length,
                            (index) {
                              return Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    index < statusCounts.length
                                        ? "${statusCounts[index]}"
                                        : "0",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF4169E1),
                                        ),
                                  ),
                                  Text(
                                    index < statuses.length
                                        ? statuses[index]['name']
                                        : "Unknown",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                            fontSize: 15, color: Colors.black),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.34,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            "Average Score Per OD",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(fontSize: 15, color: OMColorScheme.textColor),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.04),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: (scores.length + 1) ~/ 2,
                                    itemBuilder: (context, index) {
                                      final odScore = scores[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                                        child: Row(
                                          children: [
                                            const Text("• ", style: TextStyle(fontSize: 20)),
                                            Text(
                                              "${odScore.name ?? 'No Name'}: ",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            Text(
                                              "${odScore.averageScore ?? 0}",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Color(0xFF4169E1),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 40),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: scores.length ~/ 2,
                                    itemBuilder: (context, index) {
                                      final odScore = scores[index + (scores.length + 1) ~/ 2];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                                        child: Row(
                                          children: [
                                            const Text("• ", style: TextStyle(fontSize: 20)),
                                            Text(
                                              "${odScore.name ?? 'No Name'}: ",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            Text(
                                              "${odScore.averageScore ?? 0}",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Color(0xFF4169E1),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.43,
                      height: MediaQuery.of(context).size.height * 0.15,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Risk Average",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(fontSize: 15, color: Colors.black)),
                          Text(
                            _riskAverage,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4169E1),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.43,
                      height: MediaQuery.of(context).size.height * 0.15,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Feasibility Average",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(fontSize: 15, color: Colors.black)),
                          Text(
                            _feasibilityAverage,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4169E1),
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.25,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Leaderboard (Top 5 ODs)",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(fontSize: 15, color: OMColorScheme.textColor),
                            ),
                          ],
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        Expanded(
                          child: ListView.builder(
                            itemCount: top5ODs.length,
                            itemBuilder: (context, index) {
                              final od = top5ODs[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "${od.name}: ",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: OMColorScheme.mainColor,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "${od.statusIdCounter}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: OMColorScheme.mainColor,
                                        ),
                                      ),
                                      TextSpan(
                                        text: " submitted opportunities, ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: OMColorScheme.textColor,
                                        ),
                                      ),
                                      const TextSpan(
                                        text: "average score ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: OMColorScheme.textColor,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "${od.averageScore}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF4169E1),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
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
      ),
    );
  }
}
