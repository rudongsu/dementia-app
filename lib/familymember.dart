import 'package:flutter/material.dart';
import 'package:hotaal/page/fm_activityLog_page.dart';
import 'package:hotaal/page/fm_alert_page.dart';
import 'package:hotaal/page/fm_nutrientIntake_page.dart';
import 'package:hotaal/page/fm_patient_page.dart';

/// caregiver
class FamilyMember extends StatefulWidget {
  @override
  _FamilyMemberState createState() => _FamilyMemberState();
}

class _FamilyMemberState extends State<FamilyMember> {
  final _defaultColor = Colors.grey;
  final _activeColor = Colors.blue;
  int _currentIndex = 0;
  final PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: new Drawer(
        child: buildDrawer(context),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.face, color: Colors.grey, size: 35,),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
        title: Text(
          '   HOTAAL',
          style:
              TextStyle(color: Colors.blue, fontFamily: 'title', fontSize: 50),
        ),
      ),
      body: PageView(
        controller: _controller,
        onPageChanged: _pageChange,
        children: <Widget>[
          FMActivityPage(),
          FMNutrientPage(),
          FMAlertPage(),
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
                  Icons.local_activity,
                  color: _defaultColor,
                ),
                activeIcon: Icon(
                  Icons.local_activity,
                  color: _activeColor,
                ),
                title: Text(
                  'activity log',
                  style: TextStyle(
                      color: _currentIndex != 0 ? _defaultColor : _activeColor),
                )),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.local_drink,
                  color: _defaultColor,
                ),
                activeIcon: Icon(
                  Icons.local_drink,
                  color: _activeColor,
                ),
                title: Text(
                  'nutrient intake',
                  style: TextStyle(
                      color: _currentIndex != 1 ? _defaultColor : _activeColor),
                )),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.notifications,
                  color: _defaultColor,
                ),
                activeIcon: Icon(
                  Icons.notifications,
                  color: _activeColor,
                ),
                title: Text(
                  'alert',
                  style: TextStyle(
                      color: _currentIndex != 2 ? _defaultColor : _activeColor),
                )),
          ]),
    );
  }

  void _pageChange(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget buildDrawer(BuildContext context) {
    return new ListView(
      children: <Widget>[
        _buildDrawerHeader(),
        _buildDrawerBody(),
      ],
    );
  }

  Widget _buildDrawerHeader() {
    return new DrawerHeader(
      child: new Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Container(
              width: 100.0,
              height: 100.0,
              margin: const EdgeInsets.all(10.0),
              decoration: new BoxDecoration(
                color: Colors.white,
                image: new DecorationImage(
                    image: new AssetImage('images/Profile.png'),
                    fit: BoxFit.cover),
                shape: BoxShape.circle,
              ),
            ),
            new Container(
              height: 200,
              margin: const EdgeInsets.only(top: 40.0, left: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new Text("Dongliang",
                        style: TextStyle(color: Colors.grey, fontSize: 25),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerBody() {
    return new Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 20, top: 2, bottom: 2),
          decoration: BoxDecoration(
              border:
              Border(bottom: BorderSide(width: 0.1, color: Colors.grey))
          ),
          child: ListTile(
            title: Text("Profile",
              style: TextStyle(color: Colors.grey, fontSize: 25),
            ),
            trailing: Icon(Icons.arrow_forward, color: Colors.grey,),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20, top: 2, bottom: 2),
          decoration: BoxDecoration(
              border:
              Border(bottom: BorderSide(width: 0.1, color: Colors.grey))
          ),
          child: ListTile(
            title: Text("Patient",
              style: TextStyle(color: Colors.grey, fontSize: 25),
            ),
            trailing: Icon(Icons.arrow_forward, color: Colors.grey,),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => FMPatientPage()));
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20, top: 2, bottom: 2),
          decoration: BoxDecoration(
              border:
              Border(bottom: BorderSide(width: 0.1, color: Colors.grey))
          ),
          child: ListTile(
            title: Text("feedback",
              style: TextStyle(color: Colors.grey, fontSize: 25),
            ),
            trailing: Icon(Icons.arrow_forward, color: Colors.grey),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }
}
