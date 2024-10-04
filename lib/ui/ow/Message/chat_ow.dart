import 'package:co_spirit/utils/theme/appColors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../core/app_ui.dart';
import '../../../core/components.dart';
import '../../../data/api/apimanager.dart';
import '../../../data/model/message.dart';
import '../../../utils/components/messageBubble.dart';
import '../../../utils/helper_functions.dart';

class ChatScreenOW extends StatefulWidget {
  final int receiverId;
  final String name;
  final String email;
  final String? pictureLocation;

  const ChatScreenOW({
    super.key,
    required this.receiverId,
    required this.name,
    required this.email,
    this.pictureLocation,
  });

  @override
  State<ChatScreenOW> createState() => _ChatScreenOWState();
}

class _ChatScreenOWState extends State<ChatScreenOW> {
  final Signalr signalr = Signalr();
  final TextEditingController messageController = TextEditingController();
  final ListNotifier<Message> listNotifier = ListNotifier(list: []);
  final LoadingStateNotifier<Message> loadingNotifier = LoadingStateNotifier();
  final ApiManager apiManager = ApiManager.getInstance();
  final ScrollController scrollController = ScrollController();
  Set<String> selectedAttachments = {};

  @override
  void initState() {
    signalr.listNotifier = listNotifier;
    signalr.scrollController = scrollController;
    super.initState();
  }

  @override
  void dispose() {
    listNotifier.dispose();
    loadingNotifier.dispose();
    messageController.dispose();
    scrollController.dispose();
    signalr.listNotifier = null;
    signalr.receiverId = null;
    signalr.scrollController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: customAppBar(
        title: "Messages",
        context: context,
        backArrowColor: OWColorScheme.buttonColor,
        textColor: OWColorScheme.mainColor,
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              onPressed: () => snackBar(context, "Not implemented"),
              icon: const Icon(Icons.more_horiz),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
                color: AppUI.whiteColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                )),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0, left: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      collaboratorPhoto(widget.pictureLocation),
                      const SizedBox(
                        width: 4,
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: widget.name,
                              fontSize: 16,
                              color: OWColorScheme.mainColor,
                              fontWeight: FontWeight.w700,
                            ),
                            CustomText(
                              text: widget.email,
                              fontSize: 12,
                              color: OWColorScheme.mainColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ListenableBuilder(
              listenable: loadingNotifier,
              builder: (context, child) {
                if (loadingNotifier.loading) {
                  collaboratorsMessages(widget.receiverId, apiManager, loadingNotifier);
                  return const Expanded(
                      child: Center(
                          child: CircularProgressIndicator(color: OWColorScheme.buttonColor)));
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

                listNotifier.list = loadingNotifier.response!;
                return Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListenableBuilder(
                      listenable: listNotifier,
                      builder: (context, child) {
                        List<Message> list = listNotifier.list;
                        return ListView.builder(
                          controller: scrollController,
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            final message = list[index];
                            final bubble = CustomChatBubble(message: message);

                            if (index == 0 || message.date != list[index - 1].date) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                      child: Text(message.date!),
                                    ),
                                    bubble
                                  ],
                                ),
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
                    fillColor: const Color.fromRGBO(241, 241, 241, 1),
                    radius: 30,
                    controller: messageController,
                    hint: "Type a message ...",
                    textInputType: TextInputType.text,
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () async {
                            final res = await FilePicker.platform.pickFiles(allowMultiple: true);
                            if (res != null) {
                              for (var file in res.files) {
                                selectedAttachments.add(file.path!);
                              }
                            }
                          },
                          child: const ImageIcon(
                            AssetImage(
                              '${AppUI.iconPath}file.png',
                            ),
                            color: AppUI.twoBasicColor,
                            size: 20,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            if (messageController.text.trim().isNotEmpty &&
                                !loadingNotifier.loading) {
                              sendMessage(widget.receiverId, messageController.text.trim(),
                                  apiManager, listNotifier, selectedAttachments.toList());
                              messageController.clear();
                              selectedAttachments.clear();
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
                            color: OWColorScheme.buttonColor,
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
