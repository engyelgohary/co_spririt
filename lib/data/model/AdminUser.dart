/// id : 3
/// firstName : "admin1"
/// lastName : "admin1"
/// email : "admin1@admin.com"
/// phone : "1234567890"
/// canPost : true
/// pictureLocation : null
/// type : 1

class AdminUser {
  AdminUser({
      this.id,
      this.firstName, 
      this.lastName, 
      this.email, 
      this.phone, 
      this.canPost, 
      this.pictureLocation, 
      this.type,
      this.title,
      this.status,
      this.errors,
      this.traceId,});

  AdminUser.fromJson(dynamic json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    phone = json['phone'];
    canPost = json['canPost'];
    pictureLocation = json['pictureLocation'];
    type = json['type'];
    title = json['title'];
    status = json['status'];
    errors = json['errors'] != null ? Errors.fromJson(json['errors']) : null;
    traceId = json['traceId'];
  }
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  bool? canPost;
  dynamic pictureLocation;
  int? type;
  String? title;
  int? status;
  Errors? errors;
  String? traceId;

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
    map['title'] = title;
    map['status'] = status;
    if (errors != null) {
      map['errors'] = errors?.toJson();
    }
    map['traceId'] = traceId;
    return map;
  }

}
class Errors {
  Errors({
    this.email,
    this.phone,
    this.lastName,
    this.password,
    this.firstName,});

  Errors.fromJson(dynamic json) {
    email = json['Email'] != null ? json['Email'].cast<String>() : [];
    phone = json['Phone'] != null ? json['Phone'].cast<String>() : [];
    lastName = json['LastName'] != null ? json['LastName'].cast<String>() : [];
    password = json['Password'] != null ? json['Password'].cast<String>() : [];
    firstName = json['FirstName'] != null ? json['FirstName'].cast<String>() : [];
  }
  List<String>? email;
  List<String>? phone;
  List<String>? lastName;
  List<String>? password;
  List<String>? firstName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Email'] = email;
    map['Phone'] = phone;
    map['LastName'] = lastName;
    map['Password'] = password;
    map['FirstName'] = firstName;
    return map;
  }

}