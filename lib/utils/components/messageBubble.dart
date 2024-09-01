import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:co_spririt/data/model/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:co_spririt/utils/theme/appColors.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

import '../../data/api/apimanager.dart';

class CustomChatBubble extends StatelessWidget {
  final Message message;
  const CustomChatBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> images = [];
    List<Widget> files = [];

    List<Widget> columnWidgets = [
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: SelectableText(
          message.content ?? "",
          style: const TextStyle(fontSize: 16),
        ),
      )
    ];

    for (var attachment in message.attachments) {
      if (attachment.fileType!.contains("image")) {
        images.add(
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Image.network(
              "http://${ApiConstants.baseUrl}${attachment.fileUrl}",
              width: 200,
            ),
          ),
        );
      } else {
        images.add(Padding(
          padding: EdgeInsets.only(top: 8),
          child: ElevatedButton(
            child: Text(
              style: TextStyle(color: Colors.black),
              attachment.fileName ?? "",
            ),
            onPressed: () async {
              FileDownloader.downloadFile(
                url: "http://${ApiConstants.baseUrl}${attachment.fileUrl}",
                onDownloadCompleted: (path) {
                  AwesomeNotifications().createNotification(
                    content: NotificationContent(
                      id: 16,
                      channelKey: 'basic_channel',
                      title: "Download is complete",
                      body: "download location: ${path}",
                      notificationLayout: NotificationLayout.BigText,
                    ),
                  );
                },
                onDownloadError: (errorMessage) {
                  AwesomeNotifications().createNotification(
                    content: NotificationContent(
                      id: 16,
                      channelKey: 'basic_channel',
                      title: "Download faild",
                      body: "download error message:  ${errorMessage}",
                      notificationLayout: NotificationLayout.BigText,
                    ),
                  );
                },
              );
            },
          ),
        ));
      }
    }

    columnWidgets.addAll(images);
    columnWidgets.addAll(files);
    columnWidgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          message.time ?? "",
          style: const TextStyle(color: Color.fromARGB(255, 80, 78, 78)),
          textAlign: TextAlign.start,
        ),
      ),
    );

    return ChatBubble(
      alignment: message.isSender ?? false ? Alignment.centerRight : Alignment.centerLeft,
      clipper: ChatBubbleClipper5(
        type: message.isSender ?? false ? BubbleType.sendBubble : BubbleType.receiverBubble,
      ),
      backGroundColor: message.isSender ?? false ? AppColor.secondColor : AppColor.greyColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: columnWidgets,
      ),
    );
  }
}