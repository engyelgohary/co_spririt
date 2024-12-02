class UserProfile {
  late String id;
  late String firstName;
  late String lastName;
  late String? pictureUrl;
  late String role;
  late String? password;

  UserProfile.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    firstName = json["firstName"];
    lastName = json["lastName"];
    pictureUrl = json["pictureUrl"];
    role = json["role"];
    password = json["password"];
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "pictureUrl": pictureUrl,
      "role": role,
      "password": password,
    };
  }
}
