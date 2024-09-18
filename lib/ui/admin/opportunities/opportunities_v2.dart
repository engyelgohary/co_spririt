import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:co_spririt/data/model/opportunity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/api/apimanager.dart';
import '../../../utils/components/appbar.dart';
import '../../../utils/helper_functions.dart';
import '../../../utils/theme/appColors.dart';

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
              return ListTile(
                onTap: () {
                  showDialog(
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
                                      url:
                                          "http://${ApiConstants.baseUrl}${opportunity.descriptionLocation}",
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
                },
                leading: const CircleAvatar(
                  backgroundColor: AppColor.secondColor,
                  radius: 25,
                  child: Center(
                    child: Icon(
                      Icons.lightbulb_sharp,
                      color: Colors.white,
                    ),
                  ),
                ),
                title: Text(opportunity.title ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontWeight: FontWeight.w600)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${opportunity.industry}",
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontWeight: FontWeight.w400, fontSize: 12),
                    ),
                  ],
                ),
                trailing: GestureDetector(
                  onTap: () {
                    deleteOpportunityButton(apiManager, loadingNotifier, opportunity.id ?? 0);
                  },
                  child: CircleAvatar(
                    backgroundColor: AppColor.SkyColor,
                    radius: 18.r,
                    child: const Icon(
                      Icons.delete,
                      color: AppColor.errorColor,
                      size: 20,
                    ),
                  ),
                ),
                // CircleAvatar(
                //   backgroundColor: AppColor.SkyColor,
                //   radius: 18.r,
                //   child: const Icon(
                //     Icons.info_outline,
                //     color: AppColor.secondColor,
                //     size: 20,
                //   ),
                // ),
              );
            },
          );
        },
      ),
    );
  }
}
