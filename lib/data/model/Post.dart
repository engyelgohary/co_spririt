class Post {
  final int id;
  final String? title;
  final String? content;
  final DateTime? lastEdit;
  final dynamic pictureLocation;
  final int? userId;

  Post({
    required this.id,
    this.title,
    this.content,
    this.lastEdit,
    this.pictureLocation,
    this.userId,
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