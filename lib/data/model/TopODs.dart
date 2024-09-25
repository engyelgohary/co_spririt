class Top5ODs {
  final String? name;
  final int? statusIdCounter;
  final int? averageScore;

  Top5ODs({required this.name, required this.statusIdCounter, required this.averageScore});

  factory Top5ODs.fromJson(Map<String, dynamic> json) {
    String? fullName = json['firstName'] != null && json['lastName'] != null
        ? '${json['firstName']} ${json['lastName']}'
        : null;
    return Top5ODs(
      name: fullName,
      statusIdCounter: json['statusIdCount'] ?? 0,
      averageScore: (json['averageScore'] ?? 0),
    );
  }
}
