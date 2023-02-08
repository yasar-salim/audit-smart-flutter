class LocationResponse {
  int status;
  List<Location> locations;

  LocationResponse({this.status, this.locations});

  LocationResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['list'] != null) {
      locations = <Location>[];
      json['list'].forEach((v) {
        locations.add(new Location.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.locations != null) {
      data['list'] = this.locations.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Location {
  String siteid;
  String name;

  Location({this.siteid, this.name});

  Location.fromJson(Map<String, dynamic> json) {
    siteid = json['siteid'].toString();
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['siteid'] = this.siteid;
    data['name'] = this.name;
    return data;
  }
}
