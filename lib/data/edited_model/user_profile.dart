class UserProfile {
  late String id;
  late String firstName;
  late String lastName;
  late String? pictureUrl;
  late String role;

  UserProfile.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    firstName = json["firstName"];
    lastName = json["lastName"];
    pictureUrl = json["pictureUrl"];
    role = json["role"];
  }
}
