import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:co_spirit/core/app_util.dart';
import 'package:co_spirit/data/api/apimanager.dart';
import 'package:co_spirit/data/model/opportunity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../../utils/helper_functions.dart';
import '../../../utils/theme/appColors.dart';
import 'opportunity_edit.dart';

class OpportunityViewOM extends StatefulWidget {
  final Opportunity opportunity;

  const OpportunityViewOM({Key? key, required this.opportunity}) : super(key: key);

  @override
  _OpportunityViewOMState createState() => _OpportunityViewOMState();
}

class _OpportunityViewOMState extends State<OpportunityViewOM> {
  late Opportunity opportunity;
  late ApiManager apiManager;

  @override
  void initState() {
    super.initState();
    apiManager = ApiManager.getInstance();
    opportunity = widget.opportunity;
    _fetchOpportunity();
  }

  Future<void> _fetchOpportunity() async {
    if (opportunity.id != null) {
      try {
        final fetchedOpportunity = await apiManager.getOpportunityById(opportunity.id);
        if (fetchedOpportunity != null) {
          setState(() {
            opportunity = fetchedOpportunity;
            print(opportunity.status);
          });
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Opportunity not found.")));
        }
      } catch (e) {
        String errorMessage;

        if (e is SocketException) {
          errorMessage = "Network error: Unable to connect to the server.";
        } else {
          errorMessage = "An error occurred: $e";
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = AppUtil.responsiveWidth(context);
    return Scaffold(
      appBar: customAppBar(
        title: "Opportunity",
        context: context,
        backArrowColor: OMColorScheme.mainColor,
        textColor: OMColorScheme.textColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: const Icon(Icons.mode_edit_outlined),
              onPressed: () async {
                if (opportunity.id != null) {
                  await Navigator.push<Opportunity?>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditOpportunityOMPage(opportunity: opportunity),
                    ),
                  );
                  await _fetchOpportunity();
                }
              },
            ),
          ),
        ],
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
                    "Client Name",
                    style: TextStyle(fontSize: 18, color: OMColorScheme.mainColor),
                  ),
                  SizedBox(width: 35),
                  SelectableText(
                    opportunity.clientName ?? "N/A",
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  const SelectableText(
                    "Opportunity Title:",
                    style: TextStyle(fontSize: 16, color: OMColorScheme.mainColor),
                  ),
                  SizedBox(width: 35),
                  SelectableText(
                    opportunity.title ?? "N/A",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  const SelectableText(
                    "Feasibility:",
                    style: TextStyle(fontSize: 16, color: OMColorScheme.mainColor),
                  ),
                  SizedBox(width: 35),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: SelectableText(
                      opportunity.feasibility ?? "N/A",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  const SelectableText(
                    "Risks:",
                    style: TextStyle(fontSize: 16, color: OMColorScheme.mainColor),
                  ),
                  SizedBox(width: 35),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: SelectableText(
                      opportunity.risks ?? "N/A",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  const SelectableText(
                    "Type:",
                    style: TextStyle(fontSize: 16, color: OMColorScheme.mainColor),
                  ),
                  SizedBox(width: 35),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: SelectableText(
                      opportunity.type ?? "N/A",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  const SelectableText(
                    "Status:",
                    style: TextStyle(fontSize: 16, color: OMColorScheme.mainColor),
                  ),
                  SizedBox(width: 50),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: SelectableText(
                      opportunity.status ?? "N/A",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  const SelectableText(
                    "Assigned To:",
                    style: TextStyle(fontSize: 16, color: OMColorScheme.mainColor),
                  ),
                  SizedBox(width: 35),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: SelectableText(
                      opportunity.teamName ?? "N/A",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              if (opportunity.descriptionLocation != null) ...[
                const SelectableText(
                  "Description File:",
                  style: TextStyle(fontSize: 16, color: OMColorScheme.mainColor),
                ),
                IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () {
                    downloadFile(opportunity.descriptionLocation!);
                  },
                ),
              ],
              SizedBox(height: 15),
              const SelectableText(
                "Description:",
                style: TextStyle(fontSize: 16, color: OMColorScheme.mainColor),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: SelectableText(
                  opportunity.description ?? "N/A",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 15),
              const SelectableText(
                "Recommendation:",
                style: TextStyle(fontSize: 16, color: OMColorScheme.mainColor),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: MarkdownBody(
                  shrinkWrap: true,
                  selectable: true,
                  data: opportunity.result ?? "N/A",
                  styleSheet: MarkdownStyleSheet(
                    p: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void downloadFile(String descriptionLocation) {
    FileDownloader.downloadFile(
      url: "http://${ApiConstants.baseUrl}$descriptionLocation",
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
            body: "Download error message: $errorMessage",
            notificationLayout: NotificationLayout.BigText,
          ),
        );
      },
    );
  }
}
