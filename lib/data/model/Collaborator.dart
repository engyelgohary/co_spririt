/// id : 51
/// firstName : "ee"
/// lastName : "ee"
/// email : "ee@ee.com"
/// phone : "1234567890"
/// contractStart : "2022-10-05T00:00:00"
/// contractEnd : "2025-10-06T00:00:00"
/// status : 1
/// lastCommunication : "2024-07-05T10:27:01.623254"
/// adminId : 30
/// cvLocation : "/CVs/610aaadc-0af6-40ea-95c3-d84695cf382d.pdf"
/// pictureLocation : "/Pictures/0825ea51-3ffa-40bb-9dea-52dc9828ee27.png"

class Collaborator {
  Collaborator({
      this.id, 
      this.firstName, 
      this.lastName, 
      this.email, 
      this.phone, 
      this.contractStart, 
      this.contractEnd, 
      this.status, 
      this.lastCommunication, 
      this.adminId, 
      this.cvLocation, 
      this.pictureLocation,});

  Collaborator.fromJson(dynamic json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    phone = json['phone'];
    contractStart = json['contractStart'];
    contractEnd = json['contractEnd'];
    status = json['status'];
    lastCommunication = json['lastCommunication'];
    adminId = json['adminId'];
    cvLocation = json['cvLocation'];
    pictureLocation = json['pictureLocation'];
  }
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? contractStart;
  String? contractEnd;
  int? status;
  String? lastCommunication;
  int? adminId;
  String? cvLocation;
  String? pictureLocation;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['email'] = email;
    map['phone'] = phone;
    map['contractStart'] = contractStart;
    map['contractEnd'] = contractEnd;
    map['status'] = status;
    map['lastCommunication'] = lastCommunication;
    map['adminId'] = adminId;
    map['cvLocation'] = cvLocation;
    map['pictureLocation'] = pictureLocation;
    return map;
  }

}