import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hotaal/dao/menu_dao.dart';
import 'package:hotaal/model/menu_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// caregiver
class FMNutrientPage extends StatefulWidget {
  @override
  _FMNutrientPageState createState() => _FMNutrientPageState();
}

class _FMNutrientPageState extends State<FMNutrientPage> {
  List<MenuModel> menuModelList;
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  static DateTime today = DateTime.now();
  DateTime index0 = today.subtract(new Duration(days: 6));
  DateTime index1 = today.subtract(new Duration(days: 5));
  DateTime index2 = today.subtract(new Duration(days: 4));
  DateTime index3 = today.subtract(new Duration(days: 3));
  DateTime index4 = today.subtract(new Duration(days: 2));
  DateTime index5 = today.subtract(new Duration(days: 1));
  String owner;
  String username = 'HOTAALUOA';

  String url =
      'https://ylr9w8c0q2.execute-api.us-east-1.amazonaws.com/v0/mealplan?owner=';

  @override
  void initState() {
    super.initState();
    _patientName();
  }

  Future<List<MenuModel>> loadData() async {
    MenuDao.get(url + 'HOTAALUOA').then((List<MenuModel> model) {
      if(mounted){
        setState(() {
          menuModelList = model;
        });
      }
    });
    return menuModelList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: loadData(),
          builder: (context, snapshot) {
            if (snapshot.hasData && menuModelList != null) {
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 1.70,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(18),
                            ),
                            color: Colors.grey),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 18.0, left: 12.0, top: 24, bottom: 12),
                          child: FlChart(
                            chart: LineChart(
                              caloriesChartData(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10, bottom: 30),
                      child: Text(
                        'Calories weekly intake',
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    AspectRatio(
                      aspectRatio: 1.70,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(18),
                            ),
                            color: Colors.grey),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 18.0, left: 12.0, top: 24, bottom: 12),
                          child: FlChart(
                            chart: LineChart(
                              carbsChartData(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10, bottom: 30),
                      child: Text(
                        'Carbs weekly intake',
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    AspectRatio(
                      aspectRatio: 1.70,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(18),
                            ),
                            color: Colors.grey),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 18.0, left: 12.0, top: 24, bottom: 12),
                          child: FlChart(
                            chart: LineChart(
                              proteinChartData(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10, bottom: 30),
                      child: Text(
                        'Protein weekly intake',
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  LineChartData caloriesChartData() {
    return LineChartData(
      gridData: FlGridData(
        show: false,
        drawVerticalGrid: true,
        getDrawingHorizontalGridLine: (value) {
          return const FlLine(
            color: Colors.white,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalGridLine: (value) {
          return const FlLine(
            color: Colors.white,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '${getWeek(index0)}';
              case 1:
                return '${getWeek(index1)}';
              case 2:
                return '${getWeek(index2)}';
              case 3:
                return '${getWeek(index3)}';
              case 4:
                return '${getWeek(index4)}';
              case 5:
                return '${getWeek(index5)}';
              case 6:
                return '${getWeek(today)}';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1000:
                return '1kcal';
              case 2000:
                return '2kcal';
              case 3000:
                return '3kcal';
              case 4000:
                return '4kcal';
              case 5000:
                return '5kcal';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true, border: Border.all(color: Colors.white, width: 1)),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: 5000,
      lineBarsData: _caloriesData(),
    );
  }

  List<LineChartBarData> _caloriesData() {
    return [
      LineChartBarData(
        spots: [
          FlSpot(0, getCaloriesTarget(index0)),
          FlSpot(1, getCaloriesTarget(index1)),
          FlSpot(2, getCaloriesTarget(index2)),
          FlSpot(3, getCaloriesTarget(index3)),
          FlSpot(4, getCaloriesTarget(index4)),
          FlSpot(5, getCaloriesTarget(index5)),
          FlSpot(6, getCaloriesTarget(today)),
        ],
        isCurved: true,
        colors: [Colors.yellow],
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: const FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: false,
        ),
      ),
      LineChartBarData(
        spots: [
          FlSpot(0, getCalories(index0)),
          FlSpot(1, getCalories(index1)),
          FlSpot(2, getCalories(index2)),
          FlSpot(3, getCalories(index3)),
          FlSpot(4, getCalories(index4)),
          FlSpot(5, getCalories(index5)),
          FlSpot(6, getCalories(today)),
        ],
        isCurved: true,
        colors: gradientColors,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: const FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: true,
          colors:
          gradientColors.map((color) => color.withOpacity(0.1)).toList(),
        ),
      ),
    ];
  }

  LineChartData carbsChartData() {
    return LineChartData(
      gridData: FlGridData(
        show: false,
        drawVerticalGrid: true,
        getDrawingHorizontalGridLine: (value) {
          return const FlLine(
            color: Colors.white,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalGridLine: (value) {
          return const FlLine(
            color: Colors.white,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '${getWeek(index0)}';
              case 1:
                return '${getWeek(index1)}';
              case 2:
                return '${getWeek(index2)}';
              case 3:
                return '${getWeek(index3)}';
              case 4:
                return '${getWeek(index4)}';
              case 5:
                return '${getWeek(index5)}';
              case 6:
                return '${getWeek(today)}';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 100:
                return '100g';
              case 200:
                return '200g';
              case 300:
                return '300g';
              case 400:
                return '400g';
              case 500:
                return '500g';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true, border: Border.all(color: Colors.white, width: 1)),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: 500,
      lineBarsData: _carbsData(),
    );
  }

  List<LineChartBarData> _carbsData() {
    return [
      LineChartBarData(
        spots: [
          FlSpot(0, getCarbsTarget(index0)),
          FlSpot(1, getCarbsTarget(index1)),
          FlSpot(2, getCarbsTarget(index2)),
          FlSpot(3, getCarbsTarget(index3)),
          FlSpot(4, getCarbsTarget(index4)),
          FlSpot(5, getCarbsTarget(index5)),
          FlSpot(6, getCarbsTarget(today)),
        ],
        isCurved: true,
        colors: [Colors.yellow],
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: const FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: false,
        ),
      ),
      LineChartBarData(
        spots: [
          FlSpot(0, getCarbs(index0)),
          FlSpot(1, getCarbs(index1)),
          FlSpot(2, getCarbs(index2)),
          FlSpot(3, getCarbs(index3)),
          FlSpot(4, getCarbs(index4)),
          FlSpot(5, getCarbs(index5)),
          FlSpot(6, getCarbs(today)),
        ],
        isCurved: true,
        colors: gradientColors,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: const FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: true,
          colors:
          gradientColors.map((color) => color.withOpacity(0.1)).toList(),
        ),
      ),
    ];
  }

  LineChartData proteinChartData() {
    return LineChartData(
      gridData: FlGridData(
        show: false,
        drawVerticalGrid: true,
        getDrawingHorizontalGridLine: (value) {
          return const FlLine(
            color: Colors.white,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalGridLine: (value) {
          return const FlLine(
            color: Colors.white,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '${getWeek(index0)}';
              case 1:
                return '${getWeek(index1)}';
              case 2:
                return '${getWeek(index2)}';
              case 3:
                return '${getWeek(index3)}';
              case 4:
                return '${getWeek(index4)}';
              case 5:
                return '${getWeek(index5)}';
              case 6:
                return '${getWeek(today)}';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 100:
                return '100g';
              case 200:
                return '200g';
              case 300:
                return '300g';
              case 400:
                return '400g';
              case 500:
                return '500g';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true, border: Border.all(color: Colors.white, width: 1)),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: 500,
      lineBarsData: _proteinData(),
    );
  }

  List<LineChartBarData> _proteinData() {
    return [
      LineChartBarData(
        spots: [
          FlSpot(0, getProteinTarget(index0)),
          FlSpot(1, getProteinTarget(index1)),
          FlSpot(2, getProteinTarget(index2)),
          FlSpot(3, getProteinTarget(index3)),
          FlSpot(4, getProteinTarget(index4)),
          FlSpot(5, getProteinTarget(index5)),
          FlSpot(6, getProteinTarget(today)),
        ],
        isCurved: true,
        colors: [Colors.yellow],
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: const FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: false,
        ),
      ),
      LineChartBarData(
        spots: [
          FlSpot(0, getProtein(index0)),
          FlSpot(1, getProtein(index1)),
          FlSpot(2, getProtein(index2)),
          FlSpot(3, getProtein(index3)),
          FlSpot(4, getProtein(index4)),
          FlSpot(5, getProtein(index5)),
          FlSpot(6, getProtein(today)),
        ],
        isCurved: true,
        colors: gradientColors,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: const FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: true,
          colors:
          gradientColors.map((color) => color.withOpacity(0.1)).toList(),
        ),
      ),
    ];
  }

  static String getWeek(DateTime date) {
    var week = date.weekday;
    String w = '';
    switch (week.toString()) {
      case '1':
        w = 'Mon';
        break;
      case '2':
        w = 'Tue';
        break;
      case '3':
        w = 'Wed';
        break;
      case '4':
        w = 'Thu';
        break;
      case '5':
        w = 'Fri';
        break;
      case '6':
        w = 'Sat';
        break;
      case '7':
        w = 'Sun';
        break;
    }
    return w;
  }

  double getCalories(DateTime date) {
    if (menuModelList == null) return 0;
    double value = 0;
    for (var i = 0; i < menuModelList.length; i++) {
      if (menuModelList[i].notes.date.toString().substring(0, 10) == date.toString().substring(0, 10)) {
        value += menuModelList[i].nutrients.calories;
      }
    }
    return value;
  }

  double getCaloriesTarget(DateTime date) {
    if (menuModelList == null) return 0;
    double value = 0;
    for (var i = 0; i < menuModelList.length; i++) {
      if (menuModelList[i].notes.date.toString().substring(0, 10) == date.toString().substring(0, 10)) {
        value += menuModelList[i].nutrients.caloriesTarget;
      }
    }
    return value;
  }

  double getCarbs(DateTime date) {
    if (menuModelList == null) return 0;
    double value = 0;
    for (var i = 0; i < menuModelList.length; i++) {
      if (menuModelList[i].notes.date.toString().substring(0, 10) == date.toString().substring(0, 10)) {
        value += menuModelList[i].nutrients.carbohydrates;
      }
    }
    return value;
  }

  double getCarbsTarget(DateTime date) {
    if (menuModelList == null) return 0;
    double value = 0;
    for (var i = 0; i < menuModelList.length; i++) {
      if (menuModelList[i].notes.date.toString().substring(0, 10) == date.toString().substring(0, 10)) {
        value += menuModelList[i].nutrients.carbohydratesTarget;
      }
    }
    return value;
  }

  double getProtein(DateTime date) {
    if (menuModelList == null) return 0;
    double value = 0;
    for (var i = 0; i < menuModelList.length; i++) {
      if (menuModelList[i].notes.date.toString().substring(0, 10) == date.toString().substring(0, 10)) {
        value += menuModelList[i].nutrients.protein;
      }
    }
    return value;
  }

  double getProteinTarget(DateTime date) {
    if (menuModelList == null) return 0;
    double value = 0;
    for (var i = 0; i < menuModelList.length; i++) {
      if (menuModelList[i].notes.date.toString().substring(0, 10) == date.toString().substring(0, 10)) {
        value += menuModelList[i].nutrients.proteinTarget;
      }
    }
    return value;
  }

  _patientName() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    username = sp.getString('patientForfm');
//    if (username == null) username = 'HOTAALUOA';
//    int length = username.length;
//    int endIndex;
//    for (var i = 0; i < length; i++) {
//      if (username[i] == '@') {
//        endIndex = i;
//        break;
//      }
//    }
//    owner = username.substring(0, endIndex);
  }
}
