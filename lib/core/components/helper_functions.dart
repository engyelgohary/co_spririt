import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:co_spirit/core/app_ui.dart';
import 'package:co_spirit/data/api/apimanager.dart';
import 'package:co_spirit/data/model/Notification.dart';
import 'package:co_spirit/data/model/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:signalr_core/signalr_core.dart';

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
    loadingNotifier.response = [
      ...await apiManager.getSuperAdminData(),
      ...await apiManager.getCollaboratorsToAdmin(),
    ];
  } catch (e) {
    print("- CollaboratorsList error : $e");
    loadingNotifier.response = null;
  }
  loadingNotifier.change();
}

Future<void> superAdminList(ApiManager apiManager, LoadingStateNotifier loadingNotifier) async {
  try {
    loadingNotifier.response = [
      ...await apiManager.fetchAllCollaborators(),
      ...await apiManager.getAllAdmins(),
      ...await apiManager.getSuperAdminData()
    ];
  } catch (e) {
    print("- superAdminList error : $e");
    loadingNotifier.response = null;
  }
  loadingNotifier.change();
}

// Future<void> collaboratorAdminsList(
//   ApiManager apiManager,
//   LoadingStateNotifier loadingNotifier,
// ) async {
//   try {
//     const storage = FlutterSecureStorage();
//     final token = await storage.read(key: 'token');

//     if (token == null) {
//       throw Exception('No token found. Please log in.');
//     }

//     Map<String, dynamic> decodedToken = Jwt.parseJwt(token);

//     final collaboratorData =
//         await apiManager.fetchCollaboratorDetails(int.parse(decodedToken['nameid']));

//     loadingNotifier.response = await apiManager.getSuperAdminData();
//   } catch (e) {
//     print("- collaboratorAdminsList error : $e");
//     loadingNotifier.response = null;
//   }
//   loadingNotifier.change();
// }

Future<void> OWMessagesContactList(
  ApiManager apiManager,
  LoadingStateNotifier loadingNotifier,
) async {
  try {
    loadingNotifier.response = await apiManager.getSuperAdminData();
  } catch (e) {
    print("- OWMessagesContactList error : $e");
    loadingNotifier.response = null;
  }
  loadingNotifier.change();
}

Future<void> OAMessagesContactList(
  ApiManager apiManager,
  LoadingStateNotifier loadingNotifier,
) async {
  try {
    loadingNotifier.response = await apiManager.getSuperAdminData();
  } catch (e) {
    print("- OAMessagesContactList error : $e");
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
        print(message);
        if (message == null || message.isEmpty) {
          return;
        }

        final incomingMessage = Message(
          id: message[0]["Message"]["Id"],
          senderId: message[0]["Message"]["FromId"],
          receiverId: message[0]["Message"]["ToId"],
          content: message[0]["Message"]["Content"],
          isSender: false,
          read: message[0]["Message"]["Read"],
          senderEmail: message[0]["User"]["Email"],
          senderFirstName: message[0]["User"]["FirstName"],
          senderLastName: message[0]["User"]["LastName"],
        );
        incomingMessage.parseTime(message[0]["Message"]["Timestamp"]);

        if (senderId != incomingMessage.senderId && senderId != incomingMessage.receiverId) {
          return;
        }
        if (senderId == incomingMessage.receiverId && listNotifier == null) {
          print("in signalr case2");

          AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: 16,
              channelKey: 'op_channel_channel',
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
          // print(
          //     "Message Notification content: ${incomingMessage.content}\nMessage sender: ${incomingMessage.senderId}\nMessage receiver: ${incomingMessage.receiverId}");
        } else if (senderId == incomingMessage.receiverId && listNotifier != null) {
          print("in signalr case2");
          listNotifier!.addItem(incomingMessage);
          if (scrollController != null) {
            Future.delayed(
              const Duration(milliseconds: 300),
              () => scrollController!.animateTo(scrollController!.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 300), curve: Curves.easeOut),
            );
          }
          // print(
          //     "Message List content: ${incomingMessage.content}\nMessage sender: ${incomingMessage.senderId}\nMessage receiver: ${incomingMessage.receiverId}");
        }
      });
    } catch (e) {
      print("- signalr error: $e");
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
  List<String> attachments,
) async {
  final messageIndex = listNotifier.addItem(Message(
    id: 0,
    receiverId: receiverId,
    read: false,
    isSender: true,
    senderId: 0,
    date: currentDate(),
    time: currentTime(),
    content: content,
  ));
  try {
    final result = await apiManager.sendMessage(receiverId, content, attachments);
    listNotifier.updateItem(messageIndex, Message.fromJson(result, true));
  } catch (e) {
    print("- sendMessage error : $e");
  }
}

Future<void> oppyChatHistory(
  int id,
  ApiManager apiManager,
  LoadingStateNotifier loadingNotifier,
) async {
  try {
    final respone = await apiManager.getOppyChatHistory(id);

    final template = {
      "NewMessage": respone["newMessage"],
      "GeneratedResult": respone["generatedResult"],
      "ChatHistory": []
    };

    final messages = [];

    for (var element in respone["chatHistory"]) {
      final message = element["message"];
      final response = element["response"];
      if (message != null) {
        messages.add([message, true]);
      }

      if (response != null) {
        messages.add([response, false]);
      }

      if (message != null && respone != null) {
        template["ChatHistory"].add({"Message": message, "Response": response});
      }
    }
    loadingNotifier.response = [template, messages];
  } catch (e) {
    print("- oppyChatHistory error : $e");
    loadingNotifier.response = null;
  }
  loadingNotifier.change();
}

Future<void> sendOppyMessage(
  int id,
  Map template,
  String message,
  ApiManager apiManager,
  ListNotifier listNotifier,
  ScrollController controller, {
  bool storeChat = true,
}) async {
  try {
    listNotifier.addItem([message, true]);

    controller.animateTo(
      controller.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );

    template["NewMessage"] = message;

    final messageIndex = listNotifier.addItem([null, false]);

    controller.animateTo(
      controller.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );

    final result = await apiManager.sendOppyMessage(template);

    template["ChatHistory"].add(result);

    listNotifier.updateItem(messageIndex, [result["Response"], false]);

    controller.animateTo(
      controller.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );

    if (storeChat) {
      apiManager.storeOppyMessage(id, result["Message"], result["Response"]);
    }
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
        : CachedNetworkImage(
            imageUrl: 'http://${ApiConstants.baseUrl}/$pictureLocation',
            height: 41,
            width: 42,
            fit: BoxFit.cover,
          ),
  );
}

dynamic ODPhoto(String? pictureLocation, double width, double height) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(100),
    child: pictureLocation == null
        ? Image.asset(
            '${AppUI.imgPath}photo.png',
            height: height,
            width: width,
            fit: BoxFit.cover,
          )
        : CachedNetworkImage(
            imageUrl: 'http://${ApiConstants.baseUrl}/$pictureLocation',
            height: height,
            width: width,
            fit: BoxFit.cover,
          ),
  );
}

Future<void> notificationList(
  ApiManager apiManager,
  LoadingStateNotifier loadingNotifier,
) async {
  try {
    loadingNotifier.response = await apiManager.getUserNotification();
  } catch (e) {
    print("- notificationList error : $e");
    loadingNotifier.response = null;
  }
  loadingNotifier.change();
}

Future<void> readNotification(
  ApiManager apiManager,
  LoadingStateNotifier loadingNotifier,
  UserNotification notification,
) async {
  try {
    await apiManager.readUserNotification(notification.id ?? 0);
    notification.isRead = true;
    loadingNotifier.change();
  } catch (e) {
    print("- notificationList error : $e");
    loadingNotifier.response = null;
  }
}

Future<void> opportunitiesList(
  ApiManager apiManager,
  LoadingStateNotifier loadingNotifier, {
  int userType = 0,
}) async {
  try {
    loadingNotifier.response = await apiManager.getOpportunities();
    if (userType == 0) {
      // Super admin
      loadingNotifier.response = await apiManager.getOpportunities();
    } else if (userType == 2) {
      // collaborator or od
      loadingNotifier.response = await apiManager.getOpportunities();
    } else if (userType == 3) {
      // Opportunity analyzer
      loadingNotifier.response = await apiManager.getOpportunityAnalyzerOpportunities();
    } else if (userType == 4) {
      // Opportunity owner
      loadingNotifier.response = await apiManager.getOpportunityOwnerOpportunities();
    }
  } catch (e) {
    print("- CollaboratorsList error : $e");
    loadingNotifier.response = null;
  }
  loadingNotifier.change();
}

Future<void> scoreList(
  ApiManager apiManager,
  LoadingStateNotifier loadingNotifier,
) async {
  try {
    loadingNotifier.response = await Future.wait(
        [apiManager.fetchCollaboratorDetails(null), apiManager.getOpportunities()]);
  } catch (e) {
    print("- scoreList error : $e");
    loadingNotifier.response = null;
  }
  loadingNotifier.change();
}

Future<void> deleteOpportunityButton(
  ApiManager apiManager,
  LoadingStateNotifier loadingNotifier,
  int id,
) async {
  try {
    await apiManager.deleteOpportunity(id);
  } catch (e) {
    print("- Delete Opportunity Button error : $e");
  }
  loadingNotifier.change();
}

Future<void> addOpportunityBackend(
  ApiManager apiManager,
  LoadingStateNotifier loadingNotifier,
) async {
  try {
    final List test = await Future.wait([
      apiManager.getRisks(),
      apiManager.getSolutions(),
      apiManager.fetchAllClients(),
      apiManager.getFeasibility(),
    ]);
    test[0] = Map.fromIterables(
        test[0].map((e) => e["name"]).toList(), test[0].map((e) => e["id"]).toList());
    test[1] = Map.fromIterables(
        test[1].map((e) => e["name"]).toList(), test[1].map((e) => e["id"]).toList());
    test[3] = Map.fromIterables(
        test[3].map((e) => e["name"]).toList(), test[3].map((e) => e["id"]).toList());
    test[2] = Map.fromIterables(
      test[2].map((e) => "${e.firstName} ${e.lastName}").toList(),
      test[2].map((e) => e.id).toList(),
    );

    loadingNotifier.response = test;
  } catch (e) {
    print("- Delete Opportunity Button error : $e");
    loadingNotifier.response = null;
  }
  loadingNotifier.change();
}

dynamic loadingIndicatorDialog(BuildContext context, {bool dismissible = false}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return PopScope(
        canPop: dismissible,
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 5,
            backgroundColor: Colors.transparent,
            color: Colors.green,
          ),
        ),
      );
    },
  );
}

dynamic snackBar(BuildContext context, String message, {int duration = 2}) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: Duration(seconds: duration),
    content: Text(message),
  ));
}

Future<void> uploadCsvFile(BuildContext context, ApiManager apiManager, String path) async {
  try {
    final csvFile = File(path).readAsLinesSync();
    final reward = [];
    final teams = [];
    final solutions = [];
    final risks = [];
    final status = [];
    final feasibility = [];

    final firstRow = csvFile[0].split(',').map((e) => e.trim().toLowerCase());
    final firstRowCheck = firstRow.contains("reward") &&
        firstRow.contains("reward score") &&
        firstRow.contains("status score") &&
        firstRow.contains("status") &&
        firstRow.contains("team") &&
        firstRow.contains("risk") &&
        firstRow.contains("solution");

    if (!firstRowCheck) {
      throw Exception("Invalid titles");
    }

    for (var i = 1; i < csvFile.length; i++) {
      final row = csvFile[i].split(',');

      if (row[0].isNotEmpty && row[1].isNotEmpty) {
        if (int.tryParse(row[1]) == null) {
          throw Exception("Invalid reward score at row ${i + 1}");
        }
        reward.add({"name": row[0], "value": row[1]});
      }

      if (row[2].isNotEmpty && row[3].isNotEmpty) {
        if (int.tryParse(row[3]) == null) {
          throw Exception("Invalid status score at row ${i + 1}");
        }
        status.add({"name": row[2], "value": row[3]});
      }

      if (row[4].isNotEmpty) {
        teams.add({"name": row[4]});
      }

      if (row[5].isNotEmpty) {
        risks.add({"name": row[5]});
      }

      if (row[6].isNotEmpty) {
        solutions.add({"name": row[6]});
      }

      if (row[7].isNotEmpty) {
        feasibility.add({"name": row[7]});
      }
    }
    final List<Future> requests = [];
    if (solutions.isNotEmpty) {
      requests.add(apiManager.addSolutionsBulk(solutions));
    }
    if (risks.isNotEmpty) {
      requests.add(apiManager.addRiskBulk(risks));
    }
    if (teams.isNotEmpty) {
      requests.add(apiManager.addTeamBulk(teams));
    }
    if (feasibility.isNotEmpty) {
      requests.add(apiManager.addFeasibilityBulk(feasibility));
    }
    if (reward.isNotEmpty) {
      requests.add(apiManager.addScoreBulk(reward));
    }
    if (status.isNotEmpty) {
      requests.add(apiManager.addOpportunityStatusBulk(status));
    }
    await Future.wait(requests);

    if (context.mounted) {
      snackBar(context, "Uploading csv is done");
    }
  } catch (e) {
    print("- Error parsing csv file error:$e");
    rethrow;
  }
}
