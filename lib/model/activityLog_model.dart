class ActivityLogModel {
  List<Items> items;

  ActivityLogModel({this.items});

  ActivityLogModel.fromJson(Map<String, dynamic> json) {
    if (json['Items'] != null) {
      items = new List<Items>();
      json['Items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
  }
}

class Items {
  List<Devices> devices;
  String timestampLocal;

  Items({this.devices, this.timestampLocal});

  Items.fromJson(Map<String, dynamic> json) {
    if (json['devices'] != null) {
      devices = new List<Devices>();
      json['devices'].forEach((v) {
        devices.add(new Devices.fromJson(v));
      });
    }
    timestampLocal = json['timestamp_local'];
  }
}

class Devices {
  String deviceName;
  List<String> usages;

  Devices({this.deviceName, this.usages});

  Devices.fromJson(Map<String, dynamic> json) {
    deviceName = json['device_name'];
    usages = json['usages'].cast<String>();
  }
}
