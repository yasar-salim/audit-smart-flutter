class SubmitResponse {
  bool status;

  SubmitResponse({this.status});

  SubmitResponse.fromJson(Map<String, dynamic> json) {
    status = json['status']==1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    return data;
  }
}
