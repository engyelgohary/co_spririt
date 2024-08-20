import 'package:co_spririt/data/model/GetAdmin.dart';
import 'package:co_spririt/ui/collaborator/Message/chat_colla.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/app_ui.dart';
import '../../../core/app_util.dart';
import '../../../core/components.dart';
import '../../../data/api/apimanager.dart';
import '../../../utils/helper_functions.dart';

class MessagesScreenColla extends StatefulWidget {
  MessagesScreenColla({super.key});
  @override
  State<MessagesScreenColla> createState() => _MessagesScreenCollaState();
}

class _MessagesScreenCollaState extends State<MessagesScreenColla> {
  final LoadingStateNotifier<GetAdmin> loadingNotifier = LoadingStateNotifier();
  final ListNotifier<GetAdmin> listNotifier = ListNotifier(list: []);

  final ApiManager apiManager = ApiManager.getInstance();

  final signalr = Signalr();
  @override
  void dispose() {
    signalr.connection.stop();
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
                  collaboratorAdminsList(apiManager, loadingNotifier);
                  signalr.start();
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

                final List<GetAdmin> data = loadingNotifier.response!;
                return SizedBox(
                  height: 680.h,
                  width: 600.w,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final GetAdmin admin = data[index];
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: InkWell(
                              onTap: () {
                                signalr.receiverId = admin.id;
                                AppUtil.mainNavigator(
                                  context,
                                  ChatScreenColla(
                                    receiverId: admin.id ?? 0,
                                    email: admin.email ?? "",
                                    name: admin.firstName ?? "",
                                    pictureLocation: admin.pictureLocation,
                                  ),
                                );
                              },
                              child: SizedBox(
                                // width: ,
                                height: 60,
                                child: Row(
                                  children: [
                                    collaboratorPhoto(admin.pictureLocation),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            text: admin.firstName ?? "Unknown",
                                            fontSize: 15,
                                            color: AppUI.basicColor,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          CustomText(
                                            text: admin.email ?? "Unknown",
                                            fontSize: 12,
                                            color: AppUI.basicColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ],
                                      ),
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
