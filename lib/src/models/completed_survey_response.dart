class CompletedSurveyResponse {
  int status;
  List<Surveys> surveys;

  CompletedSurveyResponse({this.status, this.surveys});

  CompletedSurveyResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['surveys'] != null) {
      surveys = <Surveys>[];
      json['surveys'].forEach((v) {
        surveys.add(new Surveys.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.surveys != null) {
      data['surveys'] = this.surveys.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Surveys {
  int id;
  String surveyid;
  String siteid;
  String name;
  String updatedAt;

  Surveys({this.id, this.surveyid, this.siteid, this.name, this.updatedAt});

  Surveys.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    surveyid = json['surveyid'];
    siteid = json['siteid'];
    name = json['name'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['surveyid'] = this.surveyid;
    data['siteid'] = this.siteid;
    data['name'] = this.name;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
