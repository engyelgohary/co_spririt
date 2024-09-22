// {
//   "id": 30,
//   "description": "tu",
//   "descriptionLocation": "/Opportunities/0ad1272a-9b8a-4c5f-aec2-80bf0ae4ff59.pdf",
//   "clientId": 1,
//   "collaboratorId": 3,
//   "opportunity_Title": "Erp",
//   "opportunity_Type": "Dashboard",
//   "industry": "Marketing",
//   "feasibility": "Medium",
//   "risks": "dont know",
//   "score": null,
//   "solution": null,
//   "status": "string",
//   "generated_Result": "After analyzing the provided context, I found that it has a high correlation with our company's projects, specifically:\n\n* IVS: Intelligent video surveillance system for tracking, detecting and segmenting various objects\n* CV Matching: extract skills from candidate's CV then compare with job description\n\nThe context involves computer vision technology, image analysis, and categorization, which are all similar to the properties of our implemented projects. Additionally, the industry interest in artificial intelligence and computer vision aligns with our company's focus on data science and technology.\n\nTherefore, I conclude that:\n\n**Potential is High**\n\nRecommendation: IVS (Intelligent video surveillance system) project, as it has similar aspects with the given context, such as object detection and categorization."
// }

class Opportunity {
  Opportunity({
    this.id,
    this.description,
    this.descriptionLocation,
    this.clientId,
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
  double? score;
  String? solution;
  String? status;
  String? result;

  factory Opportunity.fromJson(Map<String, dynamic> json) {
    return Opportunity(
      id: json['id'],
      description: json['description'],
      descriptionLocation: json['descriptionLocation'],
      clientId: json['clientId'],
      collaboratorId: json['collaboratorId'],
      title: json['opportunity_Title'],
      type: json['opportunity_Type'],
      industry: json['industry'],
      feasibility: json['feasibility'],
      risks: json['risks'],
      solution: json['solution'],
      status: json['status'],
      score: json['score'],
      result: json['generated_Result'],
    );
  }
}
