import 'package:flutter/material.dart';

class OdOpportunities extends StatefulWidget {
  const OdOpportunities({super.key});

  @override
  State<OdOpportunities> createState() => _OdOpportunitiesState();
}

class _OdOpportunitiesState extends State<OdOpportunities> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> opportunitiesData = [
    {'customer': 'AGL', 'corelia solution': 'Using AI for Data Analysis', 'feasibility': 'Medium'},
    {'customer': 'AGL', 'corelia solution': 'Adopting cloud computing technologies', 'feasibility': 'Medium'},
    {'customer': 'AGL', 'corelia solution': 'Using AI for Data Analysis', 'feasibility': 'Medium'},
    {'customer': 'AGL', 'corelia solution': 'Adopting cloud computing technologies', 'feasibility': 'Medium'},
    {'customer': 'AGL', 'corelia solution': 'Adopting cloud computing technologies', 'feasibility': 'Medium'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                  "Opportunities:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                // Adding TabBar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey,
                    tabs: const [
                      Tab(text: 'Pending'),
                      Tab(text: 'In progress'),
                      Tab(text: 'Done'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // TabBarView for content
                SizedBox(
                  height: 800, // Adjust height as needed
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      buildOpportunitiesTable(), // Pending
                      buildOpportunitiesTable(), // In progress
                      buildOpportunitiesTable(), // Done
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildOpportunitiesTable() {
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
          decoration: BoxDecoration(color: const Color(0xFFDFE8F8)),
          children: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Customer', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Corelia Solution', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Feasibility', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        // Table Rows
        ...opportunitiesData.map((item) => TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(item['customer']),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(item['corelia solution']),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                item['feasibility'],
                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        )),
      ],
    );
  }
}
