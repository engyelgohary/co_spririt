import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:co_spirit/core/app_util.dart';
import 'package:co_spirit/data/api/apimanager.dart';
import 'package:co_spirit/data/model/opportunity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  @override
  void initState() {
    super.initState();
    opportunity = widget.opportunity;
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
          IconButton(
            icon: const Icon(Icons.mode_edit_outlined),
            onPressed: () async {
              final updatedOpportunity = await Navigator.push<Opportunity?>(
                context,
                MaterialPageRoute(
                  builder: (context) => EditOpportunityPage(
                    opportunity: opportunity,
                  ),
                ),
              );

              if (updatedOpportunity != null && mounted) {
                setState(() {
                  print("Updated Opportunity: ${updatedOpportunity.status}");
                  opportunity= updatedOpportunity;
                });
              }
            },
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
                  SizedBox(width: 35.w),
                  SelectableText(
                    opportunity.clientName ?? "N/A",
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              Row(
                children: [
                  const SelectableText(
                    "Opportunity Title:",
                    style: TextStyle(fontSize: 16, color: OMColorScheme.mainColor),
                  ),
                  SizedBox(width: 35.w),
                  SelectableText(
                    opportunity.title ?? "N/A",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              Row(
                children: [
                  const SelectableText(
                    "Feasibility:",
                    style: TextStyle(fontSize: 16, color: OMColorScheme.mainColor),
                  ),
                  SizedBox(width: 35.w),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: SelectableText(
                      opportunity.feasibility ?? "N/A",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              Row(
                children: [
                  const SelectableText(
                    "Risks:",
                    style: TextStyle(fontSize: 16, color: OMColorScheme.mainColor),
                  ),
                  SizedBox(width: 35.w),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: SelectableText(
                      opportunity.risks ?? "N/A",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              Row(
                children: [
                  const SelectableText(
                    "Type:",
                    style: TextStyle(fontSize: 16, color: OMColorScheme.mainColor),
                  ),
                  SizedBox(width: 35.w),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: SelectableText(
                      opportunity.type ?? "N/A",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              Row(
                children: [
                  const SelectableText(
                    "Status:",
                    style: TextStyle(fontSize: 16, color: OMColorScheme.mainColor),
                  ),
                  SizedBox(width: 50.w),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: SelectableText(
                      opportunity.status ?? "N/A",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              Row(
                children: [
                  const SelectableText(
                    "Assigned To:",
                    style: TextStyle(fontSize: 16, color: OMColorScheme.mainColor),
                  ),
                  SizedBox(width: 35.w),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: SelectableText(
                      opportunity.teamName ?? "N/A",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.h),
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
              SizedBox(height: 15.h),
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
