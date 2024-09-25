import 'package:co_spirit/data/model/GetAdmin.dart';
import 'package:co_spirit/ui/od/Message/chat_od.dart';
import 'package:co_spirit/utils/theme/appColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/app_ui.dart';
import '../../../core/app_util.dart';
import '../../../core/components.dart';
import '../../../data/api/apimanager.dart';
import '../../../utils/helper_functions.dart';

class MessagesScreenOA extends StatefulWidget {
  const MessagesScreenOA({super.key});
  @override
  State<MessagesScreenOA> createState() => _MessagesScreenOAState();
}

class _MessagesScreenOAState extends State<MessagesScreenOA> {
  final LoadingStateNotifier<dynamic> loadingNotifier = LoadingStateNotifier();
  final ApiManager apiManager = ApiManager.getInstance();
  final signalr = Signalr();

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
        textColor: OAColorScheme.mainColor,
        backArrowColor: OAColorScheme.buttonColor,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width / 25),
        child: Column(
          children: [
            ListenableBuilder(
              listenable: loadingNotifier,
              builder: (context, child) {
                if (loadingNotifier.loading) {
                  OAMessagesContactList(apiManager, loadingNotifier);
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
                                  ChatScreenOD(
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
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text: admin.firstName ?? "Unknown",
                                          fontSize: 15,
                                          color: OAColorScheme.textColor,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        CustomText(
                                          text: admin.email ?? "Unknown",
                                          fontSize: 12,
                                          color: OAColorScheme.textColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
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
