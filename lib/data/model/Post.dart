import 'package:image_picker/image_picker.dart';

class Post {
  final int id;
  final String title;
  final String content;
  final DateTime lastEdit;
  final String? pictureLocation;
  final int userId;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.lastEdit,
    this.pictureLocation,
    required this.userId,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      lastEdit: DateTime.parse(json['lastEdit']),
      pictureLocation: json['pictureLocation'],
      userId: json['userId'],
    );
  }
}
