
class Notifications {
  String title;
  String body;

  Notifications(
      {
        this.title,
        this.body,
      });

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
      title: json['title'],
      body: json['body'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> notis = new Map<String, dynamic>();
    notis['title'] = this.title;
    notis['body'] = this.body;
    return notis;
  }

  Map<dynamic,dynamic> toMap(){
    return {
      "title": this.title,
      "body": this.body,
    };
  }
}
