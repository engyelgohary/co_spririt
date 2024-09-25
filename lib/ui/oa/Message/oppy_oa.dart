import 'package:co_spirit/core/app_util.dart';
import 'package:co_spirit/utils/theme/appColors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/app_ui.dart';
import '../../../core/components.dart';
import '../../../data/api/apimanager.dart';
import '../../../data/model/message.dart';
import '../../../utils/components/messageBubble.dart';
import '../../../utils/helper_functions.dart';

class OppyOA extends StatefulWidget {
  int? opportunityId;
  OppyOA({
    this.opportunityId,
    super.key,
  });

  @override
  State<OppyOA> createState() => _OppyOStateD();
}

class _OppyOStateD extends State<OppyOA> {
  final TextEditingController messageController = TextEditingController();
  final ListNotifier listNotifier = ListNotifier(list: []);
  final LoadingStateNotifier loadingNotifier = LoadingStateNotifier(loading: false);
  final ApiManager apiManager = ApiManager.getInstance();
  final ScrollController scrollController = ScrollController();
  Map template = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    listNotifier.dispose();
    loadingNotifier.dispose();
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = AppUtil.responsiveHeight(context);
    double width = AppUtil.responsiveWidth(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: EdgeInsets.only(left: width / 25),
          child: Center(
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              onPressed: () => snackBar(context, "Not implemented"),
              icon: const Icon(Icons.more_horiz),
            ),
          ),
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "${AppUI.svgPath}oppy.svg",
              colorFilter: const ColorFilter.mode(Colors.blue, BlendMode.srcIn),
              height: 30,
            ),
            const SizedBox(width: 8),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "Ask Oppy",
                  fontSize: 16,
                  color: OAColorScheme.mainColor,
                  fontWeight: FontWeight.w700,
                ),
                CustomText(
                  text: "● Online ",
                  fontSize: 12,
                  color: Colors.green,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
          ],
        ),
        toolbarHeight: height / 8,
        iconTheme: const IconThemeData(color: OAColorScheme.buttonColor),
      ),
      body: Column(
        children: [
          Container(
            height: 15,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                color: AppUI.whiteColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12))),
          ),
          ListenableBuilder(
              listenable: loadingNotifier,
              builder: (context, child) {
                if (loadingNotifier.loading) {
                  oppyChatHistory(widget.opportunityId ?? 0, apiManager, loadingNotifier);
                  return const Expanded(
                      child: Center(
                          child: CircularProgressIndicator(color: OAColorScheme.buttonColor)));
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
                print(loadingNotifier.response);
                template = loadingNotifier.response![0];
                listNotifier.list = loadingNotifier.response![1];

                return Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListenableBuilder(
                      listenable: listNotifier,
                      builder: (context, child) {
                        final list = listNotifier.list;
                        return ListView.builder(
                          controller: scrollController,
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            final bubble = OppyChatBubble(
                              message: list[index][0],
                              isSender: list[index][1],
                              textColor: OMColorScheme.textColor,
                              backgroundColor: OMColorScheme.mainColor,
                            );
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: bubble,
                            );
                          },
                        );
                      },
                    ),
                  ),
                );
              }),
          Padding(
            // message box
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CustomInput(
                    borderColor: const Color.fromRGBO(241, 241, 241, 1),
                    fillColor: const Color.fromRGBO(241, 241, 241, 1),
                    radius: 30,
                    controller: messageController,
                    hint: "Type a message ...",
                    textInputType: TextInputType.text,
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () async {
                            if (messageController.text.trim().isNotEmpty &&
                                !loadingNotifier.loading) {
                              sendOppyMessage(
                                widget.opportunityId ?? 0,
                                template,
                                messageController.text.trim(),
                                apiManager,
                                listNotifier,
                                scrollController,
                              );
                              messageController.clear();
                            }
                            Future.delayed(
                              const Duration(milliseconds: 300),
                              () => scrollController.animateTo(
                                  scrollController.position.maxScrollExtent,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut),
                            );
                          },
                          icon: const Icon(
                            Icons.send,
                            color: OAColorScheme.buttonColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
