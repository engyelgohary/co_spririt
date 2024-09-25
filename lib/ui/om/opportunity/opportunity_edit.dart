import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

import '../../../core/app_util.dart';
import '../../../data/api/apimanager.dart';
import '../../../data/model/opportunity.dart';
import '../../../utils/helper_functions.dart';
import '../../../utils/theme/appColors.dart';

class EditOpportunityPage extends StatefulWidget {
  final Opportunity opportunity;

  const EditOpportunityPage({Key? key, required this.opportunity})
      : super(key: key);

  @override
  _EditOpportunityPageState createState() => _EditOpportunityPageState();
}

class _EditOpportunityPageState extends State<EditOpportunityPage> {
  late List<dynamic> statuses = [];
  late ApiManager apiManager;
  late int selectedStatus;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.opportunity.statusId ?? 0;
    apiManager = ApiManager.getInstance();
    fetchStatuses();
  }

  Future<void> fetchStatuses() async {
    try {
      List<dynamic> fetchedStatuses = await apiManager.fetchAllStatus();
      for (var status in fetchedStatuses) {
        debugPrint(
            'Fetched status: ${status['name']} with ID: ${status['id']}');
      }
      setState(() {
        statuses = fetchedStatuses;
        if (widget.opportunity.statusId != null &&
            fetchedStatuses
                .any((s) => s['id'] == widget.opportunity.statusId)) {
          selectedStatus = widget.opportunity.statusId!;
        } else if (fetchedStatuses.isNotEmpty) {
          selectedStatus = fetchedStatuses[0]['id'];
        } else {
          selectedStatus = 0;
        }
      });
    } catch (e) {
      debugPrint('Error fetching statuses: $e');
    }
  }

  Future<Opportunity?> updateStatus() async {
    final opportunityId = widget.opportunity.id ?? 0;

    bool success = await apiManager.updateOpportunityStatus(opportunityId, selectedStatus);
    if (success) {
      setState(() {
        widget.opportunity.statusId = selectedStatus;
      });
      return widget.opportunity;
    }
    return null;
  }



  @override
  Widget build(BuildContext context) {
    double width = AppUtil.responsiveWidth(context);
    final opportunity = widget.opportunity;

    return Scaffold(
      appBar: customAppBar(
        title: "Edit Opportunity",
        context: context,
        backArrowColor: OMColorScheme.mainColor,
        textColor: OMColorScheme.textColor,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width / 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SelectableText(
                    "Client Name:",
                    style:
                        TextStyle(fontSize: 18, color: OMColorScheme.mainColor),
                  ),
                  SizedBox(width: 35.0),
                  SelectableText(
                    opportunity.clientName ?? "N/A",
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
              SizedBox(height: 15.0),
              Row(
                children: [
                  const SelectableText(
                    "Opportunity Title:",
                    style:
                        TextStyle(fontSize: 16, color: OMColorScheme.mainColor),
                  ),
                  SizedBox(width: 35.0),
                  SelectableText(
                    opportunity.title ?? "N/A",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 15.0),
              Row(
                children: [
                  const SelectableText(
                    "Feasibility:",
                    style:
                        TextStyle(fontSize: 16, color: OMColorScheme.mainColor),
                  ),
                  SizedBox(width: 35.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: SelectableText(
                      opportunity.feasibility ?? "N/A",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.0),
              Row(
                children: [
                  const SelectableText(
                    "Risks:",
                    style:
                        TextStyle(fontSize: 16, color: OMColorScheme.mainColor),
                  ),
                  SizedBox(width: 35.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: SelectableText(
                      opportunity.risks ?? "N/A",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.0),
              Row(
                children: [
                  const SelectableText(
                    "Type:",
                    style:
                        TextStyle(fontSize: 16, color: OMColorScheme.mainColor),
                  ),
                  SizedBox(width: 35.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: SelectableText(
                      opportunity.type ?? "N/A",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.0),

              // Dropdown for selecting status
              Row(
                children: [
                  const SelectableText(
                    "Status:",
                    style:
                        TextStyle(fontSize: 16, color: OMColorScheme.mainColor),
                  ),
                  SizedBox(width: 35.0),
                  Container(
                    width: width * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: DropdownButton<int>(
                      isExpanded: true,
                      value: selectedStatus,
                      onChanged: (int? newValue) {
                        setState(() {
                          selectedStatus = newValue!;
                        });
                      },
                      items: statuses.map<DropdownMenuItem<int>>((dynamic status) {
                        return DropdownMenuItem<int>(
                          value: status['id'],
                          child: Center(
                            child: Text(
                              status['name'],
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      dropdownColor: Colors.white,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),

                  ),
                ],
              ),

              SizedBox(height: 15.0),
              Row(
                children: [
                  const SelectableText(
                    "Assigned To:",
                    style:
                        TextStyle(fontSize: 16, color: OMColorScheme.mainColor),
                  ),
                  SizedBox(width: 35.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: SelectableText(
                      opportunity.teamName ?? "N/A",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20), // Spacing

              // If there is a description file
              if (opportunity.descriptionLocation != null) ...[
                const SelectableText(
                  "Description File:",
                  style:
                      TextStyle(fontSize: 16, color: OMColorScheme.mainColor),
                ),
                IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () {
                    FileDownloader.downloadFile(
                      url:
                          "http://${ApiConstants.baseUrl}${opportunity.descriptionLocation}",
                      onDownloadCompleted: (path) {
                        AwesomeNotifications().createNotification(
                          content: NotificationContent(
                            id: 16,
                            channelKey: 'basic_channel',
                            title: "Download is complete",
                            body: "Download location: $path",
                            notificationLayout: NotificationLayout.BigText,
                          ),
                        );
                      },
                      onDownloadError: (errorMessage) {
                        AwesomeNotifications().createNotification(
                          content: NotificationContent(
                            id: 16,
                            channelKey: 'basic_channel',
                            title: "Download failed",
                            body: "Download error message:  $errorMessage",
                            notificationLayout: NotificationLayout.BigText,
                          ),
                        );
                      },
                    );
                  },
                ),
              ],

              SizedBox(height: 15.0),
              const SelectableText(
                "Description:",
                style: TextStyle(fontSize: 16, color: OMColorScheme.mainColor),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: SelectableText(
                  opportunity.description ?? "N/A",
                  style: const TextStyle(fontSize: 16),
                ),
              ),

              SizedBox(height: 55),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.grey[300],
                      backgroundColor: Colors.grey,

                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 50.0),

                      textStyle:
                          const TextStyle(fontSize: 18),
                    ),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final updatedOpportunity = await updateStatus();
                      if (updatedOpportunity != null) {
                        Navigator.pop(context, updatedOpportunity);  // Pass the updated opportunity back
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFF4169E1),
                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 50.0),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text('Save'),
                  ),


                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
