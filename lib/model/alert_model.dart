// alert model
class AlertModel {
  List<Items> alerts;

  AlertModel({this.alerts});

  AlertModel.fromJson(Map<String, dynamic> json) {
    if (json['Items'] != null) {
      alerts = new List<Items>();
      json['Items'].forEach((v) {
        alerts.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.alerts != null) {
      data['Items'] = this.alerts.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  Content content;
  String user;
  bool isRead;
  double timestamp;

  Items({this.content, this.user, this.isRead, this.timestamp});

  Items.fromJson(Map<String, dynamic> json) {
    content =
    json['content'] != null ? new Content.fromJson(json['content']) : null;
    user = json['user'];
    isRead = json['is_read'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.content != null) {
      data['content'] = this.content.toJson();
    }
    data['user'] = this.user;
    data['is_read'] = this.isRead;
    data['timestamp'] = this.timestamp;
    return data;
  }
}

class Content {
  String title;
  String body;

  Content({this.title, this.body});

  Content.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['body'] = this.body;
    return data;
  }
}
