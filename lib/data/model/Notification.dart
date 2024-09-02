// {
//     "id": 1,
//     "userId": 59,
//     "title": "You have received a new message from user Yusuf Alsawah.",
//     "message": "hello",
//     "createdAt": "2024-09-02T08:32:06.14635",
//     "isRead": true
// }

class UserNotification {
  int? id;
  int? userId;
  String? message;
  String? date;
  String? time;
  String? title;
  bool? isRead;

  UserNotification(
      {this.date, this.id, this.isRead, this.message, this.title, this.userId, this.time});

  UserNotification.fromJson(dynamic json) {
    id = json["id"];
    userId = json["userId"];
    title = json["title"];
    message = json["message"];
    isRead = json["isRead"];
    parseTime(json["createdAt"]);
  }

  void parseTime(timeStamp) {
    final date = DateTime.parse(timeStamp);
    this.date = "${date.day}-${date.month}-${date.year}";
    time = "${date.hour}:${date.minute}";
  }
}
