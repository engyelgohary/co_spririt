import 'package:co_spririt/data/model/Collaborator.dart';
import 'package:co_spririt/ui/admin/Message/chat_admin.dart';
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
  final LoadingStateNotifier<Collaborator> loadingNotifier = LoadingStateNotifier();
  final ApiManager apiManager = ApiManager.getInstance();
  final Signalr signalr = Signalr();

  @override
  void initState() {
    signalr.start();
    super.initState();
  }

  @override
  void dispose() {
    signalr.dispose();
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

                final List<Collaborator> data = loadingNotifier.response!;
                return SizedBox(
                  height: 680.h,
                  width: 600.w,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final Collaborator collaborator = data[index];
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
                                    SizedBox(
                                      width: 100,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            text: collaborator.firstName ?? "Unknown",
                                            fontSize: 15,
                                            color: AppUI.basicColor,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          const CustomText(
                                            text: 'Lorem ipsum dolor sit amet .....',
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
                                      child: const CustomText(
                                        text: '3',
                                        fontSize: 15,
                                        color: AppUI.whiteColor,
                                        fontWeight: FontWeight.w400,
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
