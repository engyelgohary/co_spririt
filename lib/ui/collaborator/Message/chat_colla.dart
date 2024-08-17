import 'package:flutter/material.dart';

import '../../../core/app_ui.dart';
import '../../../core/components.dart';
import '../../../data/api/apimanager.dart';
import '../../../data/model/message.dart';
import '../../../utils/components/messageBubble.dart';
import '../../../utils/helper_functions.dart';

class ChatScreenColla extends StatefulWidget {
  final int receiverId;
  final String name;
  final String email;
  final String? pictureLocation;

  const ChatScreenColla({
    super.key,
    required this.receiverId,
    required this.name,
    required this.email,
    this.pictureLocation,
  });

  @override
  State<ChatScreenColla> createState() => _ChatScreenCollaState();
}

class _ChatScreenCollaState extends State<ChatScreenColla> {
  final Signalr signalr = Signalr();
  final TextEditingController messageController = TextEditingController();
  final ListNotifier<Message> listNotifier = ListNotifier(list: []);
  final LoadingStateNotifier<Message> loadingNotifier = LoadingStateNotifier();
  final ApiManager apiManager = ApiManager.getInstanace();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    signalr.listNotifier = listNotifier;
    signalr.scrollController = scrollController;
    print("Signlar receiverId : ${signalr.receiverId}");
    print("Signlar senderId : ${signalr.senderId}");
    print("Signlar list : ${signalr.listNotifier == null}");
    super.initState();
  }

  @override
  void dispose() {
    signalr.listNotifier = null;
    signalr.receiverId = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Container(
            height: 135,
            decoration:
                BoxDecoration(color: AppUI.whiteColor, borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      const Center(
                        child: CustomText(
                          text: 'Messages',
                          fontSize: 20,
                          color: AppUI.basicColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Container(
                        height: 42,
                        width: 42,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30), color: AppUI.secondColor),
                        child: const ImageIcon(
                          AssetImage(
                            '${AppUI.iconPath}chatmenu.png',
                          ),
                          color: AppUI.whiteColor,
                          size: 42,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
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
                              color: AppUI.basicColor,
                              fontWeight: FontWeight.w700,
                            ),
                            CustomText(
                              text: widget.email,
                              fontSize: 12,
                              color: AppUI.basicColor,
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

                listNotifier.list = loadingNotifier.response!;
                return Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ListenableBuilder(
                      listenable: listNotifier,
                      builder: (context, child) {
                        List<Message> list = listNotifier.list;
                        return ListView.builder(
                          controller: scrollController,
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            final message = list[index];
                            final bubble = CustomChatBubble(
                              messageText: message.content!,
                              imageUrl: "", //TODO implement image url
                              isSender: message.sender!,
                              time: message.time!,
                            );

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
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CustomInput(
                    borderColor: const Color.fromRGBO(241, 241, 241, 1),
                    fillColor: const Color.fromRGBO(241, 241, 241, 1),
                    //counterColor: AppUI.borderColor,
                    //radius: 24,
                    controller: messageController,
                    hint: "Type a message ...",
                    textInputType: TextInputType.text,
                    suffixIcon: const SizedBox(
                      width: 55,
                      child: Row(
                        children: [
                          ImageIcon(
                            AssetImage(
                              '${AppUI.iconPath}file.png',
                            ),
                            color: AppUI.twoBasicColor,
                            size: 20,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          ImageIcon(
                            AssetImage(
                              '${AppUI.iconPath}chatcamera.png',
                            ),
                            color: AppUI.twoBasicColor,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                InkWell(
                  onTap: () async {
                    print("jumped");
                    if (messageController.text.trim().isNotEmpty && !loadingNotifier.loading) {
                      sendMessage(
                        widget.receiverId,
                        messageController.text.trim(),
                        apiManager,
                        listNotifier,
                      );

                      messageController.clear();
                    }
                    Future.delayed(
                      const Duration(milliseconds: 300),
                      () => scrollController.animateTo(scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 300), curve: Curves.easeOut),
                    );
                  },
                  child: Container(
                    height: 44,
                    width: 42,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: AppUI.secondColor,
                    ),
                    child: const ImageIcon(
                      AssetImage(
                        '${AppUI.iconPath}send.png',
                      ),
                      color: AppUI.whiteColor,
                      size: 44,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
