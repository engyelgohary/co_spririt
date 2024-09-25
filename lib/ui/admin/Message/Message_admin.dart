import 'package:co_spirit/ui/admin/Message/chat_admin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/app_ui.dart';
import '../../../core/app_util.dart';
import '../../../core/components.dart';
import '../../../data/api/apimanager.dart';
import '../../../utils/helper_functions.dart';

class MessagesScreenAdmin extends StatefulWidget {
  const MessagesScreenAdmin({super.key});

  @override
  State<MessagesScreenAdmin> createState() => _MessagesScreenAdminState();
}

class _MessagesScreenAdminState extends State<MessagesScreenAdmin> {
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30), color: AppUI.secondColor),
                  child: const BackButton(
                    color: AppUI.whiteColor,
                  ),
                ),
                const SizedBox(
                  width: 100,
                ),
                const Center(
                  child: CustomText(
                    text: 'Messages',
                    fontSize: 20,
                    color: AppUI.basicColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            ListenableBuilder(
              listenable: loadingNotifier,
              builder: (context, child) {
                if (loadingNotifier.loading) {
                  collaboratorsList(apiManager, loadingNotifier);
                  return const Expanded(child: Center(child: CircularProgressIndicator()));
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

                final List<dynamic> data = loadingNotifier.response!;
                return SizedBox(
                  height: 680.h,
                  width: 600.w,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final dynamic collaborator = data[index];
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: InkWell(
                              onTap: () {
                                signalr.receiverId = collaborator.id;
                                AppUtil.mainNavigator(
                                  context,
                                  ChatScreenAdmin(
                                    receiverId: collaborator.id ?? 0,
                                    email: collaborator.email ?? "",
                                    name: collaborator.firstName ?? "",
                                    pictureLocation: collaborator.pictureLocation,
                                  ),
                                );
                              },
                              child: SizedBox(
                                // width: ,
                                height: 60,
                                child: Row(
                                  children: [
                                    collaboratorPhoto(collaborator.pictureLocation),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text: collaborator.firstName ?? "Unknown",
                                          fontSize: 15,
                                          color: AppUI.basicColor,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        CustomText(
                                          text: collaborator.email ?? "Unknown",
                                          fontSize: 12,
                                          color: AppUI.basicColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Container(
                                      alignment: Alignment.center,
                                      height: 29,
                                      width: 29,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          color: AppUI.secondColor),
                                      child: const ImageIcon(
                                        AssetImage(
                                          '${AppUI.iconPath}send.png',
                                        ),
                                        color: AppUI.whiteColor,
                                        size: 19,
                                      ),
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
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
