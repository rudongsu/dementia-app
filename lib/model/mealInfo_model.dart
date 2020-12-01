class MealInfoModel {
  int id;
  String title;
  int readyInMinutes;
  int servings;
  String image;
  String imageType;
  Nutrition nutrition;

  MealInfoModel(
      {
        this.id,
        this.title,
        this.readyInMinutes,
        this.servings,
        this.image,
        this.imageType,
        this.nutrition,
      });

  factory MealInfoModel.fromJson(Map<String, dynamic> json) {
    return MealInfoModel(
        id : json['id'],
        title : json['title'],
        readyInMinutes : json['readyInMinutes'],
        servings : json['servings'],
        image : json['image'],
        imageType : json['imageType'],
        nutrition : json['nutrition'] != null
        ? new Nutrition.fromJson(json['nutrition'])
        : null,
    );
    }
}

class Nutrition {
  List<Nutrients> nutrients;
  List<Ingredients> ingredients;

  Nutrition(
      {this.nutrients,
        this.ingredients,
      });

  Nutrition.fromJson(Map<String, dynamic> json) {
    if (json['nutrients'] != null) {
      nutrients = new List<Nutrients>();
      json['nutrients'].forEach((v) {
        nutrients.add(new Nutrients.fromJson(v));
      });
    }
    if (json['ingredients'] != null) {
      ingredients = new List<Ingredients>();
      json['ingredients'].forEach((v) {
        ingredients.add(new Ingredients.fromJson(v));
      });
    }
  }
}

class Nutrients {
  String title;
  double amount;
  String unit;
  double percentOfDailyNeeds;

  Nutrients({this.title, this.amount, this.unit, this.percentOfDailyNeeds});

  factory Nutrients.fromJson(Map<String, dynamic> json) {
    return Nutrients(
        title : json['title'],
        amount : json['amount'],
        unit : json['unit'],
        percentOfDailyNeeds : json['percentOfDailyNeeds'],
    );
  }
}

class Ingredients {
  String name;
  double amount;
  String unit;

  Ingredients({this.name, this.amount, this.unit});

  factory Ingredients.fromJson(Map<String, dynamic> json) {
    return Ingredients(
        name : json['name'],
        amount : json['amount'],
        unit : json['unit'],
    );
  }
}


