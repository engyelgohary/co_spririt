class Post {
  final int id;
  final String title;
  final String content;
  final DateTime lastEdit;
  final String? pictureLocation; // Optional, in case some posts don't have a picture
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
