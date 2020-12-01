import 'dart:convert';

class shopModel {
  List<Groceries> groceries;
  shopModel({this.groceries});

  factory shopModel.fromJson(Map<String, dynamic> json) {
    var groceries = json['groceries'] as List;
    List<Groceries> grocery = groceries.map((x)=>Groceries.fromJson(x)).toList();
    return shopModel(groceries: grocery);
  }

  String toJson(){
    return json.encode(toMap());
  }

  Map<dynamic,dynamic> toMap(){
    return {
      "groceries": this.groceries.map((x)=>x.toMap()).toList(),
    };
  }
}

class Groceries {
  String unit;
  double amount;
  double price;
  String name;
  bool isInInventory;
  Groceries(
      {
        this.unit,
        this.amount,
        this.price,
        this.name,
        this.isInInventory,
      });

  factory Groceries.fromJson(Map<String, dynamic> json) {
    return Groceries(
      unit: json['unit'],
      amount: double.parse(json['amount'].toString()),
      price: double.parse(json['price'].toString()),
      name: json['name'],
      isInInventory: json['isInInventory']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> sh = new Map<String, dynamic>();
    sh['unit'] = this.unit;
    sh['amount'] = this.amount;
    sh['price'] = this.price;
    sh['name'] = this.name;
    sh['isInInventory'] = this.isInInventory;

    return sh;
  }

  Map<dynamic,dynamic> toMap(){
    return {
      "unit": this.unit,
      "amount": this.amount.toString(),
      "price":this.price.toString(),
      "name":this.name,
      "isInInventory": this.isInInventory,
    };
  }
}
