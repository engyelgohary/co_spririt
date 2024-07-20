/// id : 1
/// title : "ee"
/// description : "ee"
/// descriptionLocation : null
/// clientId : 2
/// collaboratorId : 1

class Opportunities {
  Opportunities({
      this.id, 
      this.title, 
      this.description, 
      this.descriptionLocation, 
      this.clientId, 
      this.collaboratorId,
    this.clientFirstName,
    this.clientLastName,
    this.collaboratorFirstName,
    this.collaboratorLastName,
    this.result
  });

  int? id;
  String? title;
  String? description;
  String? descriptionLocation;
  int? clientId;
  int? collaboratorId;
   String? clientFirstName;
   String? clientLastName;
   String?collaboratorFirstName;
   String?collaboratorLastName;
   int? result;



  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['description'] = description;
    map['descriptionLocation'] = descriptionLocation;
    map['clientId'] = clientId;
    map['collaboratorId'] = collaboratorId;
    map['collaboratorFirstName'] = collaboratorFirstName;
    map['collaboratorLastName'] = collaboratorLastName;
    return map;
  }
  factory Opportunities.fromJson(Map<String, dynamic> json) {
    return Opportunities(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      descriptionLocation: json['descriptionLocation'], // Ensure this field is properly mapped
      clientId: json['clientId'],
      collaboratorId: json['collaboratorId'],
      collaboratorFirstName: json['collaboratorFirstName'],
      collaboratorLastName: json['collaboratorLastName'],
      result: json['result'],
    );
  }
}