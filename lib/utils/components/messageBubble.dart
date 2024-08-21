import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:co_spririt/utils/theme/appColors.dart';

class CustomChatBubble extends StatelessWidget {
  final String messageText;
  final bool isSender;
  final String imageUrl;
  final String time;
  const CustomChatBubble({
    super.key,
    this.messageText = "",
    this.isSender = true,
    this.imageUrl = "",
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return ChatBubble(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      clipper: ChatBubbleClipper5(
        type: isSender ? BubbleType.sendBubble : BubbleType.receiverBubble,
      ),
      backGroundColor: isSender ? AppColor.secondColor : AppColor.greyColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          imageUrl.isEmpty
              ? SelectableText(
            messageText,
            style: const TextStyle(fontSize: 16),
          )
          // TODO it can be constrained box
              : Image.network(
            imageUrl,
            // "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS02ewphwfAoFZYw0PSaE-GKNluuJ6a9z4gIZl6z7cFJrTwZpFo "
            // "https://images.unsplash.com/photo-1555993539-1732b0258235?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
            width: MediaQuery.of(context).size.width / 2,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              time,
              style: const TextStyle(color: Color.fromARGB(255, 80, 78, 78)),
              // textAlign: isSender ? TextAlign.start : TextAlign.end
            ),
          ),
        ],
      ),
    );
  }
}