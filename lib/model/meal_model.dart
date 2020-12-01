class MealModel{
  String id;
  String title;
  String readyInMinutes;
  String serving;
  String imageUrl;
  String time;
  String calories;
  String fat;
  String carbohydrates;
  String protein;
  String fiber;
  String vitaminC;
  bool isCheck;

  MealModel({this.id, this.title, this.readyInMinutes, this.serving, this.imageUrl, this.time, this.calories, this.fat,
  this.carbohydrates, this.protein, this.fiber, this.vitaminC});

  MealModel.fromJson(Map<String,dynamic> json){
    id = json['id'];
    title = json['title'];
    readyInMinutes = json['readyInMinutes'];
    serving = json['serving'];
    imageUrl = json['imageUrl'];
    time = json['time'];
    isCheck = json['isCheck'];

  }

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['readyInMinutes'] = this.readyInMinutes;
    data['serving'] = this.serving;
    data['imageUrl'] = this.imageUrl;
    data['time'] = this.time;
    data['isCheck'] = this.isCheck;
    return data;
  }

}
