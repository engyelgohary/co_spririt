class Customer {
  final String id;
  final String name;

  Customer({required this.id, required this.name});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': [name],
    };
  }

  @override
  String toString() {
    return 'Customer(id: $id, name: $name)';
  }
}

class Feasibility {
  final String id;
  final String name;

  Feasibility({required this.id, required this.name});

  factory Feasibility.fromJson(Map<String, dynamic> json) {
    return Feasibility(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Risk {
  final String id;
  final String name;

  Risk({required this.id, required this.name});

  factory Risk.fromJson(Map<String, dynamic> json) {
    return Risk(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': [name].toString(),
    };
  }
}

class Solution {
  final String id;
  final String name;

  Solution({required this.id, required this.name});

  factory Solution.fromJson(Map<String, dynamic> json) {
    return Solution(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Status {
  final String id;
  final String name;

  Status({required this.id, required this.name});

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Team {
  final String id;
  final String name;

  Team({required this.id, required this.name});

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
