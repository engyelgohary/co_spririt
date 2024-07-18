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
      this.collaboratorId,});

  Opportunities.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    descriptionLocation = json['descriptionLocation'];
    clientId = json['clientId'];
    collaboratorId = json['collaboratorId'];
  }
  int? id;
  String? title;
  String? description;
  dynamic descriptionLocation;
  int? clientId;
  int? collaboratorId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['description'] = description;
    map['descriptionLocation'] = descriptionLocation;
    map['clientId'] = clientId;
    map['collaboratorId'] = collaboratorId;
    return map;
  }

}