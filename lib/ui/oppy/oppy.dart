import 'package:co_spirit/core/app_util.dart';
import 'package:co_spirit/core/components/components.dart';
import 'package:co_spirit/core/components/helper_functions.dart';
import 'package:co_spirit/core/components/message_bubble.dart';
import 'package:co_spirit/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/app_ui.dart';
import '../../../data/api/apimanager.dart';

class OppyScreen extends StatefulWidget {
  final int? opportunityId;
  final Color mainColor;
  final Color buttonColor;
  final Color textColor;
  const OppyScreen({
    this.opportunityId,
    super.key,
    required this.mainColor,
    required this.buttonColor,
    required this.textColor,
  });

  @override
  State<OppyScreen> createState() => _OppyOStateD();
}

class _OppyOStateD extends State<OppyScreen> {
  final TextEditingController messageController = TextEditingController();
  final ListNotifier listNotifier = ListNotifier(list: []);
  final LoadingStateNotifier loadingNotifier = LoadingStateNotifier();
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
        scrolledUnderElevation: 0,
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "Ask Oppy",
                  fontSize: 16,
                  color: widget.mainColor,
                  fontWeight: FontWeight.w700,
                ),
                const CustomText(
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
        iconTheme: IconThemeData(color: widget.buttonColor),
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
                  if (widget.opportunityId != null) {
                    oppyChatHistory(widget.opportunityId ?? 0, apiManager, loadingNotifier);
                    return const Expanded(
                        child: Center(
                            child: CircularProgressIndicator(color: OMColorScheme.buttonColor)));
                  } else {
                    print("Entered Oppy page without opportunity ID");
                    template = {"NewMessage": '', "GeneratedResult": '', "ChatHistory": []};
                    loadingNotifier.response = [template, []];
                    loadingNotifier.change();
                  }
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
                            final OppyChatBubble bubble;
                            if (list[index][0] == null) {
                              bubble = OppyChatBubble(
                                message: "",
                                loading: true,
                                isSender: list[index][1],
                                textColor: widget.textColor,
                                backgroundColor: widget.mainColor,
                              );
                            } else {
                              bubble = OppyChatBubble(
                                message: list[index][0],
                                isSender: list[index][1],
                                textColor: widget.textColor,
                                backgroundColor: widget.mainColor,
                              );
                            }
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
                            print(loadingNotifier.loading);
                            if (messageController.text.trim().isNotEmpty &&
                                !loadingNotifier.loading) {
                              sendOppyMessage(
                                widget.opportunityId ?? 0,
                                template,
                                messageController.text.trim(),
                                apiManager,
                                listNotifier,
                                scrollController,
                                storeChat: widget.opportunityId != null,
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
                          icon: Icon(
                            Icons.send,
                            color: widget.buttonColor,
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
