class UserData {
  late String id;
  late String name;
  late String email;
  late String token;
  late String refreshToken;
  late String role;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
    required this.refreshToken,
    required this.role,
  });

  UserData.fromJson(Map json) {
    id = json["id"];
    name = json["name"];
    email = json["email"];
    token = json["token"];
    refreshToken = json["refreshToken"];
    role = json["role"];
  }

  toJson() {
    Map json = {};
    json["id"] = id;
    json["name"] = name;
    json["email"] = email;
    json["token"] = token;
    json["refreshToken"] = refreshToken;
    json["role"] = role;
    return json;
  }
}