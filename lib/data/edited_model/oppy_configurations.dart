class Customer {
  late String id;
  late String name;

  Customer.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
    };
  }
}

class Feasibility {
  late String id;
  late String description;

  Feasibility.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    description = json["description"];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "description": description,
    };
  }
}

class PointPrize {
  late String id;
  late String description;
  late int score;

  PointPrize.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    description = json["description"];
    score = json["score"];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "description": description,
      "score": score,
    };
  }
}

class Risk {
  late String id;
  late List<String> names;

  Risk.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    names = List<String>.from(json["names"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "names": names,
    };
  }
}

class Solution {
  late String id;
  late String description;

  Solution.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    description = json["description"];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "description": description,
    };
  }
}

class Status {
  late String id;
  late String description;

  Status.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    description = json["description"];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "description": description,
    };
  }
}

class Team {
  late String id;
  late String name;

  Team.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
    };
  }
}

class AddPointPrizeRequest {
  late String description;
  late int score;

  AddPointPrizeRequest.fromJson(Map<String, dynamic> json) {
    description = json["description"];
    score = json["score"];
  }

  Map<String, dynamic> toJson() {
    return {
      "description": description,
      "score": score,
    };
  }
}

class AddRiskRequest {
  late List<String> names;

  AddRiskRequest.fromJson(Map<String, dynamic> json) {
    names = List<String>.from(json["names"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "names": names,
    };
  }
}

class UpdatePointPrizeRequest {
  late String id;
  late String description;
  late int score;

  UpdatePointPrizeRequest.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    description = json["description"];
    score = json["score"];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "description": description,
      "score": score,
    };
  }
}

class UpdateStatusRequest {
  late String id;
  late String description;

  UpdateStatusRequest.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    description = json["description"];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "description": description,
    };
  }
}
