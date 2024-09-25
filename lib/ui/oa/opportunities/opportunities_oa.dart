import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:co_spirit/data/model/opportunity.dart';
import 'package:co_spirit/ui/oa/opportunities/opportunity_view_oa.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

import '../../../core/app_util.dart';
import '../../../data/api/apimanager.dart';
import '../../../utils/helper_functions.dart';
import '../../../utils/theme/appColors.dart';
import '../Message/oppy_oa.dart';

class OpportunitiesPageOA extends StatefulWidget {
  const OpportunitiesPageOA({super.key});

  @override
  State<OpportunitiesPageOA> createState() => _OpportunitiesPageOAState();
}

class _OpportunitiesPageOAState extends State<OpportunitiesPageOA> {
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
      appBar: customAppBar(
        title: "Opportunities",
        context: context,
        backArrowColor: OAColorScheme.buttonColor,
        textColor: OAColorScheme.mainColor,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          loadingNotifier.change();
        },
        child: ListenableBuilder(
          listenable: loadingNotifier,
          builder: (context, child) {
            if (loadingNotifier.loading) {
              opportunitiesList(apiManager, loadingNotifier);
              return const Center(
                child: CircularProgressIndicator(color: OAColorScheme.buttonColor),
              );
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
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: OAColorScheme.mainColor,
                    radius: 25,
                    child: Center(
                      child: Icon(
                        Icons.circle,
                        color: Colors.white,
                        // size: 30,
                      ),
                    ),
                  ),
                  title: Text(
                    opportunity.title ?? "N/A",
                    style: const TextStyle(
                      fontSize: 16,
                      color: OAColorScheme.textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        opportunity.industry ?? "N/A",
                        style: const TextStyle(
                          fontSize: 14,
                          color: OAColorScheme.textColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        opportunity.status ?? "N/A",
                        style: const TextStyle(
                          fontSize: 14,
                          color: OAColorScheme.buttonColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  trailing: GestureDetector(
                    onTap: () => AppUtil.mainNavigator(
                      context,
                      OpportunityViewOA(opportunity: opportunity),
                    ),
                    onLongPress: () => AppUtil.mainNavigator(
                      context,
                      OppyOA(opportunityId: opportunity.id),
                    ),
                    child: const CircleAvatar(
                      backgroundColor: AppColor.SkyColor,
                      radius: 18,
                      child: Icon(
                        Icons.info_outline,
                        color: OAColorScheme.buttonColor,
                        size: 20,
                      ),
                    ),
                  ),
                );
              },
            );
          },
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
                  "Status:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
