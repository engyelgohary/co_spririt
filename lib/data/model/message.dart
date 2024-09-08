// {
//   "id": 14,
//   "fromId": 41,
//   "toId": 39,
//   "content": "hello !!!",
//   "timestamp": "2024-08-14T12:08:07.346689",
//   "read": true
// }
// [{Message: {Id: 31, FromId: 39, ToId: 41, Content: مدهش, Timestamp: 2024-08-15T16:43:48.5757581Z, Read: false}, User: {Id: 39, FirstName: yusuf, LastName: alsawah, Email: yalsawah@admin.com}}]
//  "attachments": [
//       {
//         "fileName": "638603537311178796.webp",
//         "fileUrl": "/messages/638603537311178796.webp",
//         "fileType": "image/webp",
//         "fileSize": 64868
//       }
//     ]
class Message {
  int? id;
  int? senderId;
  int? receiverId;
  String? content;
  String? date;
  String? time;
  String? senderEmail;
  String? senderFirstName;
  String? senderLastName;
  bool? read;
  bool? isSender;
  List<Attachment> attachments = [];

  Message({
    this.id,
    this.senderId,
    this.receiverId,
    this.content,
    this.date,
    this.time,
    this.read,
    this.isSender,
    this.senderEmail,
    this.senderFirstName,
    this.senderLastName,
  });

  Message.fromJson(dynamic json, this.isSender) {
    final date = DateTime.parse(json["timestamp"]);
    id = json["id"];
    senderId = json["fromId"];
    receiverId = json["toId"];
    content = json["content"];
    this.date = "${date.day}-${date.month}-${date.year}";
    time = "${date.hour}:${date.minute}";
    read = json["read"];
    if (json["attachments"].isNotEmpty) {
      for (var attachment in json["attachments"]) {
        attachments.add(Attachment.fromJson(attachment));
      }
    }
  }

  void parseTime(timeStamp) {
    final date = DateTime.parse(timeStamp);
    this.date = "${date.day}-${date.month}-${date.year}";
    time = "${date.hour}:${date.minute}";
  }
}

class Attachment {
  String? fileName;
  String? fileUrl;
  String? fileType;
  int? fileSize;

  Attachment.fromJson(dynamic json) {
    fileName = json["fileName"];
    fileUrl = json["fileUrl"];
    fileType = json["fileType"];
    fileSize = json["fileSize"];
  }
}
