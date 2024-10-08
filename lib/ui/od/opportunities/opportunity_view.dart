import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:co_spirit/core/app_util.dart';
import 'package:co_spirit/data/api/apimanager.dart';
import 'package:co_spirit/data/model/opportunity.dart';
import 'package:co_spirit/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../utils/theme/appColors.dart';

class OpportunityViewOD extends StatelessWidget {
  final Opportunity opportunity;
  const OpportunityViewOD({super.key, required this.opportunity});

  @override
  Widget build(BuildContext context) {
    double width = AppUtil.responsiveWidth(context);
    return Scaffold(
      appBar: customAppBar(
        title: "Opportunities",
        context: context,
        backArrowColor: ODColorScheme.buttonColor,
        textColor: ODColorScheme.mainColor,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width / 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SelectableText(
                "Opportunity Title:",
                style: TextStyle(fontSize: 16, color: ODColorScheme.mainColor),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: SelectableText(
                  opportunity.title ?? "N/A",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SelectableText(
                "Status:",
                style: TextStyle(fontSize: 16, color: ODColorScheme.mainColor),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: SelectableText(
                  opportunity.status ?? "N/A",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SelectableText(
                "Feasibility:",
                style: TextStyle(fontSize: 16, color: ODColorScheme.mainColor),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: SelectableText(
                  opportunity.feasibility ?? "N/A",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SelectableText(
                "Risks:",
                style: TextStyle(fontSize: 16, color: ODColorScheme.mainColor),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: SelectableText(
                  opportunity.risks ?? "N/A",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SelectableText(
                "Type:",
                style: TextStyle(fontSize: 16, color: ODColorScheme.mainColor),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: SelectableText(
                  opportunity.type ?? "N/A",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              if (opportunity.descriptionLocation != null)
                const SelectableText(
                  "Description File:",
                  style: TextStyle(fontSize: 16, color: ODColorScheme.mainColor),
                ),
              if (opportunity.descriptionLocation != null)
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
                style: TextStyle(fontSize: 16, color: ODColorScheme.mainColor),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: SelectableText(
                  opportunity.description ?? "N/A",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SelectableText(
                "Recommendation:",
                style: TextStyle(fontSize: 16, color: ODColorScheme.mainColor),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
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
}
