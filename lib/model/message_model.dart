class MessageModel {
  List<Items> items;

  MessageModel({this.items});

  MessageModel.fromJson(Map<String, dynamic> json) {
    if (json['Items'] != null) {
      items = new List<Items>();
      json['Items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['Items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String author;
  String message;
  double timestamp;
  List<String> image;

  Items({this.author, this.message, this.timestamp, this.image});

  Items.fromJson(Map<String, dynamic> json) {
    author = json['author'];
    message = json['message'];
    timestamp = json['timestamp'];
    if(json['image'] != null)
      image = json['image'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['author'] = this.author;
    data['message'] = this.message;
    data['timestamp'] = this.timestamp;
    data['image'] = this.image;
    return data;
  }
}
