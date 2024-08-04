/// id : 1
/// type : "string"

class Types {
  Types({
      this.id, 
      this.type,});

  Types.fromJson(dynamic json) {
    id = json['id'];
    type = json['type'];
  }
  int? id;
  String? type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['type'] = type;
    return map;
  }

}