// {
//   "id": 14,
//   "fromId": 41,
//   "toId": 39,
//   "content": "hello !!!",
//   "timestamp": "2024-08-14T12:08:07.346689",
//   "read": true
// }
// [{Message: {Id: 31, FromId: 39, ToId: 41, Content: مدهش, Timestamp: 2024-08-15T16:43:48.5757581Z, Read: false}, User: {Id: 39, FirstName: yusuf, LastName: alsawah, Email: yalsawah@admin.com}}]

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
  bool? sender;

  Message({
    this.id,
    this.senderId,
    this.receiverId,
    this.content,
    this.date,
    this.time,
    this.read,
    this.sender,
    this.senderEmail,
    this.senderFirstName,
    this.senderLastName,
  });

  Message.fromJson(dynamic json, this.sender) {
    final date = DateTime.parse(json["timestamp"]);
    id = json["id"];
    senderId = json["fromId"];
    receiverId = json["toId"];
    content = json["content"];
    this.date = "${date.day}-${date.month}-${date.year}";
    time = "${date.hour}:${date.minute}";
    read = json["read"];
  }

  void parseTime(timeStamp) {
    final date = DateTime.parse(timeStamp);
    this.date = "${date.day}-${date.month}-${date.year}";
    time = "${date.hour}:${date.minute}";
  }
}