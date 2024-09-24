class OW {
  OW({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.canPost,
    this.pictureLocation,
    this.type,
  });

  OW.fromJson(dynamic json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    phone = json['phone'];
    canPost = json['canPost'];
    pictureLocation = json['pictureLocation'];
    type = json['type'];
  }

  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  bool? canPost;
  dynamic pictureLocation;
  int? type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['email'] = email;
    map['phone'] = phone;
    map['canPost'] = canPost;
    map['pictureLocation'] = pictureLocation;
    map['type'] = type;
    return map;
  }
}
