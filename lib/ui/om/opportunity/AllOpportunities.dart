import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../../../data/api/apimanager.dart';
import '../../../data/model/opportunity.dart';
import '../../../utils/components/appbar.dart';
import 'package:pdf/widgets.dart' as pw;
import 'opportunity_view.dart';

class AllOpportunities extends StatefulWidget {
  const AllOpportunities({Key? key}) : super(key: key);

  @override
  State<AllOpportunities> createState() => _AllOpportunitiesState();
}

class _AllOpportunitiesState extends State<AllOpportunities> {
  late ApiManager apiManager;
  List<Opportunity> opportunities = [];
  String? selectedRisk;
  String? selectedTeam;
  String? selectedStatus;

  List<String?> uniqueRisks = [];
  List<String?> uniqueTeams = [];
  List<String?> uniqueStatuses = [];

  @override
  void initState() {
    super.initState();
    apiManager = ApiManager.getInstance();
    fetchOpportunities();
  }

  Future<void> fetchOpportunities() async {
    opportunities = await apiManager.getOpportunities();
    extractUniqueValues();
    setState(() {});
  }

  void extractUniqueValues() {
    uniqueRisks = opportunities.map((op) => op.risks).toSet().toList().cast<String?>();
    uniqueStatuses = opportunities.map((op) => op.status).toSet().toList().cast<String?>();
    uniqueTeams = opportunities.map((op) => op.teamName).toSet().toList().cast<String?>();

    uniqueRisks.insert(0, 'All');
    uniqueTeams.insert(0, 'All');
    uniqueStatuses.insert(0, 'All');
  }

  Future<void> _downloadPdf() async {
    try {
      final pdf = pw.Document();

      final ttf = await rootBundle.load('assets/Roboto-Medium.ttf');
      final customFont = pw.Font.ttf(ttf);

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              children: [
                pw.Text('Opportunities List', style: pw.TextStyle(fontSize: 24, font: customFont)),
                ...opportunities.map((op) {
                  return pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('${op.clientId ?? 'No Name'}', style: pw.TextStyle(font: customFont)),
                      pw.Text(op.title ?? 'No title', style: pw.TextStyle(font: customFont)),
                      pw.Text(op.score?.toString() ?? 'No Score', style: pw.TextStyle(font: customFont)),
                      pw.Text(op.risks ?? 'No Risk', style: pw.TextStyle(font: customFont)),
                    ],
                  );
                }).toList(),
              ],
            );
          },
        ),
      );

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/opportunities_list.pdf');

      // Save the PDF
      await file.writeAsBytes(await pdf.save());

      print('PDF saved successfully at ${file.path}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF downloaded successfully!')),
      );

    } catch (e) {
      print('Error generating PDF: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating PDF: $e')),
      );
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Opportunities',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 20),
        ),
        leading: const AppBarCustom(),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: _downloadPdf,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildDropdownMenu(
                    'Risk',
                    uniqueRisks,
                    selectedRisk,
                        (value) {
                      setState(() {
                        selectedRisk = value == 'All' ? null : value;
                      });
                    },
                  ),
                  buildDropdownMenu(
                    'Assigned Team',
                    uniqueTeams,
                    selectedTeam,
                        (value) {
                      setState(() {
                        selectedTeam = value == 'All' ? null : value;
                      });
                    },
                  ),
                  buildDropdownMenu(
                    'Status',
                    uniqueStatuses,
                    selectedStatus,
                        (value) {
                      setState(() {
                        selectedStatus = value == 'All' ? null : value;
                      });
                    },
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: const BoxDecoration(
                  color: Color(0xFFF0F0F0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Customer Name",
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontSize: 14,
                        color: const Color(0xFF4169E1),
                      ),
                    ),
                    Text(
                      "Title",
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontSize: 14,
                        color: const Color(0xFF4169E1),
                      ),
                    ),
                    Text(
                      "Score",
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontSize: 14,
                        color: const Color(0xFF4169E1),
                      ),
                    ),
                    Text(
                      "Risk",
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontSize: 14,
                        color: const Color(0xFF4169E1),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ListView.builder(
                    itemCount: opportunities.length,
                    itemBuilder: (context, index) {
                      final opportunity = opportunities[index];
                      // Filter by selected risk and status
                      if ((selectedRisk == null || opportunity.risks == selectedRisk) &&
                          (selectedStatus == null || opportunity.status == selectedStatus)) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OpportunityViewOM(
                                  opportunity: opportunity,
                                ),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    opportunity.clientName ?? 'No Name',
                                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis, // Add this to prevent long text overflow
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    opportunity.title ?? 'No title',
                                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    (opportunity.score is int ? (opportunity.score as int).toDouble() : opportunity.score)?.toString() ?? 'No Score',
                                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    opportunity.risks ?? 'No Risk',
                                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),

                        );
                      }
                      return Container();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDropdownMenu(
      String title,
      List<String?> options,
      String? selectedValue,
      ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox(
        width: 100,
        child: DropdownButton<String?>(
          isExpanded: true,
          hint: Text(title,style: TextStyle(fontSize: 13)),
          value: selectedValue,
          items: options.map((String? value) {
            return DropdownMenuItem<String?>(
              value: value,
              child: Text(value ??  title,style: TextStyle(fontSize: 13)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
