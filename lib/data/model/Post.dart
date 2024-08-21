class Post {
  final int id;
  final String? title;
  final String? content;
  final String? firstNameUser;
  final String? lastNameUser;
  final String? pictureLocationUser; // Changed to String?
  final DateTime? lastEdit;
  final String? pictureLocation; // Changed to String?
  final int? userId;

  Post({
    required this.id,
    this.title,
    this.firstNameUser,
    this.lastNameUser,
    this.content,
    this.lastEdit,
    this.pictureLocation,
    this.pictureLocationUser,
    this.userId,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      firstNameUser: json['firstNameUser'],
      lastNameUser: json['lastNameUser'],
      pictureLocationUser: json['pictureLocationUser'] as String?, // Ensure type conversion
      title: json['title'],
      content: json['content'],
      lastEdit: json['lastEdit'] != null ? DateTime.parse(json['lastEdit']) : null, // Handle null dates
      pictureLocation: json['pictureLocation'] as String?, // Ensure type conversion
      userId: json['userId'],
    );
  }
}
