// menu model
class MenuModel {
  List<Meals> meals;
  Nutrients nutrients;
  Notes notes;

  MenuModel({this.meals, this.nutrients, this.notes});

  MenuModel.fromJson(Map<String, dynamic> json) {
    if (json['meals'] != null) {
      meals = new List<Meals>();
      json['meals'].forEach((v) {
        meals.add(new Meals.fromJson(v));
      });
    }
    nutrients = json['nutrients'] != null
        ? new Nutrients.fromJson(json['nutrients'])
        : null;
    notes = json['notes'] != null
        ? new Notes.fromJson(json['notes'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.meals != null) {
      data['meals'] = this.meals.map((v) => v.toJson()).toList();
    }
    if (this.nutrients != null) {
      data['nutrients'] = this.nutrients.toJson();
    }
    if (this.notes != null) {
      data['notes'] = this.notes.toJson();
    }
    return data;
  }

  Map<dynamic,dynamic> toMap(){
    return {
      "meals": this.meals.map((x)=>x.toMap()).toList(),
      "nutrients": this.nutrients.toMap(),
      "notes": this.notes.toMap()
    };
  }
}

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
      id : int.parse(json['id']),
      title : json['title'],
      readyInMinutes : int.parse(json['readyInMinutes']),
      servings : int.parse(json['servings']),
      image : json['image'],
      imageUrls : json['imageUrls'].cast<String>(),
      mealTime : json['mealTime'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['readyInMinutes'] = this.readyInMinutes;
    data['servings'] = this.servings;
    data['image'] = this.image;
    data['imageUrls'] = this.imageUrls;
    data['mealTime'] = this.mealTime;
    return data;
  }

  Map<dynamic,dynamic> toMap(){
    return {
      "id": this.id.toString(),
      "title": this.title,
      'readyInMinutes' : this.readyInMinutes.toString(),
      'servings' : this.servings.toString(),
      'image' : this.image,
      'imageUrls' : this.imageUrls,
      'mealTime' : this.mealTime
    };
  }
}
class Nutrients {
  double calories;
  double protein;
  double fat;
  double carbohydrates;
  double fiber;
  double vitaminC;
  double caloriesTarget;
  double proteinTarget;
  double fatTarget;
  double carbohydratesTarget;
  double fiberTarget;
  double vitaminCTarget;

  Nutrients({this.calories, this.protein, this.fat, this.carbohydrates, this.fiber, this.vitaminC,
  this.caloriesTarget, this.proteinTarget, this.fatTarget, this.carbohydratesTarget, this.fiberTarget, this.vitaminCTarget});

  factory Nutrients.fromJson(Map<String, dynamic> json) {
    return Nutrients(
      calories : double.parse(json['calories'].toString()),
      protein : double.parse(json['protein'].toString()),
      fat : double.parse(json['fat'].toString()),
      carbohydrates : double.parse(json['carbohydrates'].toString()),
      fiber : double.parse(json['fiber'].toString()),
      vitaminC : double.parse(json['vitaminC'].toString()),
      caloriesTarget : double.parse(json['caloriesTarget'].toString()),
      proteinTarget : double.parse(json['proteinTarget'].toString()),
      fatTarget : double.parse(json['fatTarget'].toString()),
      carbohydratesTarget : double.parse(json['carbohydratesTarget'].toString()),
      fiberTarget : double.parse(json['fiberTarget'].toString()),
      vitaminCTarget : double.parse(json['vitaminCTarget'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['calories'] = this.calories;
    data['protein'] = this.protein;
    data['fat'] = this.fat;
    data['carbohydrates'] = this.carbohydrates;
    data['fiber'] = this.fiber;
    data['vitminC'] = this.vitaminC;
    return data;
  }

  Map<dynamic,dynamic> toMap(){
    return {
      "calories": this.calories.toString(),
      "protein": this.protein.toString(),
      'fat' : this.fat.toString(),
      'carbohydrates' : this.carbohydrates.toString(),
      'fiber' : this.fiber.toString(),
      'vitaminC' : this.vitaminC.toString(),
      "caloriesTarget": this.caloriesTarget.toString(),
      "proteinTarget": this.proteinTarget.toString(),
      'fatTarget' : this.fatTarget.toString(),
      'carbohydratesTarget' : this.carbohydratesTarget.toString(),
      'fiberTarget' : this.fiberTarget.toString(),
      'vitaminCTarget' : this.vitaminCTarget.toString()
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
