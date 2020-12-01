import 'package:flutter/material.dart';
import 'package:hotaal/page/activityLog_page.dart';
import 'package:hotaal/provide/mealplan_provide.dart';
import 'package:provide/provide.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waveprogressbar_flutter/waveprogressbar_flutter.dart';

List<String> Nutrition_Name = ['calories', 'fat', 'carbohydrates', 'protein', 'fiber', 'vitamin A', 'vitamin C'];
const FURL = 'https://api.spoonacular.com/recipes/';
const EURL = '/nutritionWidget.json?apiKey=53a56460fcf24acf82b91106279f8130';

/// caregiver
class NutritionPage extends StatefulWidget {
  @override
  _NutritionPageState createState() => _NutritionPageState();
}

class _NutritionPageState extends State<NutritionPage> {
//  double waterHeight = 0.3;
  WaterController waterController = WaterController();
  bool isLoading = false;
  var id;
  double calories = 0.0;
  double carbs = 0.0;
  double fat = 0.0;
  double protein = 0.0;
  double fiber = 0.0;
  double vitaminC = 0.0;
  double targetCalories = 2000.0;
  double targetCarbs = 300.0;
  double targetFat = 100.0;
  double targetProtein = 600.0;
  double targetFiber = 100;
  double targetVitaminC = 100;

  @override
  void initState() {
    super.initState();
    _getId();
  }


//  void _fetchInfo() {
//    setState(() {
//      isLoading = true;
//    });
//    NutritionDao.fetch(FURL + id.toString() + EURL)
//        .then((NutritionModel model) {
//      nutritionModel = model;
//      _getNutrition();
//      _setTarget();
//      setState(() {
//        isLoading = false;
//      });
//    }).catchError((e) {
//      print(e);
//    });
//  }

//  Future<Null> _refresh() async {
////    await Future.delayed(Duration(seconds: 1));
////    await _getId();
//    if(mounted){
//      setState(() {
////      _fetchInfo();
//        _getNutrition();
////      _setTarget();
//      });
//    }
//  }

//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      body:
////      isLoading
////          ? Center(
////          child: Column(
////            children: <Widget>[
////              CircularProgressIndicator(),
////              Padding(
////                padding: const EdgeInsets.only(top: 26.0),
////                child: (Text('loading...', style: TextStyle(
////                    fontWeight: FontWeight.bold, color: Colors.blue))),
////              )
////            ],
////          ))
////          :
//      RefreshIndicator(
//        onRefresh: _refresh,
//        child: GridView.count(
//        crossAxisCount: 2,
//        children: <Widget>[
////                  _waveBar(double.parse(nutritionModel.calories)/targetCalories > 1 ? 1 : double.parse(nutritionModel.calories)/targetCalories, Nutrition_Name[0] + ': ' + nutritionModel.calories + ' kj'),
////                  _waveBar(double.parse(nutritionModel.carbs.substring(0, nutritionModel.carbs.length-1))/targetCarbs > 1 ? 1 : double.parse(nutritionModel.carbs.substring(0, nutritionModel.carbs.length-1))/targetCarbs, Nutrition_Name[1] + ': ' + nutritionModel.carbs),
////                  _waveBar(double.parse(nutritionModel.fat.substring(0, nutritionModel.fat.length-1))/targetFat > 1 ? 1 : double.parse(nutritionModel.fat.substring(0, nutritionModel.fat.length-1))/targetFat, Nutrition_Name[2] + ': ' + nutritionModel.fat),
////                  _waveBar(double.parse(nutritionModel.protein.substring(0, nutritionModel.protein.length-1))/targetProtein > 1 ? 1 : double.parse(nutritionModel.protein.substring(0, nutritionModel.protein.length-1))/targetProtein, Nutrition_Name[3] + ': ' + nutritionModel.protein),
//
//
//          _waveBar(
//              calories / targetCalories > 1
//                  ? 1
//                  : calories / targetCalories,
//              Nutrition_Name[0] + ': ' + calories.toStringAsFixed(2) + ' cal'),
//
//          _waveBar(fat / targetFat > 1 ? 1 : fat / targetFat,
//              Nutrition_Name[1] + ': ' + fat.toStringAsFixed(2) + 'g'),
//
//          _waveBar(carbs / targetCarbs > 1 ? 1 : carbs / targetCarbs,
//              Nutrition_Name[2] + ': ' + carbs.toStringAsFixed(2) + 'g'),
//
//          _waveBar(
//              protein / targetProtein > 1 ? 1 : protein / targetProtein,
//              Nutrition_Name[3] + ': ' + protein.toStringAsFixed(2) + 'g'),
//
//          _waveBar(
//              fiber / targetFiber > 1 ? 1 : fiber / targetFiber,
//              Nutrition_Name[4] + ': ' + fiber.toStringAsFixed(2) + 'g'),
//
//          _waveBar(
//              vitaminA / targetVitaminA > 1 ? 1 : vitaminA / targetVitaminA,
//              Nutrition_Name[5] + ': ' + vitaminA.toInt().toString() + 'IU'),
//
//          _waveBar(
//              vitaminC / targetVitaminC > 1 ? 1 : vitaminC / targetVitaminC,
//              Nutrition_Name[6] + ': ' + vitaminC.toStringAsFixed(2) + 'mg'),
//
////          _nutritionInfo,
//        ],
//      ),
//      ),
//    );
//  }

//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//        body: RefreshIndicator(
//            onRefresh: _refresh,
//            child: GridView.count(
//                crossAxisCount: 2,
//                children: <Widget>[
//            _waveBar(
//            calories / targetCalories > 1
//                ? 1
//                : calories / targetCalories,
//                Nutrition_Name[0] + ': ' + calories.toStringAsFixed(2) + ' cal'),
//
//            _waveBar(fat / targetFat > 1 ? 1 : fat / targetFat,
//                Nutrition_Name[1] + ': ' + fat.toStringAsFixed(2) + 'g'),
//
//            _waveBar(carbs / targetCarbs > 1 ? 1 : carbs / targetCarbs,
//                Nutrition_Name[2] + ': ' + carbs.toStringAsFixed(2) + 'g'),
//
//            _waveBar(
//                protein / targetProtein > 1 ? 1 : protein / targetProtein,
//                Nutrition_Name[3] + ': ' + protein.toStringAsFixed(2) + 'g'),
//
//            _waveBar(
//                fiber / targetFiber > 1 ? 1 : fiber / targetFiber,
//                Nutrition_Name[4] + ': ' + fiber.toStringAsFixed(2) + 'g'),
//
//            _waveBar(
//                vitaminA / targetVitaminA > 1 ? 1 : vitaminA / targetVitaminA,
//                Nutrition_Name[5] + ': ' + vitaminA.toInt().toString() + 'IU'),
//
//            _waveBar(
//                vitaminC / targetVitaminC > 1 ? 1 : vitaminC / targetVitaminC,
//                Nutrition_Name[6] + ': ' + vitaminC.toStringAsFixed(2) + 'mg'),
//                ],
//            ),
//        ),
//    );
//  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: _getNutriInfo(context),
            builder: (context, snapshot) {
//              List mealList = Provide.value<MealPlanProvide>(context).mealList;
//              calories = Provide
//                  .value<MealPlanProvide>(context)
//                  .totalCalories;
//              fat = Provide
//                  .value<MealPlanProvide>(context)
//                  .totalFat;
//              carbs = Provide
//                  .value<MealPlanProvide>(context)
//                  .totalCarbohydrates;
//              protein = Provide
//                  .value<MealPlanProvide>(context)
//                  .totalProtein;
//              fiber = Provide
//                  .value<MealPlanProvide>(context)
//                  .totalFiber;
//              vitaminC = Provide
//                  .value<MealPlanProvide>(context)
//                  .totalVitaminC;
//              if(mealList.length == 0){
//                calories = 0;
//                fat = 0;
//                carbs = 0;
//                protein = 0;
//                fiber = 0;
//                vitaminC = 0;
//              }
              if(snapshot.connectionState == ConnectionState.waiting)
                return Center(
                  child: CircularProgressIndicator(),
                );
              if (snapshot.hasData) {
                return GridView.count(
                  crossAxisCount: 2,
                  children: <Widget>[
                    _waveBar(calories / targetCalories > 1
                        ? 1
                        : calories / targetCalories,
                        Nutrition_Name[0] + ': ' + calories.toStringAsFixed(2) + ' cal'),

                    _waveBar(fat / targetFat > 1 ? 1 : fat / targetFat,
                        Nutrition_Name[1] + ': ' + fat.toStringAsFixed(2) + 'g'),

                    _waveBar(carbs / targetCarbs > 1 ? 1 : carbs / targetCarbs,
                        Nutrition_Name[2] + ': ' + carbs.toStringAsFixed(2) + 'g'),

                    _waveBar(
                        protein / targetProtein > 1 ? 1 : protein / targetProtein,
                        Nutrition_Name[3] + ': ' + protein.toStringAsFixed(2) + 'g'),

                    _waveBar(
                        fiber / targetFiber > 1 ? 1 : fiber / targetFiber,
                        Nutrition_Name[4] + ': ' + fiber.toStringAsFixed(2) + 'g'),

                    _waveBar(
                        vitaminC / targetVitaminC > 1 ? 1 : vitaminC / targetVitaminC,
                        Nutrition_Name[6] + ': ' + vitaminC.toStringAsFixed(2) + 'mg'),

                    _nutritionInfo,
                  ],
                );
              }
              else{
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            })

    );
  }


  Widget _waveBar(double percent, String text) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: new Column(
        children: <Widget>[
          new WaveProgressBar(
            flowSpeed: 2.0,
            waveDistance: 45.0,
            waterColor: percent == 1 ? Colors.green[200]
                : percent < 0.2 ? Colors.red :
            Colors.blue,
            strokeCircleColor: percent == 1 ? Colors.green[200]
                : percent < 0.2 ? Colors.red :
            Colors.blue,
            heightController: waterController,
            percentage: percent,
            size: new Size(150, 150),
            textStyle: new TextStyle(
                color: Color(0x15000000),
                fontSize: 60.0,
                fontWeight: FontWeight.bold),
          ),
          new Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: percent == 1 ? Colors.green[200]
                        : percent < 0.2 ? Colors.red :
                    Colors.blue,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget get _nutritionInfo {
    return Column(
      children: <Widget>[
        IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ActivityPage()));
            },
            iconSize: 100,
            icon: Icon(Icons.arrow_forward, color: Colors.blue)),
        Text('view activity log',
            style: TextStyle(
                color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold))
      ],
    );
  }

//  _item(int position) {
//    if (nutritionModel == null ||
//        nutritionModel.good == null) return null;
//    Good benefit = nutritionModel.good[position];
//    return Container(
//      height: 50,
//      margin: EdgeInsets.only(left: 20, top: 10, bottom: 10),
//      decoration: BoxDecoration(
//          border:
//          Border(bottom: BorderSide(width: 0.3, color: Colors.grey))),
//      child: Container(
//        width: 300,
//        child: Text(
//          '${benefit.title} : ${benefit.amount}',
//          style: TextStyle(color: Colors.grey, fontSize: 20),
//        ),
//      ),
//    );
//  }

  _getId() async {
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

//  _setTarget() async {
//    SharedPreferences sp = await SharedPreferences.getInstance();
//    sp.setString('calories', nutritionModel.calories);
//    sp.setString('carbs', nutritionModel.carbs);
//    sp.setString('fat', nutritionModel.fat);
//    sp.setString('protein', nutritionModel.protein);
//    sp.setBool(
//        'caloryT',
//        double.parse(nutritionModel.calories) / targetCalories > 1
//            ? true
//            : false);
//    sp.setBool(
//        'carbsT',
//        double.parse(nutritionModel.carbs
//            .substring(0, nutritionModel.carbs.length - 1)) /
//            targetCarbs >
//            1
//            ? true
//            : false);
//    sp.setBool(
//        'fatT',
//        double.parse(nutritionModel.fat
//            .substring(0, nutritionModel.fat.length - 1)) /
//            targetFat >
//            1
//            ? true
//            : false);
//    sp.setBool(
//        'proteinT',
//        double.parse(nutritionModel.protein
//            .substring(0, nutritionModel.protein.length - 1)) /
//            targetProtein >
//            1
//            ? true
//            : false);
//    sp.setString(
//        'numOfAlert',
//        ((double.parse(nutritionModel.calories) >= targetCalories ? 0 : 1) +
//            (double.parse(nutritionModel.carbs
//                .substring(0, nutritionModel.carbs.length - 1)) >=
//                targetCarbs
//                ? 0
//                : 1) +
//            (double.parse(nutritionModel.fat
//                .substring(0, nutritionModel.fat.length - 1)) >=
//                targetFat
//                ? 0
//                : 1) +
//            (double.parse(nutritionModel.protein
//                .substring(0, nutritionModel.protein.length - 1)) >=
//                targetProtein
//                ? 0
//                : 1))
//            .toString());
//  }

//  _getNutrition() async {
//    await Provide.value<MealPlanProvide>(context).getMealInfo();
//    calories = Provide
//        .value<MealPlanProvide>(context)
//        .totalCalories;
//    fat = Provide
//        .value<MealPlanProvide>(context)
//        .totalFat;
//    carbs = Provide
//        .value<MealPlanProvide>(context)
//        .totalCarbohydrates;
//    protein = Provide
//        .value<MealPlanProvide>(context)
//        .totalProtein;
//    fiber = Provide
//        .value<MealPlanProvide>(context)
//        .totalFiber;
//    vitaminC = Provide
//        .value<MealPlanProvide>(context)
//        .totalVitaminC;
//  }

  Future _getNutriInfo(BuildContext context) async {
    await Provide.value<MealPlanProvide>(context).getMealInfo();
    return 'end';
  }
}


//  _getNutrition() {
//    calories = double.parse(nutritionModel.calories);
//    carbs = double.parse(
//        nutritionModel.carbs.substring(0, nutritionModel.carbs.length - 1));
//    fat = double.parse(
//        nutritionModel.fat.substring(0, nutritionModel.fat.length - 1));
//    protein = double.parse(
//        nutritionModel.protein.substring(0, nutritionModel.protein.length - 1));
//  }
//}

//import 'package:flutter/material.dart';
//
//List<String> Nutrition_Name = ['calories', 'carbohydrates', 'fats', 'proteins',
//  'others'];
//
///// caregiver
//class NutritionPage extends StatefulWidget{
//  @override
//  _NutritionPageState createState() => _NutritionPageState();
//}
//
//class _NutritionPageState extends State<NutritionPage>{
//
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      home: Scaffold(
//        body: RefreshIndicator(
//            child: GridView.count(crossAxisCount: 2, children: _buildList(),),
//            onRefresh: _refresh)
//      ),
//    );
//  }
//
//  Future<Null> _refresh() async{
//    await Future.delayed(Duration(seconds: 1));
//    setState(() {
//      Nutrition_Name = Nutrition_Name.reversed.toList();
//    });
//    return null;
//}
//
//  List<Widget> _buildList() {
//     return Nutrition_Name.map((nutrition) => _item(nutrition)).toList();
//  }
//
//  Widget _item(String nutrition){
//    return Container(
//      height: 80,
//      margin: EdgeInsets.all(5),
//      alignment: Alignment.center,
//      decoration: BoxDecoration(color: Colors.grey),
//      child: Text(nutrition, style: TextStyle(color: Colors.white, fontSize: 25),),
//    );
//  }
//}
