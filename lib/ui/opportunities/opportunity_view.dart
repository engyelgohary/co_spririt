import 'package:co_spirit/core/app_util.dart';
import 'package:co_spirit/core/components/appbar.dart';
import 'package:co_spirit/core/components/helper_functions.dart';
import 'package:co_spirit/data/api/apimanager.dart';
import 'package:co_spirit/data/model/opportunity.dart';
import 'package:co_spirit/ui/opportunities/oa_opportunity_edit.dart';
import 'package:co_spirit/ui/opportunities/om_opportunity_edit.dart';
import 'package:co_spirit/ui/opportunities/ow_opportunity_edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class OpportunityView extends StatelessWidget {
  final Opportunity opportunity;
  final int userType;
  final Map colorMap;
  const OpportunityView({
    super.key,
    required this.opportunity,
    required this.userType,
    required this.colorMap,
  });

  @override
  Widget build(BuildContext context) {
    double width = AppUtil.responsiveWidth(context);
    return Scaffold(
      appBar: customAppBar(
        title: "Opportunities",
        context: context,
        backArrowColor: colorMap["buttonColor"],
        textColor: colorMap["mainColor"],
        actions: [
          if (userType != 2)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: IconButton(
                icon: const Icon(Icons.mode_edit_outlined),
                onPressed: () async {
                  if (opportunity.id != null) {
                    await Navigator.push<Opportunity?>(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          switch (userType) {
                            case 0:
                              return EditOpportunityOMPage(opportunity: opportunity);
                            case 3:
                              return EditOpportunityOAPage(opportunity: opportunity);
                            case 4:
                              return EditOpportunityOWPage(opportunity: opportunity);
                            default:
                              throw Exception("Not a user type");
                          }
                        },
                      ),
                    );
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
              SelectableText(
                "Opportunity Title:",
                style: TextStyle(fontSize: 16, color: colorMap["mainColor"]),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: SelectableText(
                  opportunity.title ?? "N/A",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              SelectableText(
                "Status:",
                style: TextStyle(fontSize: 16, color: colorMap["mainColor"]),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: SelectableText(
                  opportunity.status ?? "N/A",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              SelectableText(
                "Feasibility:",
                style: TextStyle(fontSize: 16, color: colorMap["mainColor"]),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: SelectableText(
                  opportunity.feasibility ?? "N/A",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              SelectableText(
                "Risks:",
                style: TextStyle(fontSize: 16, color: colorMap["mainColor"]),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: SelectableText(
                  opportunity.risks ?? "N/A",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              SelectableText(
                "Type:",
                style: TextStyle(fontSize: 16, color: colorMap["mainColor"]),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: SelectableText(
                  opportunity.type ?? "N/A",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              if (opportunity.descriptionLocation != null)
                SelectableText(
                  "Description File:",
                  style: TextStyle(fontSize: 16, color: colorMap["mainColor"]),
                ),
              if (opportunity.descriptionLocation != null)
                IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () {
                    FileDownloader.downloadFile(
                      url: "http://${ApiConstants.baseUrl}${opportunity.descriptionLocation}",
                      onDownloadCompleted: (path) {
                        sendNotification(
                          title: "Download is complete",
                          message: "download location: $path",
                        );
                      },
                      onDownloadError: (errorMessage) {
                        sendNotification(
                          title: "Download failed",
                          message: "download error message:  $errorMessage",
                        );
                      },
                    );
                  },
                ),
              SelectableText(
                "Description:",
                style: TextStyle(fontSize: 16, color: colorMap["mainColor"]),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: SelectableText(
                  opportunity.description ?? "N/A",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              SelectableText(
                "Recommendation:",
                style: TextStyle(fontSize: 16, color: colorMap["mainColor"]),
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
