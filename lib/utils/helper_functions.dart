import 'package:co_spririt/data/model/message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    list[index] = newItem;
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

Future<void> testFunction() async {
  try {
    print("step1");

    final connection = HubConnectionBuilder()
        .withUrl(
            'http://${ApiConstants.baseUrl}/chat',
            HttpConnectionOptions(
              logMessageContent: true,
              logging: (level, message) {
                print("-level2 = ${level.name}");
                print("-level = $level");
                print("-message = $message");
              },
            ))
        .build();

    print("step2");

    await connection.start();

    print("step3");

    connection.on('ReceiveMessageUpdate', (message) {
      print("potato");
      print(message);
      print(message.toString());
    });
    print("step4");
  } catch (e) {
    print(e);
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
  final date = DateTime.now();
  final messageIndex = listNotifier.addItem(Message(
    id: 0,
    receiverId: receiverId,
    read: false,
    sender: true,
    senderId: 0,
    date: currentTime(),
    time: currentDate(),
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
