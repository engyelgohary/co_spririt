// {
//   "id": 14,
//   "fromId": 41,
//   "toId": 39,
//   "content": "hello !!!",
//   "timestamp": "2024-08-14T12:08:07.346689",
//   "read": true
// }

class Message {
  int? id;
  int? senderId;
  int? receiverId;
  String? content;
  String? date;
  String? time;
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
}
