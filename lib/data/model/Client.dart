/// id : 1
/// firstName : "client1"
/// lastName : "client2"
/// contactNumber : "1234"
/// email : "client1@client.com"
/// collaboratorId : null

class Client {
  Client({
      this.id, 
      this.firstName, 
      this.lastName, 
      this.contactNumber, 
      this.email, 
      this.collaboratorId,});

  Client.fromJson(dynamic json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    contactNumber = json['contactNumber'];
    email = json['email'];
    collaboratorId = json['collaboratorId'];
  }
  int? id;
  String? firstName;
  String? lastName;
  String? contactNumber;
  String? email;
  dynamic collaboratorId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['contactNumber'] = contactNumber;
    map['email'] = email;
    map['collaboratorId'] = collaboratorId;
    return map;
  }

}