/// id : 2
/// description : "en"
/// fromId : 29
/// from : null
/// toId : 33
/// to : null
/// requestTypeId : 2
/// requestType : null
/// statusType : 1

class RequestsResponse {
  RequestsResponse({
      this.id, 
      this.description, 
      this.fromId, 
      this.from, 
      this.toId, 
      this.to, 
      this.requestTypeId, 
      this.requestType, 
      this.statusType,});

  RequestsResponse.fromJson(dynamic json) {
    id = json['id'];
    description = json['description'];
    fromId = json['fromId'];
    from = json['from'];
    toId = json['toId'];
    to = json['to'];
    requestTypeId = json['requestTypeId'];
    requestType = json['requestType'];
    statusType = json['statusType'];
  }
  int? id;
  String? description;
  int? fromId;
  dynamic from;
  int? toId;
  dynamic to;
  int? requestTypeId;
  dynamic requestType;
  int? statusType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['description'] = description;
    map['fromId'] = fromId;
    map['from'] = from;
    map['toId'] = toId;
    map['to'] = to;
    map['requestTypeId'] = requestTypeId;
    map['requestType'] = requestType;
    map['statusType'] = statusType;
    return map;
  }

}