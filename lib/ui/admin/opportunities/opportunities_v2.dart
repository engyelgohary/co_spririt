import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:co_spririt/data/model/opportunity.dart';
import 'package:co_spririt/utils/components/textFormField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/api/apimanager.dart';
import '../../../utils/components/appbar.dart';
import '../../../utils/helper_functions.dart';
import '../../../utils/theme/appColors.dart';

final statusColors = {
  "Submitted": Colors.black,
  "Review": Colors.amber,
  "Rejected": Colors.red,
  "Accepted": Colors.green
};

class OpportunitiesV2 extends StatefulWidget {
  const OpportunitiesV2({super.key});

  @override
  State<OpportunitiesV2> createState() => _OpportunitiesV2State();
}

class _OpportunitiesV2State extends State<OpportunitiesV2> {
  final LoadingStateNotifier<Opportunity> loadingNotifier = LoadingStateNotifier();
  final ApiManager apiManager = ApiManager.getInstance();
  @override
  void dispose() {
    loadingNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SelectableText(
          "Opportunities",
          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 20),
        ),
        leading: const AppBarCustom(),
      ),
      body: ListenableBuilder(
        listenable: loadingNotifier,
        builder: (context, child) {
          if (loadingNotifier.loading) {
            opportunitiesList(apiManager, loadingNotifier);
            return const Center(child: CircularProgressIndicator());
          } else if (loadingNotifier.response == null) {
            return Center(
              child: buildErrorIndicator(
                "Some error occurred, Please try again.",
                () => loadingNotifier.change(),
              ),
            );
          } else if (loadingNotifier.response!.isEmpty) {
            return const Center(
              child: SelectableText("Nothing to show."),
            );
          }

          final data = loadingNotifier.response;

          return ListView.separated(
            separatorBuilder: (context, index) {
              return const Divider(
                color: AppColor.whiteColor,
                thickness: 2,
              );
            },
            itemCount: data!.length,
            itemBuilder: (context, index) {
              final opportunity = data[index];
              return opportunityCard(opportunity, loadingNotifier);
            },
          );
        },
      ),
    );
  }

  dynamic opportunityCard(Opportunity opportunity, LoadingStateNotifier loadingNotifier) {
    return SizedBox(
      height: 180.h,
      child: GestureDetector(
        onTap: () {
          opportunityPopup(context, opportunity);
        },
        child: Card(
          margin: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${opportunity.title}", style: const TextStyle(fontSize: 18.0)),
                    Icon(Icons.circle, color: statusColors[opportunity.status] ?? Colors.teal)
                  ],
                ),
                const SizedBox(height: 8.0),
                Text("Client: ${opportunity.clientId}", style: const TextStyle(fontSize: 16.0)),
                const SizedBox(height: 8.0),
                const SizedBox(height: 8.0),
                const Text('Description:', style: TextStyle(fontSize: 16.0)),
                Expanded(child: Text("${opportunity.description}")),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColor.secondColor,
                          radius: 20,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'OD name',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    PopupMenuButton(
                      onSelected: (value) async {
                        if (opportunity.id == null) {
                          return;
                        } else if (value == "Delete") {
                          loadingIndicatorDialog(context);
                          try {
                            await apiManager.deleteOpportunity(opportunity.id ?? 0);
                            loadingNotifier.change();
                          } catch (e) {
                            snackBar(context, "Could not delete opportunity");
                          }
                          Navigator.of(context).pop();
                        } else if (value == "Update") {
                          loadingIndicatorDialog(context);
                          try {
                            final status = await apiManager.getOpportunityStatus();
                            Navigator.of(context).pop();
                            updateStatusDialog(opportunity.id ?? 0, 0,
                                status); // TODO change these hardcoded things
                          } catch (e) {
                            Navigator.of(context).pop();
                            snackBar(context, "Could not get opportunity status");
                          }
                        }
                      },
                      child: const Icon(Icons.settings),
                      itemBuilder: (context) {
                        return [
                          const PopupMenuItem(value: "Delete", child: Text("Delete")),
                          const PopupMenuItem(value: "Update", child: Text("Update")),
                        ];
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> updateStatusDialog(int id, double score, List status) {
    status = status.map((e) => e["name"]).toList();
    TextEditingController updatedStatus = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomDropDownMenu(
              fieldName: "Status",
              selection: updatedStatus,
              dropDownOptions: status,
            ),
            StatefulBuilder(
              builder: (context, setState) => Slider(
                value: score,
                divisions: 10,
                min: 0,
                max: 10,
                label: score.round().toString(),
                onChanged: (value) => setState(
                  () => score = value,
                ),
              ),
            )
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Update"),
            onPressed: () async {
              if (updatedStatus.text.isEmpty) {
                return;
              }
              loadingIndicatorDialog(context);
              try {
                await apiManager.updateOpportunityStatus(id, updatedStatus.text, score.toInt());
                snackBar(context, "Opportunity status changed successfully");
              } catch (e) {
                snackBar(context, "Could not get opportunity status");
              }
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              loadingNotifier.change();
            },
          )
        ],
      ),
    );
  }

  Future<dynamic> opportunityPopup(BuildContext context, Opportunity opportunity) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.all(32.0),
        content: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height / 0.75,
              maxWidth: MediaQuery.of(context).size.width / 0.75),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisSize: MainAxisSize.min,
              children: [
                const SelectableText(
                  "Title:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: SelectableText(
                    opportunity.title ?? "N/A",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SelectableText(
                  "Industry:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: SelectableText(
                    opportunity.industry ?? "N/A",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SelectableText(
                  "Feasibility:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                              body: "download location: ${path}",
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
                              body: "download error message:  ${errorMessage}",
                              notificationLayout: NotificationLayout.BigText,
                            ),
                          );
                        },
                      );
                    },
                  ),
                const SelectableText(
                  "Description:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: SelectableText(
                    opportunity.result ?? "N/A",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Ok"),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }
}
