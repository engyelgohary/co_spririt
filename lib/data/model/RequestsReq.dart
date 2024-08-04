/// description : "en"
/// requestTypeId : 2

class RequestsReq {
  RequestsReq({
      this.description, 
      this.requestTypeId,});

  RequestsReq.fromJson(dynamic json) {
    description = json['description'];
    requestTypeId = json['requestTypeId'];
  }
  String? description;
  int? requestTypeId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['description'] = description;
    map['requestTypeId'] = requestTypeId;
    return map;
  }

}