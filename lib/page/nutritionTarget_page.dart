import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// caregiver
class NutritionTargetPage extends StatefulWidget {
  @override
  _NutritionTargetPageState createState() => _NutritionTargetPageState();
}

class _NutritionTargetPageState extends State<NutritionTargetPage> {
  TextEditingController _calories = TextEditingController();
  TextEditingController _fat = TextEditingController();
  TextEditingController _carbs = TextEditingController();
  TextEditingController _protein = TextEditingController();
  TextEditingController _fiber = TextEditingController();
  TextEditingController _vitaminC = TextEditingController();
  double targetCalories = 600.0;
  double targetCarbs = 100.0;
  double targetFat = 50.0;
  double targetProtein = 100.0;
  double targetFiber = 100;
  double targetVitaminC = 100;


  @override
  void initState() {
    super.initState();
    _getTarget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.grey,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('nutrition target', style: TextStyle(color: Colors.grey)),
      ),
      body: SingleChildScrollView(
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 20, bottom: 10),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 50),
                    child: Text('Calories Target:',
                        style: TextStyle(fontSize: 20, color: Colors.grey)),
                  ),
                  Expanded(
                      child: TextField(
                        controller: _calories,
                        decoration: InputDecoration(
                          hintText: '   ' + targetCalories.toString(),
                        ),
                      )),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 50),
                    child: Text('cal',
                        style: TextStyle(fontSize: 20, color: Colors.grey)),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 50),
                    child: Text('Fat Target:',
                        style: TextStyle(fontSize: 20, color: Colors.grey)),
                  ),
                  Expanded(
                      child: TextField(
                        controller: _fat,
                        decoration: InputDecoration(
                          hintText: '   ' + targetFat.toString(),
                        ),
                      )),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 50),
                    child: Text('g',
                        style: TextStyle(fontSize: 20, color: Colors.grey)),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 50),
                    child: Text('Carbs Target:',
                        style: TextStyle(fontSize: 20, color: Colors.grey)),
                  ),
                  Expanded(
                      child: TextField(
                        controller: _carbs,
                        decoration: InputDecoration(
                          hintText: '   ' + targetCarbs.toString(),
                        ),
                      )),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 50),
                    child: Text('g',
                        style: TextStyle(fontSize: 20, color: Colors.grey)),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 50),
                    child: Text('Protein Target: ',
                        style: TextStyle(fontSize: 20, color: Colors.grey)),
                  ),
                  Expanded(
                      child: TextField(
                        controller: _protein,
                        decoration: InputDecoration(
                          hintText: '   ' + targetProtein.toString(),
                        ),
                      )),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 50),
                    child: Text('g',
                        style: TextStyle(fontSize: 20, color: Colors.grey)),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 50),
                    child: Text('Fiber Target: ',
                        style: TextStyle(fontSize: 20, color: Colors.grey)),
                  ),
                  Expanded(
                      child: TextField(
                        controller: _fiber,
                        decoration: InputDecoration(
                          hintText: '   ' + targetFiber.toString(),
                        ),
                      )
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 50),
                    child: Text('g',
                        style: TextStyle(fontSize: 20, color: Colors.grey)),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 50),
                    child: Text('Vitamin C Target: ',
                        style: TextStyle(fontSize: 20, color: Colors.grey)),
                  ),
                  Expanded(
                      child: TextField(
                        controller: _vitaminC,
                        decoration: InputDecoration(
                          hintText: '   ' + targetVitaminC.toString(),
                        ),
                      )),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 50),
                    child: Text('mg',
                        style: TextStyle(fontSize: 20, color: Colors.grey)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _setTarget();
        },
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey,
        label: new Text('apply', maxLines: 1),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  _setTarget() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if(_calories.text != "")
      sp.setDouble('targetCalories', double.parse(_calories.text));
    if(_fat.text != "")
      sp.setDouble('targetFat', double.parse(_fat.text));
    if(_carbs.text != "")
      sp.setDouble('targetCarbs', double.parse(_carbs.text));
    if(_protein.text != "")
      sp.setDouble('targetProtein', double.parse(_protein.text));
    if(_fiber.text != "")
      sp.setDouble('targetFiber', double.parse(_fiber.text));
    if(_vitaminC.text != "")
      sp.setDouble('targetVitminC', double.parse(_vitaminC.text));
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
    setState(() {

    });
  }
}
