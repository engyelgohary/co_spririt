import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/api/apimanager.dart';
import '../../../data/model/opportunity.dart';
import '../../../utils/components/appbar.dart';

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

  List<String?> uniqueRisks = ['Low', 'Medium', 'High'];
  List<String?> uniqueTeams = []; // Empty for now
  List<String?> uniqueStatuses = ['Open', 'Closed', 'Pending'];

  @override
  void initState() {
    super.initState();
    apiManager = ApiManager.getInstance();
    fetchOpportunities();
  }

  Future<void> fetchOpportunities() async {
    opportunities = await apiManager.getOpportunities();
    setState(() {});
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
                      "Description",
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
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: opportunities.length,
                    itemBuilder: (context, index) {
                      final opportunity = opportunities[index];
                      if ((selectedRisk == null || opportunity.risks?.toString() == selectedRisk)) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '$opportunity.clientId' ?? 'No Name',
                                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                  fontSize: 13,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                opportunity.description ?? 'No Description',
                                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                  fontSize: 13,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                opportunity.score?.toString() ?? 'No Score',
                                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                  fontSize: 13,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                opportunity.risks?.toString() ?? 'No Risk',
                                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                  fontSize: 13,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
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
        width: 120,
        child: DropdownButton<String?>(
          isExpanded: true,
          hint: Text(title, textAlign: TextAlign.center),
          value: selectedValue,
          items: options.map((String? value) {
            return DropdownMenuItem<String?>(
              value: value,
              child: Text(value ?? 'No Data'),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
