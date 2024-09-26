import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:co_spirit/data/model/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:co_spirit/utils/theme/appColors.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

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
          style: TextStyle(
              fontSize: 16,
              color: message.isSender ?? false ? Colors.white : ODColorScheme.textColor),
        ),
      )
    ];

    for (var attachment in message.attachments) {
      if (attachment.fileType!.contains("image")) {
        images.add(
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: CachedNetworkImage(
              imageUrl: "http://${ApiConstants.baseUrl}${attachment.fileUrl}",
              width: 200,
            ),
          ),
        );
      } else {
        images.add(Padding(
          padding: const EdgeInsets.only(top: 8),
          child: ElevatedButton(
            child: Text(
              style: const TextStyle(color: Colors.black),
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
                      body: "download location: $path",
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
                      body: "download error message:  $errorMessage",
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
          style: TextStyle(
            color: message.isSender ?? false ? Colors.white : ODColorScheme.textColor,
          ),
        ),
      ),
    );

    return ChatBubble(
      alignment: message.isSender ?? false ? Alignment.centerRight : Alignment.centerLeft,
      clipper: ChatBubbleClipper5(
        type: message.isSender ?? false ? BubbleType.sendBubble : BubbleType.receiverBubble,
      ),
      backGroundColor: message.isSender ?? false ? ODColorScheme.mainColor : Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: columnWidgets,
      ),
    );
  }
}

class OppyChatBubble extends StatelessWidget {
  final String message;
  final bool isSender;
  final Color textColor;
  final Color backgroundColor;
  const OppyChatBubble({
    super.key,
    required this.message,
    required this.isSender,
    required this.textColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> columnWidgets;
    if (isSender) {
      columnWidgets = [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: SelectableText(
            message,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        )
      ];
    } else {
      columnWidgets = [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Markdown(
            selectable: true,
            data: message,
            shrinkWrap: true,
            softLineBreak: true,
            styleSheet: MarkdownStyleSheet(
              p: TextStyle(
                fontSize: 16,
                color: textColor,
              ),
            ),
          ),
        )
      ];
    }

    return ChatBubble(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      clipper: ChatBubbleClipper5(
        type: isSender ? BubbleType.sendBubble : BubbleType.receiverBubble,
      ),
      backGroundColor: isSender ? backgroundColor : Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: columnWidgets,
      ),
    );
  }
}
