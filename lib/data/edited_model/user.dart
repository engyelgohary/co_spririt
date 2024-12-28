class User {
  late String id;
  late String firstName;
  late String lastName;
  late String? email;
  late String? pictureUrl;
  late String role;
  late String? password;

  User.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    firstName = json["firstName"];
    lastName = json["lastName"];
    email = json["email"];
    pictureUrl = json["pictureUrl"];
    role = json["role"];
    password = json["password"];
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "pictureUrl": pictureUrl,
      "role": role,
      "password": password,
    };
  }
}
