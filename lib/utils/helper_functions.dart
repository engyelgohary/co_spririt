import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:co_spririt/data/model/GetAdmin.dart';
import 'package:co_spririt/data/model/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:signalr_core/signalr_core.dart';

import '../core/app_ui.dart';
import '../data/api/apimanager.dart';

class ListNotifier<T> with ChangeNotifier {
  List<T> list = [];
  ListNotifier({required this.list});

  int addItem(item) {
    list.add(item);
    notifyListeners();
    return list.length;
  }

  void removeItem(item) {
    list.remove(item);
    notifyListeners();
  }

  void clearList() {
    list.clear();
    notifyListeners();
  }

  void updateItem(int index, T newItem) {
    list[index - 1] = newItem;
    notifyListeners();
  }
}

class LoadingStateNotifier<T> with ChangeNotifier {
  LoadingStateNotifier({this.loading = true});
  List<T>? response = [];
  bool loading = true;
  void change() {
    loading = !loading;
    notifyListeners();
  }
}

String currentTime() {
  return DateFormat("HH:mm").format(DateTime.now());
}

String currentDate() {
  return DateFormat("dd-MM-yyyy").format(DateTime.now());
}

Future<void> collaboratorsList(ApiManager apiManager, LoadingStateNotifier loadingNotifier) async {
  try {
    loadingNotifier.response = await apiManager.getCollaboratorsToAdmin();
  } catch (e) {
    print("- CollaboratorsList error : $e");
    loadingNotifier.response = null;
  }
  loadingNotifier.change();
}

Future<void> collaboratorAdminsList(
  ApiManager apiManager,
  LoadingStateNotifier loadingNotifier,
) async {
  try {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    if (token == null) {
      throw Exception('No token found. Please log in.');
    }

    Map<String, dynamic> decodedToken = Jwt.parseJwt(token);

    final collaboratorData =
        await apiManager.fetchCollaboratorDetails(int.parse(decodedToken['nameid']));

    loadingNotifier.response = <GetAdmin>[
      await apiManager.fetchAdminDetails(collaboratorData.adminId ?? 0)
    ];
  } catch (e) {
    print("- collaboratorAdminsList error : $e");
    loadingNotifier.response = null;
  }
  loadingNotifier.change();
}

class Signalr {
  Signalr.signalr();
  static Signalr? _instance;

  factory Signalr() => _instance ??= Signalr.signalr();

  void dispose() {
    connection.stop();
    _instance = null;
  }

  int? senderId;
  int? receiverId;
  ScrollController? scrollController;
  ListNotifier<Message>? listNotifier;

  final connection = HubConnectionBuilder()
      .withUrl(
        'http://${ApiConstants.baseUrl}/chat',
        HttpConnectionOptions(
          logMessageContent: true,
          logging: (level, message) {
            // print("-level = $level");
            print("-message = $message");
          },
        ),
      )
      .build();

  Future<void> start() async {
    if (senderId == null) {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'token');

      if (token == null) {
        throw Exception('No token found. Please log in.');
      }

      senderId = int.parse(Jwt.parseJwt(token)["nameid"]);
    }

    try {
      await connection.start();
      connection.on('ReceiveMessageUpdate', (message) {
        if (message != null && message.isNotEmpty) {
          final incomingMessage = Message(
            id: message[0]["Message"]["Id"],
            senderId: message[0]["Message"]["FromId"],
            receiverId: message[0]["Message"]["ToId"],
            content: message[0]["Message"]["Content"],
            sender: false,
            read: message[0]["Message"]["Read"],
            senderEmail: message[0]["User"]["Email"],
            senderFirstName: message[0]["User"]["FirstName"],
            senderLastName: message[0]["User"]["LastName"],
          );
          incomingMessage.parseTime(message[0]["Message"]["Timestamp"]);

          if (senderId == incomingMessage.senderId ||
              incomingMessage.senderId == incomingMessage.receiverId) {
            return;
          } else if (receiverId != incomingMessage.senderId) {
            AwesomeNotifications().createNotification(
              content: NotificationContent(
                id: 16, // -1 is replaced by a random number
                channelKey: 'basic_channel',
                title: 'New message from: ${incomingMessage.senderFirstName}',
                body: incomingMessage.content,
                notificationLayout: NotificationLayout.BigText,
              ),
              actionButtons: [
                NotificationActionButton(
                  key: 'DISMISS',
                  label: 'Dismiss',
                  actionType: ActionType.DismissAction,
                  isDangerousOption: true,
                )
              ],
            );
            print(
                "Message Notification content: ${incomingMessage.content}\nMessage sender: ${incomingMessage.senderId}\nMessage receiver: ${incomingMessage.receiverId}");
          } else if (listNotifier != null) {
            listNotifier!.addItem(incomingMessage);
            if (scrollController != null) {
              Future.delayed(
                const Duration(milliseconds: 300),
                () => scrollController!.animateTo(scrollController!.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300), curve: Curves.easeOut),
              );
            }
            print(
                "Message List content: ${incomingMessage.content}\nMessage sender: ${incomingMessage.senderId}\nMessage receiver: ${incomingMessage.receiverId}");
          }
        }
      });
    } catch (e) {
      print("- signalr error: ${e}");
    }
  }
}

Future<void> collaboratorsMessages(
  int id,
  ApiManager apiManager,
  LoadingStateNotifier loadingNotifier,
) async {
  try {
    loadingNotifier.response = await apiManager.getUserMessages(id);
  } catch (e) {
    print("- collaboratorsMessages error : $e");
    loadingNotifier.response = null;
  }
  loadingNotifier.change();
}

Future<void> sendMessage(
  int receiverId,
  String content,
  ApiManager apiManager,
  ListNotifier listNotifier,
) async {
  final messageIndex = listNotifier.addItem(Message(
    id: 0,
    receiverId: receiverId,
    read: false,
    sender: true,
    senderId: 0,
    date: currentDate(),
    time: currentTime(),
    content: content,
  ));
  try {
    final result = await apiManager.sendMessage(receiverId, content);
    listNotifier.updateItem(messageIndex, Message.fromJson(result, true));
  } catch (e) {
    print("- sendMessage error : $e");
  }
}

Widget buildErrorIndicator(String error, VoidCallback tryAgain) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(error),
        ElevatedButton(
          onPressed: tryAgain,
          child: const Text('Try Again'),
        ),
      ],
    ),
  );
}

dynamic collaboratorPhoto(String? pictureLocation) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(25),
    child: pictureLocation == null
        ? Image.asset(
            '${AppUI.imgPath}photo.png',
            height: 41,
            width: 42,
            fit: BoxFit.cover,
          )
        : Image.network(
            'http://${ApiConstants.baseUrl}/$pictureLocation',
            height: 41,
            width: 42,
            fit: BoxFit.cover,
          ),
  );
}
