class PatientModel {
  List<Items> patientItems;

  PatientModel({this.patientItems});

  PatientModel.fromJson(Map<String, dynamic> json) {
    if (json['Items'] != null) {
      patientItems = new List<Items>();
      json['Items'].forEach((v) {
        patientItems.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.patientItems != null) {
      data['Items'] = this.patientItems.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String role;
  Profile profile;

  Items({this.role, this.profile});

  Items.fromJson(Map<String, dynamic> json) {
    role = json['role'];
    profile =
    json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['role'] = this.role;
    if (this.profile != null) {
      data['profile'] = this.profile.toJson();
    }
    return data;
  }
}

class Profile {
  String name;
  String gender;
  String email;

  Profile({this.name, this.gender, this.email});

  Profile.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    gender = json['gender'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['gender'] = this.gender;
    data['email'] = this.email;
    return data;
  }
}
