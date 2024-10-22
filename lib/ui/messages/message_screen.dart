import 'package:co_spirit/core/components/appbar.dart';
import 'package:co_spirit/core/components/components.dart';
import 'package:co_spirit/core/components/helper_functions.dart';
import 'package:co_spirit/ui/messages/om_chat.dart';
import 'package:flutter/material.dart';

import '../../../core/app_ui.dart';
import '../../../core/app_util.dart';
import '../../../data/api/apimanager.dart';

class MessagesScreen<T> extends StatefulWidget {
  final Color mainColor;
  final Color buttonColor;
  final Color textColor;
  const MessagesScreen(
      {super.key, required this.mainColor, required this.buttonColor, required this.textColor});
  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
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
        textColor: widget.mainColor,
        backArrowColor: widget.buttonColor,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width / 25),
        child: ListenableBuilder(
          listenable: loadingNotifier,
          builder: (context, child) {
            if (loadingNotifier.loading) {
              superAdminList(apiManager, loadingNotifier);

              return Center(child: CircularProgressIndicator(color: widget.buttonColor));
            } else if (loadingNotifier.response == null) {
              return Center(
                child: buildErrorIndicator(
                  "Some error occurred, Please try again.",
                  () => loadingNotifier.change(),
                ),
              );
            }

            final List<dynamic> data = loadingNotifier.response!;
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: data.length,
              itemBuilder: (context, index) {
                final admin = data[index];
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: InkWell(
                        onTap: () {
                          signalr.receiverId = admin.id;
                          AppUtil.mainNavigator(
                            context,
                            ChatScreen(
                              receiverId: admin.id ?? 0,
                              email: admin.email ?? "",
                              name: admin.firstName ?? "",
                              pictureLocation: admin.pictureLocation,
                            ),
                          );
                        },
                        child: SizedBox(
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
                                    color: widget.textColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  CustomText(
                                    text: admin.email ?? "Unknown",
                                    fontSize: 12,
                                    color: widget.textColor,
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
            );
          },
        ),
      ),
    );
  }
}
