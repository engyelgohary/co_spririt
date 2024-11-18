import 'package:flutter/material.dart';

class OdScores extends StatefulWidget {
  const OdScores({super.key});

  @override
  State<OdScores> createState() => _OdScoresState();
}

class _OdScoresState extends State<OdScores> {
  final List<Map<String, dynamic>> scoreData = [
    {'customer': 'AGL', 'solution': 'Using AI for Data Analysis', 'score': 7},
    {'customer': 'AGL', 'solution': 'Adopting cloud computing technologies', 'score': 2},
    {'customer': 'AGL', 'solution': 'Using AI for Data Analysis', 'score': 9},
    {'customer': 'AGL', 'solution': 'Adopting cloud computing technologies', 'score': 5},
    {'customer': 'AGL', 'solution': 'Adopting cloud computing technologies', 'score': 5},
  ];

  int getTotalScore() {
    return scoreData.fold(0, (total, item) => total + (item['score'] as int));
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Scores:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    "Total Score: ${getTotalScore()}",
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.green),
                  ),
                ),
                const SizedBox(height: 20),
                buildScoreTable(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildScoreTable() {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(4),
        2: FlexColumnWidth(2),
      },
      children: [

        // Table Header
        TableRow(
          decoration: BoxDecoration(color:Color(0xFFDFE8F8)),
          children: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Customer', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Solution', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Score', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        // Table Rows
        ...scoreData.map((item) => TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(item['customer']),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(item['solution']),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                item['score'].toString(),
                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        )),
      ],
    );
  }
}
