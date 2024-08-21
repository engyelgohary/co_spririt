

class RequestsResponse {
  RequestsResponse({
      this.id, 
      this.description, 
      this.fromId, 
      this.toId, 
      this.requestTypeId, 
      this.type,
  this.requestType,
    this.from,
    this.to
  });

  RequestsResponse.fromJson(dynamic json) {
    id = json['id'];
    description = json['description'];
    fromId = json['fromId'];
    toId = json['toId'];
    requestTypeId = json['requestTypeId'];
    type = json['type'];
  }
  int? id;
  String? description;
  int? fromId;
  int? toId;
  int? requestTypeId;
  String? type;
  dynamic requestType;
  dynamic to;
  dynamic from;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['description'] = description;
    map['fromId'] = fromId;
    map['toId'] = toId;
    map['requestTypeId'] = requestTypeId;
    map['type'] = type;
    return map;
  }

}