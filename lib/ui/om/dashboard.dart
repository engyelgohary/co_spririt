import 'package:co_spririt/utils/helper_functions.dart';
import 'package:co_spririt/utils/theme/appColors.dart';
import 'package:flutter/material.dart';

import '../../utils/components/appbar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List<Map<String, dynamic>> scores = [
    {"name": "Alice", "score": 90},
    {"name": "Bob", "score": 85},
    {"name": "Charlie", "score": 95},
    {"name": "David", "score": 80},
    {"name": "Eva", "score": 88},
    {"name": "Frank", "score": 92},
    {"name": "Grace", "score": 87},
    {"name": "Hank", "score": 91},
  ];

  List<Map<String, dynamic>> leaderboard = [
    {"name": "Jane Smith", "closedOpportunities": 20, "averageScore": 90},
    {"name": "John Doe", "closedOpportunities": 18, "averageScore": 88},
    {"name": "Emily Johnson", "closedOpportunities": 15, "averageScore": 85},
    {"name": "Michael Lee", "closedOpportunities": 12, "averageScore": 84},
    {"name": "Sarah Brown", "closedOpportunities": 10, "averageScore": 82},
  ];

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
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "0",
                                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: OMColorScheme.mainColor,
                                      ),
                                ),
                                Text("Submitted",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(fontSize: 15, color: OMColorScheme.textColor))
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "0",
                                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: OMColorScheme.mainColor,
                                      ),
                                ),
                                Text("In Progress",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(fontSize: 15, color: OMColorScheme.textColor))
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "0",
                                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: OMColorScheme.mainColor,
                                      ),
                                ),
                                Text("Closed",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(fontSize: 15, color: OMColorScheme.textColor))
                              ],
                            ),
                          ],
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
                    padding: const EdgeInsets.all(18.0),
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
                          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: (scores.length + 1) ~/ 2,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                                        child: Row(
                                          children: [
                                            Text("• ", style: TextStyle(fontSize: 25)),
                                            Text(
                                              "${scores[index]['name']}: ",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            // Display score with specified color
                                            Text(
                                              "${scores[index]['score']}",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: OMColorScheme.mainColor,
                                                  fontWeight: FontWeight.bold), // Set score color
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(width: 40),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: scores.length ~/ 2,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                                        child: Row(
                                          children: [
                                            Text("• ", style: TextStyle(fontSize: 25)),
                                            Text(
                                              "${scores[index + (scores.length + 1) ~/ 2]['name']}: ",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            Text(
                                              "${scores[index + (scores.length + 1) ~/ 2]['score']}",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: OMColorScheme.mainColor,
                                                  fontWeight: FontWeight.bold), // Set score color
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
                                  .copyWith(fontSize: 15, color: OMColorScheme.textColor)),
                          Text(
                            "Medium",
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: OMColorScheme.mainColor,
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
                                  .copyWith(fontSize: 15, color: OMColorScheme.textColor)),
                          Text(
                            "High",
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: OMColorScheme.mainColor,
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
                        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                        Expanded(
                          child: ListView.builder(
                            itemCount: leaderboard.length,
                            itemBuilder: (context, index) {
                              final od = leaderboard[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "${od['name']}: ",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: OMColorScheme.mainColor,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "${od['closedOpportunities']}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: OMColorScheme.mainColor,
                                        ),
                                      ),
                                      TextSpan(
                                        text: " closed opportunities, ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: OMColorScheme.textColor,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "average score ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: OMColorScheme.textColor,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "${od['averageScore']}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: OMColorScheme.mainColor,
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
