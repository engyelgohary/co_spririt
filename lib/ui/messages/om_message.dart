import 'package:co_spirit/core/components/appbar.dart';
import 'package:co_spirit/core/components/components.dart';
import 'package:co_spirit/core/components/helper_functions.dart';
import 'package:co_spirit/core/theme/app_colors.dart';
import 'package:co_spirit/ui/messages/om_chat.dart';
import 'package:flutter/material.dart';

import '../../core/app_ui.dart';
import '../../core/app_util.dart';
import '../../data/api/apimanager.dart';

class MessagesScreenOM extends StatefulWidget {
  const MessagesScreenOM({super.key});

  @override
  State<MessagesScreenOM> createState() => _MessagesScreenOMState();
}

class _MessagesScreenOMState extends State<MessagesScreenOM> {
  final LoadingStateNotifier<dynamic> loadingNotifier = LoadingStateNotifier();
  final ApiManager apiManager = ApiManager.getInstance();
  final Signalr signalr = Signalr();

  @override
  void dispose() {
    loadingNotifier.dispose();
    signalr.listNotifier = null;
    signalr.receiverId = null;
    signalr.scrollController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = AppUtil.responsiveWidth(context);

    return Scaffold(
      appBar: customAppBar(
        title: "Messages",
        context: context,
        textColor: OMColorScheme.textColor,
        backArrowColor: OMColorScheme.mainColor,
      ),
      body: ListenableBuilder(
        listenable: loadingNotifier,
        builder: (context, child) {
          if (loadingNotifier.loading) {
            superAdminList(apiManager, loadingNotifier);
            return Center(child: CircularProgressIndicator(color: OMColorScheme.buttonColor));
          } else if (loadingNotifier.response == null) {
            return Expanded(
              child: Center(
                child: buildErrorIndicator(
                  "Some error occurred, Please try again.",
                  () => loadingNotifier.change(),
                ),
              ),
            );
          }

          final List data = loadingNotifier.response!;

          return ListView.builder(
            padding: EdgeInsets.only(left: width / 25, right: width / 25, bottom: 32),
            scrollDirection: Axis.vertical,
            itemCount: data.length,
            itemBuilder: (context, index) {
              final recipient = data[index];
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: InkWell(
                      onTap: () {
                        AppUtil.mainNavigator(
                          context,
                          ChatScreen(
                            receiverId: recipient.id ?? 0,
                            email: recipient.email ?? "",
                            name: recipient.firstName ?? "",
                            pictureLocation: recipient.pictureLocation,
                          ),
                        );
                      },
                      child: SizedBox(
                        height: 60,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                collaboratorPhoto(recipient.pictureLocation),
                                const SizedBox(
                                  width: 12,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: recipient.firstName ?? "Unknown",
                                      fontSize: 15,
                                      color: OMColorScheme.textColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    CustomText(
                                      text: recipient.email ?? "Unknown",
                                      fontSize: 12,
                                      color: OMColorScheme.textColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    thickness: 2,
                    color: AppUI.whiteColor,
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}
