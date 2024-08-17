import 'package:co_spririt/data/api/apimanager.dart';
import 'package:co_spririt/data/model/message.dart';
import 'package:flutter/material.dart';

import '../../../core/app_ui.dart';
import '../../../core/components.dart';
import '../../../utils/components/messageBubble.dart';
import '../../../utils/helper_functions.dart';

class ChatScreenSuperAdmin extends StatelessWidget {
  final int receiverId;
  final String name;
  final String email;
  final String? pictureLocation;
  final TextEditingController messageController = TextEditingController();
  final ListNotifier<Message> listNotifier = ListNotifier(list: []);
  final LoadingStateNotifier<Message> loadingNotifier = LoadingStateNotifier();
  final ApiManager apiManager = ApiManager.getInstanace();

  ChatScreenSuperAdmin({
    super.key,
    required this.receiverId,
    required this.name,
    required this.email,
    this.pictureLocation,
  });

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
                          collaboratorPhoto(pictureLocation),
                          const SizedBox(
                            width: 8,
                          ),
                          SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: name,
                                  fontSize: 16,
                                  color: AppUI.basicColor,
                                  fontWeight: FontWeight.w700,
                                ),
                                CustomText(
                                  text: email,
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
                    collaboratorsMessages(receiverId, apiManager, loadingNotifier);
                  return const Expanded(child: Center(child: CircularProgressIndicator()));
                } else if (loadingNotifier.response==null) {
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
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            final message = list[index];
                            final bubble = CustomChatBubble(
                              messageText: message.content!,
                              imageUrl: "", //TODO implement image url
                              isSender: message.sender!,
                              time: message.time!,
                            );

                            if (index == 0 || message.date != list[index-1].date) {
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
                  onTap: () {
                    // TODO implement sending messages through api.
                    if (messageController.text.trim().isNotEmpty && !loadingNotifier.loading) {
                      listNotifier.addItem(
                          [messageController.text.trim(), "", true, currentTime(), currentDate()]);
                      messageController.clear();
                    }
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
