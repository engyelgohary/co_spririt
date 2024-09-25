// "id": 4,
// "firstName": "test",
// "lastName": "col",
// "email": "testcol@domain.com",
// "phone": "01230635362",
// "contractStart": "2024-09-01T00:00:00",
// "contractEnd": "2024-12-31T00:00:00",
// "status": 1,
// "lastCommunication": "2024-09-14T23:02:47.276852",
// "adminId": 5,
// "cvLocation": null,
// "pictureLocation": null,
// "score": null

class Collaborator {
  int? id;
  int? score;
  int? status;
  int? adminId;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? contractStart;
  String? contractEnd;
  String? lastCommunication;
  String? cvLocation;
  String? pictureLocation;

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
    this.pictureLocation,
    this.score,
  });

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
    score = json['score'];
  }

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
    map['score'] = score;
    return map;
  }
}
