import 'package:flutter/material.dart';
import 'package:hotaal/model/meal_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

//Provide
class MealPlanProvide with ChangeNotifier {
  String mealString = "[]";
  List<MealModel> mealList = [];
  double totalCalories = 0;
  double totalFat = 0;
  double totalCarbohydrates = 0;
  double totalProtein = 0;
  double totalFiber = 0;
  double totalVitaminC = 0;


  save(id, title, readyInMinutes, serving, imageUrl, time, calories, fat, carbohydrates, protein, fiber, vitaminC) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mealString = prefs.getString('mealInfo');
    var temp = mealString == null ? [] : json.decode(mealString.toString());
    List<Map> tempList = (temp as List).cast();
    var isHave = false;
    tempList.forEach((item) {
      if (item['id'] == id) {
        isHave = true;
      }
    });

    if (!isHave) {
      Map<String, dynamic> newMeals = {
        'id': id,
        'title': title,
        'readyInMinutes': readyInMinutes,
        'serving': serving,
        'imageUrl': imageUrl,
        'time': time,
        'calories': calories,
        'fat': fat,
        'carbohydrates': carbohydrates,
        'protein': protein,
        'fiber': fiber,
        'vitaminC': vitaminC,
        'isCheck': true
      };
      tempList.add(newMeals);
      mealList.add(new MealModel.fromJson(newMeals));
      totalCalories += double.parse(calories);
      totalFat += double.parse(fat);
      totalCarbohydrates += double.parse(carbohydrates);
      totalProtein += double.parse(protein);
      totalFiber += double.parse(fiber);
      totalVitaminC += double.parse(vitaminC);
    }

    mealString = json.encode(tempList).toString();

    prefs.setString('mealInfo', mealString);
    notifyListeners();
  }

  getMealInfo() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mealString = prefs.getString('mealInfo');

    mealList = [];
    if(mealString == null){
      mealList = [];
    }else{
      List<Map> tempList = (json.decode(mealString.toString()) as List).cast();
      tempList.forEach((item){
        mealList.add(new MealModel.fromJson(item));

      });
    }

    notifyListeners();
  }

  changeCheckState(MealModel mealItem) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mealString = prefs.getString('mealInfo');
    List<Map> tempList = (json.decode(mealString.toString()) as List).cast();
    int tempIndex = 0;
    int changeIndex = 0;
    tempList.forEach((item){
      if(item['id'] == mealItem.id){
        changeIndex = tempIndex;
      }
      tempIndex++;

    });
    tempList[changeIndex] = mealItem.toJson();
    mealString = json.encode(tempList).toString();
    prefs.setString('mealInfo', mealString);
    await getMealInfo();

  }

  deleteOneMeal(String id) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mealString = prefs.getString('mealInfo'); //获取持久化存储的值
    List<Map> tempList = (json.decode(mealString.toString()) as List).cast();

    int tempIndex = 0;
    int delIndex = 0;
    tempList.forEach((item){
      if(item['id'] == id){
        delIndex = tempIndex;
      }
      tempIndex++;

    });
    tempList.removeAt(delIndex);
    mealString = json.encode(tempList).toString();
    prefs.setString('mealInfo', mealString);
    await getMealInfo();
  }

}

// suger, saturatedFat, cholesterol, sodium, folate, vitaminK, managanese, phosphorus, vitaminB1,
//      potassium, vitaminB6, iron, vitaminB3, copper, selenium, zinc, vitaminB2, vitaminB12

//'suger': suger,
//'saturatedFat': saturatedFat,
//'cholesterol': cholesterol,
//'sodium': sodium,
//'folate': folate,
//'vitaminK': vitaminK,
//'managanese': managanese,
//'phosphorus':phosphorus,
//'vitaminB1': vitaminB1,
//'potassium': potassium,
//'vitaminB6': vitaminB6,
//'iron': iron,
//'vitaminB3': vitaminB3,
//'copper': copper,
//'selenium': selenium,
//'zinc': zinc,
//'vitaminB2': vitaminB2,
//'vitaminB12': vitaminB12,
