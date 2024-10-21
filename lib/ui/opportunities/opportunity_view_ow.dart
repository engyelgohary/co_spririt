import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:co_spirit/core/app_util.dart';
import 'package:co_spirit/core/components/appbar.dart';
import 'package:co_spirit/core/theme/app_colors.dart';
import 'package:co_spirit/data/api/apimanager.dart';
import 'package:co_spirit/data/model/opportunity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'opportunity_edit_ow.dart';

class OpportunityViewOW extends StatefulWidget {
  final Opportunity opportunity;
  const OpportunityViewOW({super.key, required this.opportunity});

  @override
  State<OpportunityViewOW> createState() => _OpportunityViewOWState();
}

class _OpportunityViewOWState extends State<OpportunityViewOW> {
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
    if (widget.opportunity.id != null) {
      try {
        final fetchedOpportunity = await apiManager.getOpportunityById(widget.opportunity.id);
        setState(() {
          opportunity = fetchedOpportunity;
          print(widget.opportunity.status);
        });
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
        title: "Opportunities",
        context: context,
        backArrowColor: OWColorScheme.buttonColor,
        textColor: OWColorScheme.mainColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: const Icon(Icons.mode_edit_outlined),
              onPressed: () async {
                if (widget.opportunity.id != null) {
                  await Navigator.push<Opportunity?>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditOpportunityOWPage(opportunity: widget.opportunity),
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
              const SelectableText(
                "Opportunity Title:",
                style: TextStyle(fontSize: 16, color: OWColorScheme.mainColor),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: SelectableText(
                  widget.opportunity.title ?? "N/A",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SelectableText(
                "Status:",
                style: TextStyle(fontSize: 16, color: OWColorScheme.mainColor),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: SelectableText(
                  widget.opportunity.status ?? "N/A",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SelectableText(
                "Feasibility:",
                style: TextStyle(fontSize: 16, color: OWColorScheme.mainColor),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: SelectableText(
                  widget.opportunity.feasibility ?? "N/A",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SelectableText(
                "Risks:",
                style: TextStyle(fontSize: 16, color: OWColorScheme.mainColor),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: SelectableText(
                  widget.opportunity.risks ?? "N/A",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SelectableText(
                "Type:",
                style: TextStyle(fontSize: 16, color: OWColorScheme.mainColor),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: SelectableText(
                  widget.opportunity.type ?? "N/A",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              if (widget.opportunity.descriptionLocation != null)
                const SelectableText(
                  "Description File:",
                  style: TextStyle(fontSize: 16, color: OWColorScheme.mainColor),
                ),
              if (widget.opportunity.descriptionLocation != null)
                IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () {
                    FileDownloader.downloadFile(
                      url:
                          "http://${ApiConstants.baseUrl}${widget.opportunity.descriptionLocation}",
                      onDownloadCompleted: (path) {
                        AwesomeNotifications().createNotification(
                          content: NotificationContent(
                            id: 16,
                            channelKey: 'basic_channel',
                            title: "Download is complete",
                            body: "download location: $path",
                            notificationLayout: NotificationLayout.BigText,
                          ),
                        );
                      },
                      onDownloadError: (errorMessage) {
                        AwesomeNotifications().createNotification(
                          content: NotificationContent(
                            id: 16,
                            channelKey: 'basic_channel',
                            title: "Download faild",
                            body: "download error message:  $errorMessage",
                            notificationLayout: NotificationLayout.BigText,
                          ),
                        );
                      },
                    );
                  },
                ),
              const SelectableText(
                "Description:",
                style: TextStyle(fontSize: 16, color: OWColorScheme.mainColor),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: SelectableText(
                  widget.opportunity.description ?? "N/A",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SelectableText(
                "Recommendation:",
                style: TextStyle(fontSize: 16, color: OWColorScheme.mainColor),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: MarkdownBody(
                  shrinkWrap: true,
                  selectable: true,
                  data: widget.opportunity.result ?? "N/A",
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
}
