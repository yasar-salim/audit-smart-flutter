class AuditTypesResponse {
  int status;
  List<AuditType> auditTypes;

  AuditTypesResponse({this.status, this.auditTypes});

  AuditTypesResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['list'] != null) {
      auditTypes = <AuditType>[];
      json['list'].forEach((v) {
        auditTypes.add(new AuditType.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.auditTypes != null) {
      data['list'] = this.auditTypes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AuditType {
  int id;
  String name;

  AuditType({this.id, this.name});

  AuditType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
