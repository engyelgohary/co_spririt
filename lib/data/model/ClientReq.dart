/// firstName : "string"
/// lastName : "string"
/// contactNumber : "10"
/// email : "user@example.com"

class ClientReq {
  ClientReq({
      this.firstName, 
      this.lastName, 
      this.contactNumber, 
      this.email,});

  ClientReq.fromJson(dynamic json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    contactNumber = json['contactNumber'];
    email = json['email'];
  }
  String? firstName;
  String? lastName;
  String? contactNumber;
  String? email;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['contactNumber'] = contactNumber;
    map['email'] = email;
    return map;
  }

}