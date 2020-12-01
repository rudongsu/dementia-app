import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

// menu model
@JsonSerializable(explicitToJson: true)

class MenuModel {
  List<Meals> meals;
  Nutrients nutrients;
  Notes notes;

  MenuModel({this.meals, this.nutrients, this.notes});

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    var meals = json['meals'] as List;
    List<Meals> meal = meals.map((x)=>Meals.fromJson(x)).toList();
    Nutrients nutrients = json['nutrients'] != null
        ? new Nutrients.fromJson(json['nutrients'])
        : null;
    Notes notes = json['notes'] != null
        ? new Notes.fromJson(json['notes'])
        : null;
    return MenuModel(meals: meal, nutrients: nutrients, notes: notes);
  }

  String toJson(){
    return json.encode(toMap());
  }

  Map<dynamic,dynamic> toMap(){
    return {
      "meals": this.meals.map((x)=>x.toMap()).toList(),
      "nutrients": this.nutrients.toMap(),
      "notes": this.notes.toMap()

    };
  }
}
@JsonSerializable()

class Meals {
  int id;
  String title;
  int readyInMinutes;
  int servings;
  String image;
  List<String> imageUrls;
  String mealTime;

  Meals(
      {this.id,
        this.title,
        this.readyInMinutes,
        this.servings,
        this.image,
        this.imageUrls,
        this.mealTime});

  factory Meals.fromJson(Map<String, dynamic> json) {
    return Meals(
      id : double.parse(json['id'].toString()).round(),
      title : json['title'],
      readyInMinutes : double.parse(json['readyInMinutes'].toString()).round(),
      servings : double.parse(json['servings'].toString()).round(),
      image : json['image'],
      imageUrls : json['imageUrls'].cast<String>(),
      mealTime: json['mealTime']
    );
  }

  String toJson(){
    return json.encode(toMap());
  }

  Map<dynamic,dynamic> toMap(){
    return {
      "id": this.id.toString(),
      "title": this.title,
      'readyInMinutes' : this.readyInMinutes.toString(),
      'servings' : this.servings.toString(),
      'image' : this.image,
      'imageUrls' : this.imageUrls,
      'mealTime': this.mealTime
    };
  }
}

class Nutrients {
  double calories;
  double protein;
  double fat;
  double carbohydrates;

  Nutrients({this.calories, this.protein, this.fat, this.carbohydrates});

  factory Nutrients.fromJson(Map<String, dynamic> json) {
    return Nutrients(
      calories : double.parse(json['calories'].toString()),
      protein : double.parse(json['protein'].toString()),
      fat : double.parse(json['fat'].toString()),
      carbohydrates : double.parse(json['carbohydrates'].toString()),
    );
  }

  String toJson(){
    return json.encode(toMap());
  }

  Map<dynamic,dynamic> toMap(){
    return {
      "calories": this.calories.toString(),
      "protein": this.protein.toString(),
      'fat' : this.fat.toString(),
      'carbohydrates' : this.carbohydrates.toString()
    };
  }
}

class Notes {
  String date;
  String message;

  Notes({this.date, this.message});

  factory Notes.fromJson(Map<String, dynamic> json) {
    return Notes(
      date : json['date'],
      message : json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['message'] = this.message;
    return data;
  }

  Map<dynamic,dynamic> toMap(){
    return {
      "date": this.date,
      "message": this.message,
    };
  }
}
