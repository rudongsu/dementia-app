import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hotaal/dao/menu_dao.dart';
import 'package:hotaal/model/meal_model.dart';
import 'package:hotaal/model/menu_model.dart';
import 'package:hotaal/page/menu_page.dart';
import 'package:hotaal/provide/mealplan_provide.dart';
import 'package:hotaal/widget/meal_item.dart';
import 'package:provide/provide.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'confirm_page.dart';

/// menu plan
class MealPlanPage extends StatefulWidget {
  @override
  _MealPlanPageState createState() => _MealPlanPageState();
}

class _MealPlanPageState extends State<MealPlanPage> {
  MenuModel menuModel;
  List<MealModel> breakfastModel = new List<MealModel>();
  List<MealModel> lunchModel = new List<MealModel>();
  List<MealModel> dinnerModel = new List<MealModel>();
  TextEditingController _controller = TextEditingController();
  var id = '';
  var title = '';
  var readyInMinutes = '';
  var imageUrl = '';
  var servings = '';
  var mealTime = '';
  double carlories = 0;
  double carbs = 0;
  double fat = 0;
  double protein = 0;
  double fiber = 0;
  double vitaminC = 0;
  double targetCalories = 600.0;
  double targetCarbs = 100.0;
  double targetFat = 50.0;
  double targetProtein = 100.0;
  double targetFiber = 100;
  double targetVitaminC = 100;
  var patient = '';
  var _time;
  String timestamp;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<Null> _load() async {
    await Future.delayed(Duration(seconds: 1));
    if(mounted){
      setState(() {
        _getMealInfo();
      });
    }
    _patientName();
    _getTarget();
  }

  void saveString() {
  Notes notes = Notes(
    date: timestamp,
    message: _controller.text == null ? ' ' : _controller.text,
  );

  Nutrients n = Nutrients(
    calories : double.parse(carlories.toStringAsFixed(2)),
    fat: double.parse(fat.toStringAsFixed(2)),
    carbohydrates: double.parse(carbs.toStringAsFixed(2)),
    protein: double.parse(protein.toStringAsFixed(2)),
    fiber: double.parse(fiber.toStringAsFixed(2)),
    vitaminC: double.parse(vitaminC.toStringAsFixed(2)),
    caloriesTarget : targetCalories,
    fatTarget: targetFat,
    carbohydratesTarget: targetCarbs,
    proteinTarget: targetProtein,
    fiberTarget: targetFiber,
    vitaminCTarget: targetVitaminC,
  );

  List<Meals> meals = new List<Meals>();
  Meals tempMeal;
  for(var i = 0; i < breakfastModel.length; i++)
    {
      tempMeal = Meals(
        id: int.parse(breakfastModel[i].id),
        title: breakfastModel[i].title,
        readyInMinutes: int.parse(breakfastModel[i].readyInMinutes),
        image: 'image',
        imageUrls: [breakfastModel[i].imageUrl],
        servings: int.parse(breakfastModel[i].serving),
        mealTime: breakfastModel[i].time);
      meals.add(tempMeal);
    }
  for(var i = 0; i < lunchModel.length; i++)
  {
    tempMeal = Meals(
        id: int.parse(lunchModel[i].id),
        title: lunchModel[i].title,
        readyInMinutes: int.parse(lunchModel[i].readyInMinutes),
        image: 'image',
        imageUrls: [lunchModel[i].imageUrl],
        servings: int.parse(lunchModel[i].serving),
        mealTime: lunchModel[i].time);
    meals.add(tempMeal);
  }
  for(var i = 0; i < dinnerModel.length; i++)
  {
    tempMeal = Meals(
        id: int.parse(dinnerModel[i].id),
        title: dinnerModel[i].title,
        readyInMinutes: int.parse(dinnerModel[i].readyInMinutes),
        image: 'image',
        imageUrls: [dinnerModel[i].imageUrl],
        servings: int.parse(dinnerModel[i].serving),
        mealTime: dinnerModel[i].time);
    meals.add(tempMeal);
  }

    MenuModel menu = MenuModel(meals: meals, nutrients: n, notes: notes);

    Map request = {"owner": patient, "content": menu.toMap()};
    Future<int> res = MenuDao.post(json.encode(request));
    setState(() {});
    res.then((val) {
      if (val == 1) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(title: Text("SUCCESS!"));
            });
      } else {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(title: Text("FAIL!"));
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if(breakfastModel == null && lunchModel == null && dinnerModel == null) return Container();
    else
    return Scaffold(

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
                height: 50,
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.only(left: 10.0),
                child: Card(
                  elevation: 10,
                  child: Text(' b r e a k f a s t ', style: TextStyle(color: Colors.blue, fontSize: 25, fontWeight: FontWeight.bold)),
                )

            ),
            Container(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _breakfastList(),
              ),
            ),
            Container(
              height: 50,
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(left: 10.0),
              child: Card(
                elevation: 10,
                child: Text(' l u n c h ', style: TextStyle(color: Colors.blue, fontSize: 25, fontWeight: FontWeight.bold)),
              ),
            ),
            Container(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _lunchList(),
              ),
            ),
            Container(
              height: 50,
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(left: 10.0),
              child: Card(
                elevation: 10,
                child: Text(' d i n n e r ', style: TextStyle(color: Colors.blue, fontSize: 25, fontWeight: FontWeight.bold)),
              ),
            ),
            Container(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _dinnerList(),
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(

          child: Icon(Icons.shopping_basket),

          onPressed: (){
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => ConfirmPage()));
          },
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          elevation: 0.0,
          child: ButtonBar(
            alignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RaisedButton(
                elevation: 5,
                shape: StadiumBorder(),
                color: Colors.blue,
                child: new Text('Start a new plan',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MenuPage()));
                },
              ),
              RaisedButton(
                elevation: 5,
                shape: StadiumBorder(),
                color: Colors.blue,
                child: new Text(
                  'send ->', style: TextStyle(color: Colors.white, fontSize: 20)),
                onPressed: () {
                  return showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, state) {
                          return AlertDialog(
                            title: Text('please input message'),
                            content: Card(
                              elevation: 0.0,
                              child: Column(
                                children: <Widget>[
                                  TextField(
                                      maxLines: 6,
                                      controller: _controller,
                                      decoration: InputDecoration(
                                        hintText: 'note:',
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.grey,
                                            width: 1,
                                          ),
                                        ),
                                      )
                                  )
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              RaisedButton(
                                color: Colors.grey,
                                shape: StadiumBorder(),
                                onPressed: () {
                                  _showDataPicker(state);
                                },
                                child: Text(
                                    _time == null ? 'Choose Date' : _time,
                                    style: TextStyle(color: Colors.white),
                                ),
                              ),
                              FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('cancel'),
                              ),
                              FlatButton(
                                onPressed: () {
                                  saveString();
                                  Navigator.pop(context);
                                },
                                child: Text('confirm'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              )
            ],
          )),
    );
  }


  _showDataPicker(state) async {
    var picker = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2018),
        lastDate: DateTime(2021),
    );
    state(() {
      picker.toString().length < 10 ? _time = 'Choose Date' : _time = picker.toString().substring(0, 10);
    });
  }

    _patientName() async {
      SharedPreferences sp = await SharedPreferences.getInstance();
      patient = sp.getString('patient');
    }

  _getTarget() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if(sp.getDouble('targetCalories') != 0 && sp.getDouble('targetCalories') != null)
      targetCalories = sp.getDouble('targetCalories');
    if(sp.getDouble('targetFat') != 0 && sp.getDouble('targetFat') != null)
      targetFat = sp.getDouble('targetFat');
    if(sp.getDouble('targetCarbs') != 0 && sp.getDouble('targetCarbs') != null)
      targetCarbs = sp.getDouble('targetCarbs');
    if(sp.getDouble('targetProtein') != 0 && sp.getDouble('targetProtein') != null)
      targetProtein = sp.getDouble('targetProtein');
    if(sp.getDouble('targetFiber') != 0 && sp.getDouble('targetFiber') != null)
      targetFiber = sp.getDouble('targetFiber');
    if(sp.getDouble('targetVitminC') != 0 && sp.getDouble('targetVitminC') != null)
      targetVitaminC = sp.getDouble('targetVitminC');

  }
  
  _getMealInfo() async {
    await Provide.value<MealPlanProvide>(context).getMealInfo();
    List mealList = Provide.value<MealPlanProvide>(context).mealList;
    carlories = Provide.value<MealPlanProvide>(context).totalCalories;
    fat = Provide.value<MealPlanProvide>(context).totalFat;
    carbs = Provide.value<MealPlanProvide>(context).totalCarbohydrates;
    protein = Provide.value<MealPlanProvide>(context).totalProtein;

    List<MealModel> mealModel = new List<MealModel>();
    for(var i = 0; i < mealList.length; i++){
      mealModel.add(mealList[i]);
    }
    for(var j = 0; j < mealModel.length; j++){
      if(mealModel[j].time == 'breakfast'){
        breakfastModel.add(mealModel[j]);
      }else if(mealModel[j].time == 'lunch'){
        lunchModel.add(mealModel[j]);
      }else{
        dinnerModel.add(mealModel[j]);
      }
    }
  }

  List<Widget> _breakfastList() {
    return breakfastModel.map((meal) => _item(meal.title, meal.imageUrl)).toList();
  }

  List<Widget> _lunchList() {
    return lunchModel.map((meal) => _item(meal.title, meal.imageUrl)).toList();
  }

  List<Widget> _dinnerList() {
    return dinnerModel.map((meal) => _item(meal.title, meal.imageUrl)).toList();
  }

  Widget _item(String title, String url){
    return Container(
      width: 500,
      margin: EdgeInsets.only(right: 5),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: Colors.transparent),
      child: Row(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(left: 20)),
          Image.network(
          url,
          height: 150,
          width: 120,
          alignment: Alignment.center,
        ),
        Container(
          width: 200,
          margin: EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          child: Text(title,
              style: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        ],
      ),
    );
  }

}
