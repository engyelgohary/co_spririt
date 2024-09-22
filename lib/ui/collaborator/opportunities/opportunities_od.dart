import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:co_spririt/data/model/opportunity.dart';
import 'package:co_spririt/ui/collaborator/opportunities/add_opportunities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/app_util.dart';
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

class OpportunitiesPageOD extends StatefulWidget {
  const OpportunitiesPageOD({super.key});

  @override
  State<OpportunitiesPageOD> createState() => _OpportunitiesPageODState();
}

class _OpportunitiesPageODState extends State<OpportunitiesPageOD> {
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
      floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.add,
            color: AppColor.secondColor,
          ),
          onPressed: () => AppUtil.mainNavigator(context, const AddOpportunitiesV2())),
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
              ],
            ),
          ),
        ),
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
