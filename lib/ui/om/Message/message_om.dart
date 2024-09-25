import 'package:co_spirit/ui/om/Message/chat_om.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/app_ui.dart';
import '../../../core/app_util.dart';
import '../../../core/components.dart';
import '../../../data/api/apimanager.dart';
import '../../../utils/helper_functions.dart';
import '../../../utils/theme/appColors.dart';

class MessagesScreenSuperAdmin extends StatefulWidget {
  const MessagesScreenSuperAdmin({super.key});

  @override
  State<MessagesScreenSuperAdmin> createState() => _MessagesScreenSuperAdminState();
}

class _MessagesScreenSuperAdminState extends State<MessagesScreenSuperAdmin> {
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 25),
          child: ListenableBuilder(
            listenable: loadingNotifier,
            builder: (context, child) {
              if (loadingNotifier.loading) {
                superAdminList(apiManager, loadingNotifier);
                return const Expanded(
                    child:
                        Center(child: CircularProgressIndicator(color: OMColorScheme.buttonColor)));
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
              return SizedBox(
                height: 680.h,
                width: 600.w,
                child: ListView.builder(
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
                                ChatScreenOM(
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
