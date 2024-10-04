import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:co_spirit/utils/components/textFormField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

import '../../../core/app_util.dart';
import '../../../data/api/apimanager.dart';
import '../../../data/model/Team.dart';
import '../../../data/model/opportunity.dart';
import '../../../utils/helper_functions.dart';
import '../../../utils/theme/appColors.dart';

class EditOpportunityOWPage extends StatefulWidget {
  final Opportunity opportunity;

  const EditOpportunityOWPage({Key? key, required this.opportunity}) : super(key: key);

  @override
  _EditOpportunityOWPageState createState() => _EditOpportunityOWPageState();
}

class _EditOpportunityOWPageState extends State<EditOpportunityOWPage> {
  late List<dynamic> statuses = [];
  late List<Team> teams = [];
  late ApiManager apiManager;
  late int selectedStatus;
  late int selectedTeam;
  late TextEditingController comment = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.opportunity.statusId ?? 0;
    selectedTeam = widget.opportunity.teamId ?? 0;
    apiManager = ApiManager.getInstance();
    fetchStatuses();
    fetchAllTeams();
  }

  Future<void> fetchAllTeams() async {
    try {
      List<Team> fetchedTeams = await apiManager.fetchAllTeams();

      for (var team in fetchedTeams) {
        debugPrint('Fetched teams: ${team.name} with ID: ${team.id}');
      }

      setState(() {
        teams = fetchedTeams;

        if (widget.opportunity.teamId != null &&
            fetchedTeams.any((team) => team.id == widget.opportunity.teamId)) {
          selectedTeam = widget.opportunity.teamId!;
        } else if (fetchedTeams.isNotEmpty) {
          selectedTeam = fetchedTeams[0].id!;
        } else {
          selectedTeam = 0;
        }
      });
    } catch (e) {
      debugPrint('Error fetching teams: $e');
    }
  }

  Future<void> fetchStatuses() async {
    try {
      List<dynamic> fetchedStatuses = await apiManager.fetchAllStatus();
      for (var status in fetchedStatuses) {
        debugPrint('Fetched status: ${status['name']} with ID: ${status['id']}');
      }
      setState(() {
        statuses = fetchedStatuses;
        if (widget.opportunity.statusId != null &&
            fetchedStatuses.any((s) => s['id'] == widget.opportunity.statusId)) {
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

    debugPrint(
        'Updating status for opportunity ID: $opportunityId with new status: $selectedStatus');

    bool success = await apiManager.updateOpportunityStatus(opportunityId, selectedStatus);
    if (success) {
      setState(() {
        widget.opportunity.statusId = selectedStatus;
      });
      debugPrint('Opportunity updated successfully: ${widget.opportunity}');
      return widget.opportunity;
    } else {
      debugPrint('Failed to update opportunity status for ID: $opportunityId');
      return null;
    }
  }

  Future<bool> updateComment() async {
    final opportunityId = widget.opportunity.id ?? 0;

    debugPrint(
        'Updating comment for opportunity ID: $opportunityId with new comment: ${comment.text}');

    bool success = await apiManager.updateOpportunityComment(opportunityId, comment.text);
    if (success) {
      debugPrint('Opportunity updated successfully: ${widget.opportunity}');
      return true;
    } else {
      debugPrint('Failed to update opportunity status for ID: $opportunityId');
      return false;
    }
  }

  Future<Opportunity?> updateTeam() async {
    final currentOpportunityId = widget.opportunity.id ?? 0;

    print('Updating team for opportunity ID: $currentOpportunityId with new team: $selectedTeam');

    bool success = await apiManager.assignTeamToOpportunity(
        opportunityId: currentOpportunityId, teamId: selectedTeam);

    if (success) {
      setState(() {
        widget.opportunity.teamId = selectedTeam;
      });
      debugPrint('Opportunity updated successfully: ${widget.opportunity}');
      return widget.opportunity;
    } else {
      debugPrint('Failed to update opportunity team for ID: $currentOpportunityId');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = AppUtil.responsiveWidth(context);
    final opportunity = widget.opportunity;

    return Scaffold(
      appBar: customAppBar(
        title: "Edit Opportunity",
        context: context,
        backArrowColor: OWColorScheme.buttonColor,
        textColor: OWColorScheme.mainColor,
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
                    style: TextStyle(fontSize: 18, color: OWColorScheme.mainColor),
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
                    style: TextStyle(fontSize: 16, color: OWColorScheme.mainColor),
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
                    style: TextStyle(fontSize: 16, color: OWColorScheme.mainColor),
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
                    style: TextStyle(fontSize: 16, color: OWColorScheme.mainColor),
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
                    style: TextStyle(fontSize: 16, color: OWColorScheme.mainColor),
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
                    style: TextStyle(fontSize: 16, color: OWColorScheme.mainColor),
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
                    style: TextStyle(fontSize: 16, color: OWColorScheme.mainColor),
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
                      value: selectedTeam,
                      onChanged: (int? newValue) {
                        setState(() {
                          selectedTeam = newValue!;
                        });
                      },
                      items: teams.map<DropdownMenuItem<int>>((Team team) {
                        return DropdownMenuItem<int>(
                          value: team.id,
                          child: Center(
                            child: Text(
                              team.name!,
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

              SizedBox(height: 8), // Spacing
              OpportunityCommentTextFormField(
                fieldName: 'Comment:',
                controller: comment,
                hintText: "You can type a comment...",
                maxLines: null,
                minLines: 2,
                textColor: OAColorScheme.mainColor,
              ),

              // If there is a description file
              if (opportunity.descriptionLocation != null) ...[
                const SelectableText(
                  "Description File:",
                  style: TextStyle(fontSize: 16, color: OWColorScheme.mainColor),
                ),
                IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () {
                    FileDownloader.downloadFile(
                      url: "http://${ApiConstants.baseUrl}${opportunity.descriptionLocation}",
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
                style: TextStyle(fontSize: 16, color: OWColorScheme.mainColor),
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
                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 50.0),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      loadingIndicatorDialog(context);

                      if (selectedStatus != opportunity.statusId) {
                        final updatedStatus = await updateStatus();
                        if (updatedStatus == null && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Failed to update the status.'),
                                duration: Duration(seconds: 1)),
                          );
                        } else if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('updated the status.'),
                                duration: Duration(seconds: 1)),
                          );
                        }
                      }
                      if (selectedTeam != 0 && selectedTeam != opportunity.teamId) {
                        final updatedTeam = await updateTeam();
                        if (updatedTeam == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Failed to update the team.'),
                                duration: Duration(seconds: 1)),
                          );
                        } else if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Assigned Team.'), duration: Duration(seconds: 1)),
                          );
                        }
                      }
                      if (comment.text.trim().isNotEmpty) {
                        final updatedComment = await updateComment();
                        if (updatedComment == false && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Failed to update the comment.'),
                                duration: Duration(seconds: 1)),
                          );
                        } else if (context.mounted) {
                          comment.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Added comment.'), duration: Duration(seconds: 1)),
                          );
                        }
                      }
                      Navigator.of(context).pop();
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
