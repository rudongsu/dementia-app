import 'package:flutter/material.dart';
import 'package:hotaal/page/alert_page.dart';
import 'package:hotaal/page/mealplan_page.dart';
import 'package:hotaal/page/nutrition_page.dart';
import 'package:hotaal/page/search_page.dart';
import 'package:hotaal/page/setting_page.dart';
import 'package:badges/badges.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// caregiver
class Caregiver extends StatefulWidget {
  @override
  _CaregiverState createState() => _CaregiverState();
}

class _CaregiverState extends State<Caregiver> {
  final _defaultColor = Colors.grey;
  final _activeColor = Colors.blue;

  String numAlert = '';

  int _currentIndex = 0;
  final PageController _controller = PageController(
    initialPage: 0,
  );
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'HOTAAL',
          style:
              TextStyle(color: Colors.blue, fontFamily: 'title', fontSize: 50),
        ),
        actions: <Widget>[
            IconButton(
                icon: Icon(Icons.warning),
                padding: EdgeInsets.only(right: 15),
                iconSize: 35,
                color: Colors.grey,
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (BuildContext context) => AlertPage()
                  ));
                })
        ],
      ),
      body: PageView(
        controller: _controller,
        onPageChanged: _pageChange,
        children: <Widget>[
          MealPlanPage(),
          NutritionPage(),
          SearchPage(),
          SettingPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            _controller.jumpToPage(index);
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.restaurant_menu,
                  color: _defaultColor,
                ),
                activeIcon: Icon(
                  Icons.restaurant_menu,
                  color: _activeColor,
                ),
                title: Text(
                  'menu',
                  style: TextStyle(
                      color: _currentIndex != 0 ? _defaultColor : _activeColor),
                )),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.fastfood,
                  color: _defaultColor,
                ),
                activeIcon: Icon(
                  Icons.fastfood,
                  color: _activeColor,
                ),
                title: Text(
                  'nutrition',
                  style: TextStyle(
                      color: _currentIndex != 1 ? _defaultColor : _activeColor),
                )),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                  color: _defaultColor,
                ),
                activeIcon: Icon(
                  Icons.search,
                  color: _activeColor,
                ),
                title: Text(
                  'search',
                  style: TextStyle(
                      color: _currentIndex != 2 ? _defaultColor : _activeColor),
                )),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                  color: _defaultColor,
                ),
                activeIcon: Icon(
                  Icons.settings,
                  color: _activeColor,
                ),
                title: Text(
                  'setting',
                  style: TextStyle(
                      color: _currentIndex != 3 ? _defaultColor : _activeColor),
                ))
          ]),
    );
  }


  void _pageChange(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
