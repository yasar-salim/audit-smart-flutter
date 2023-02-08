import 'dart:math';

class SurveyResponse {
  int status;
  int surveyId;
  String siteId;
  String siteName;
  int auditTypeId;
  String auditTypeName;
  String startDate;
  List<Questions> questions;

  SurveyResponse(
      {this.status,
      this.surveyId,
      this.questions,
      this.siteId,
      this.siteName,
      this.auditTypeId,
      this.auditTypeName,
      this.startDate});

  SurveyResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    surveyId = json['survey_id'];

    siteId = json['site_id'];
    siteName = json['site_name'];
    auditTypeId = json['audit_type_id'];
    auditTypeName = json['audit_type_name'];
    startDate = json['start_date'];

    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions.add(new Questions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['survey_id'] = this.surveyId;

    data['site_id'] = this.siteId;
    data['site_name'] = this.siteName;
    data['audit_type_id'] = this.auditTypeId;
    data['audit_type_name'] = this.auditTypeName;
    data['start_date'] = this.startDate;

    if (this.questions != null) {
      data['questions'] = this.questions.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Questions {
  int id;
  String question;
  String questionId;
  int photoRequired;
  int commentRequired;
  int answerType;
  String guidelines;
  String sampleImage;
  bool skippable;
  List<AnsOptions> options;
  List<Answer> answers;
  int points;
  bool gallery;
  bool visible;

  Questions(
      {this.id,
      this.question,
      this.questionId,
      this.photoRequired,
      this.commentRequired,
      this.answerType,
      this.guidelines,
      this.sampleImage,
      this.skippable,
      this.options,
      this.points,
      this.gallery,
      this.answers,
      this.visible});

  Questions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    questionId = json['question_id'];
    photoRequired = json['photo_required'];
    commentRequired = json['comment_required'];
    answerType = json['answer_type'];
    guidelines = json['guidelines'];
    sampleImage = json['sample_image'];
    skippable = json['skippable'];

    points = json['points'];
    gallery = json['gallery'] == 1 ? true : false;
    visible = json['visible'];

    if (json['options'] != null) {
      options = <AnsOptions>[];
      json['options'].forEach((v) {
        options.add(new AnsOptions.fromJson(v));
      });
    }
    answers = <Answer>[];
    if (json['answers'] != null) {
      answers = <Answer>[];
      json['answers'].forEach((v) {
        answers.add(new Answer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question'] = this.question;
    data['question_id'] = this.questionId;
    data['photo_required'] = this.photoRequired;
    data['comment_required'] = this.commentRequired;
    data['answer_type'] = this.answerType;
    data['guidelines'] = this.guidelines;
    data['sample_image'] = this.sampleImage;
    data['skippable'] = this.skippable;

    data['points'] = this.points;
    data['gallery'] = this.gallery ? 1 : 0;
    data['visible'] = this.visible;

    if (this.options != null) {
      data['options'] = this.options.map((v) => v.toJson()).toList();
    }
    if (this.answers != null) {
      data['answers'] = this.answers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AnsOptions {
  int id;
  int questionId;
  String option;
  int photoRequired;
  int commentRequired;
  int points;
  List skippable;

  AnsOptions(
      {this.id,
      this.questionId,
      this.option,
      this.photoRequired,
      this.commentRequired,
      this.points,
      this.skippable});

  AnsOptions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questionId = json['question_id'];
    option = json['option'];
    photoRequired = json['photo_required'];
    commentRequired = json['comment_required'];
    points = json['points'];
    skippable = json['skippable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question_id'] = this.questionId;
    data['option'] = this.option;
    data['photo_required'] = this.photoRequired;
    data['comment_required'] = this.commentRequired;
    data['points'] = this.points;
    data['skippable'] = this.skippable;

    return data;
  }
}

class Answer {
  int id;
  String comment;
  List<Image> images;
  int points;

  Answer({this.id, this.points, this.comment, this.images});

  Answer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    if (json['images'] != null) {
      images = <Image>[];
      json['images'].forEach((v) {
        images.add(new Image.fromJson(v));
      });
    }
    points = json['points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['comment'] = this.comment;
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    data['points'] = this.points;
    return data;
  }
}

class Image {
  String id;
  String image;

  Image({this.id, this.image});

  Image.fromJson(Map<String, dynamic> json) {
    id = getRandomString(10);
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    return data;
  }
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
