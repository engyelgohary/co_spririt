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
        title: Text(
          "Opportunities V2",
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
              child: Text("Nothing to show."),
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
              return Card(
                color: AppColor.backgroundColor,
                elevation: 0,
                child: ListTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Title:",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    "Industry:",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    "Feasibility:",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    "Risks:",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    "Type:",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    "Description File:",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    opportunity.title ?? "N/A",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    opportunity.industry ?? "N/A",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    opportunity.feasibility ?? "N/A",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    opportunity.risks ?? "N/A",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    opportunity.type ?? "N/A",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.download),
                                    onPressed: () {
                                      if (opportunity.descriptionLocation != null) {
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
                                      }
                                    },
                                  )
                                ],
                              ),
                            ),
                          ],
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
                  trailing: CircleAvatar(
                    backgroundColor: AppColor.SkyColor,
                    radius: 18.r,
                    child: const Icon(
                      Icons.info_outline,
                      color: AppColor.secondColor,
                      size: 20,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
