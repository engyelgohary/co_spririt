class Opportunity {
  Opportunity({
    this.id,
    this.description,
    this.descriptionLocation,
    this.clientId,
    this.clientName,
    this.collaboratorId,
    this.title,
    this.type,
    this.industry,
    this.feasibility,
    this.risks,
    this.score,
    this.solution,
    this.status,
    this.result,
    this.teamName,
    this.teamId,
    this.statusId,
  });

  int? id;
  String? description;
  String? descriptionLocation;
  int? clientId;
  int? collaboratorId;
  String? title;
  String? type;
  String? industry;
  String? feasibility;
  String? risks;
  int? score;
  String? solution;
  String? status;
  String? result;
  String? teamName;
  String? teamId;
  String? clientName;
  int? statusId; // Add this property

  factory Opportunity.fromJson(Map<String, dynamic> json) {
    return Opportunity(
      id: json['id'] as int?,
      description: json['description'] as String?,
      descriptionLocation: json['descriptionLocation'] as String?,
      clientName: json['clientName'] as String?,
      clientId: json['clientId'] as int?,
      collaboratorId: json['collaboratorId'] as int?,
      title: json['opportunity_Title'] as String?,
      type: json['opportunity_Type'] as String?,
      industry: json['industry'] as String?,
      feasibility: json['feasibility'] as String?,
      risks: json['risks'] as String?,
      solution: json['solution'] as String?,
      status: json['status'] as String?,
      teamName: json['teamName'] as String?,
      teamId: json['teamId'] as String?,
      result: json['generated_Result'] as String?,
      score: json['score'],
      statusId: json['statusId'] as int?,
    );
  }
}
