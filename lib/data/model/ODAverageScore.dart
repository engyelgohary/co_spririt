class OdAverageScore {
  final int id;
  final String? name;
  final int? averageScore;

  OdAverageScore({required this.id, required this.name, required this.averageScore});

  factory OdAverageScore.fromJson(Map<String, dynamic> json) {
    String? fullName = json['firstName'] != null && json['lastName'] != null
        ? '${json['firstName']} ${json['lastName']}'
        : null;

    return OdAverageScore(
      id: json['id'],
      name: fullName,
      averageScore: json['score'] as int?,
    );
  }

  @override
  String toString() {
    return 'OdAverageScore{id: $id, name: $name, averageScore: $averageScore}';
  }
}
