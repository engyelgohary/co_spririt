import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/app_ui.dart';
import '../../../utils/components/messageBubble.dart';
import '../../../core/components.dart';
import '../../../utils/components/messageBuble.dart';

class ChatScreenSuperAdmin extends StatelessWidget {
  ChatScreenSuperAdmin({super.key});
  final TextEditingController messageController = TextEditingController();
  final ListNotifier stringListNotifier = ListNotifier(list: List.from(messages));
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
                          Image.asset(
                            '${AppUI.imgPath}photo.png',
                            height: 41,
                            width: 42,
                            // fit: BoxFit.cover,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const SizedBox(
                            width: 100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: 'Matteo',
                                  fontSize: 16,
                                  color: AppUI.basicColor,
                                  fontWeight: FontWeight.w700,
                                ),
                                CustomText(
                                  text: 'MR@gmail,com',
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
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListenableBuilder(
                listenable: stringListNotifier,
                builder: (context, child) {
                  final list = stringListNotifier.list;
                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final bubble = CustomChatBubble(
                        messageText: list[index][0],
                        imageUrl: list[index][1],
                        isSender: list[index][2],
                        time: list[index][3],
                      );

                      if (index == 0 || list[index][4] != list[index - 1][4]) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Column(
                            children: [Text(list[index][4]), bubble],
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
          ),
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
                    if (messageController.text.trim().isNotEmpty) {
                      stringListNotifier.addItem(
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
