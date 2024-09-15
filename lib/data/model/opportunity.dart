// {
//     "id": 9,
//     "description": "Nodejs dev",
//     "descriptionLocation": "/Opportunities/6baab850-8954-41b4-af66-2bb5f130d500.jpg",
//     "clientId": 1,
//     "collaboratorId": 3,
//     "opportunity_Title": "Backend dev",
//     "opportunity_Type": "Tech ",
//     "industry": "Tech",
//     "feasibility": "Easy",
//     "risks": "None",
//     "generated_Result": "I understand the context as follows:\n\n* Opportunity Title: Backend dev\n* Opportunity Type: Tech\n* Industry: Tech\n* Description: Nodejs dev\n* Feasibility: Easy\n* Risks: None\n\nAfter comparing this context with our company's implemented projects, I found that the opportunity has similar properties with \"Financial Extractor\" (LLM extracts financial statements from pdf contracts) and \"CV Matching\" (extract skills from candidate's CV then compare with job description).\n\nBoth of these projects involve working with technical data (financial statements or CVs), which is closely related to the Nodejs dev opportunity. Additionally, the feasibility and risks associated with this opportunity are considered easy and none, respectively, which aligns with our company's experience in implementing these types of projects.\n\nTherefore, I conclude that:\n\nPotential is High\n\nRecommendation: This opportunity has similar aspects with \"CV Matching\" project."
//   }

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
      result: json['generated_Result'],
    );
  }
}
