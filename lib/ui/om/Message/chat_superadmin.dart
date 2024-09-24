import 'package:co_spririt/data/api/apimanager.dart';
import 'package:co_spririt/data/model/message.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../core/app_ui.dart';
import '../../../core/components.dart';
import '../../../utils/components/messageBubble.dart';
import '../../../utils/helper_functions.dart';

class ChatScreenSuperAdmin extends StatefulWidget {
  final int receiverId;
  final String name;
  final String email;
  final String? pictureLocation;

  const ChatScreenSuperAdmin({
    super.key,
    required this.receiverId,
    required this.name,
    required this.email,
    this.pictureLocation,
  });

  @override
  State<ChatScreenSuperAdmin> createState() => _ChatScreenSuperAdminState();
}

class _ChatScreenSuperAdminState extends State<ChatScreenSuperAdmin> {
  final TextEditingController messageController = TextEditingController();
  final ListNotifier<Message> listNotifier = ListNotifier(list: []);
  final LoadingStateNotifier<Message> loadingNotifier = LoadingStateNotifier();
  final ApiManager apiManager = ApiManager.getInstance();
  final ScrollController scrollController = ScrollController();
  final Signalr signalr = Signalr();
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
      body: Column(
        children: [
          const SizedBox(
            // App bar
            height: 30,
          ),
          Container(
            height: 145,
            decoration:
                BoxDecoration(color: AppUI.whiteColor, borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
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
                    height: 20,
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          collaboratorPhoto(widget.pictureLocation),
                          const SizedBox(
                            width: 8,
                          ),
                          SizedBox(
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
                            final bubble = CustomChatBubble(message: message);

                            if (index == 0 || message.date != list[index - 1].date) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Column(
                                  children: [Text(message.date!), bubble],
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
                    suffixIcon: SizedBox(
                      width: 55,
                      child: Row(
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
                          // SizedBox(
                          //   width: 8,
                          // ),
                          // InkWell(
                          //   onTap: () {},
                          //   child: ImageIcon(
                          //     AssetImage(
                          //       '${AppUI.iconPath}chatcamera.png',
                          //     ),
                          //     color: AppUI.twoBasicColor,
                          //     size: 20,
                          //   ),
                          // ),
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
                    if (messageController.text.trim().isNotEmpty && !loadingNotifier.loading) {
                      sendMessage(widget.receiverId, messageController.text.trim(), apiManager,
                          listNotifier, selectedAttachments.toList());
                      selectedAttachments.clear();
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
