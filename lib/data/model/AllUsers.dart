class AllUsers {
  final String? name;
  final String? email;
  final String? role;

  AllUsers({required this.name, required this.email, required this.role});

  factory AllUsers.fromJson(Map<String, dynamic> json) {
    String? firstName = json['firstName'];
    String? lastName = json['lastName'];

    String? formattedName = (firstName != null && lastName != null)
        ? '${firstName[0]}. $lastName'
        : null;

    return AllUsers(
      name: formattedName,
      email: json['email'],
      role: json['role'],
    );
  }
}

