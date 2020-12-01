import 'dart:convert';
import 'dart:core';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotaal/menu_rest.dart';
import 'package:hotaal/mealplan.dart';
import 'package:http/http.dart' as http;
//import 'package:overlay_support/overlay_support.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibrate/vibrate.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
class MealPage extends StatefulWidget {
  @override
  _MealPageState createState() => new _MealPageState();
}

class _MealPageState extends State<MealPage> with SingleTickerProviderStateMixin {
  bool isLoading = false;
  int total;
  List<MenuModel> datalist;
  String query;
  bool _status = true;
  MediaQueryData queryData;
  int index;
  Future<List<MenuModel>> _future;
  TabController _tabController;
  static DateTime now = DateTime.now();
  String todayDate =  DateFormat('EEEE').format(now);
  static final today=now.subtract(new Duration(days: 0)); //yesterday
  final yesterday=now.subtract(new Duration(days: 1)); //yesterday
  final tomorrow=now.subtract(new Duration(days: -1)); //tomorrow
  List <String> userPref = [];
  String usernameStored;
  List <String> menuByDate = [];
  static String k;
  String MealDate;
  int total1;
  List <String> mealPref = [];
  List<MenuModel> items1 = new List<MenuModel>();

  final List<Tab> myTabs = List.generate(
    30,
        (index) => Tab(
              child: Column(
                children: <Widget>[
                  DateFormat('yyyy-MM-dd').format(now.add(new Duration(days: index -11))) == DateFormat('yyyy-MM-dd').format(today) ?
                  Text('Today', style: TextStyle(
                      fontSize: 24,
                    color: Colors.red
                  )):
                  Text(DateFormat('E').format(now.add(new Duration(days: index-11))), style: TextStyle(
                      fontSize: 21
                  ),),
                  Text(DateFormat('dd/MM/yy').format(now.add(new Duration(days: index-11))), style: TextStyle(
                    fontSize: 11
                  ),)
                ],
              ),
            ),
  );

  final List<String> dates = List.generate(
    30,
        (index) =>  k = DateFormat('yyyy-MM-dd').format(now.add(new Duration(days: index-11)))
  );

  @override
  void initState() {
    _tabController = new TabController(length: myTabs.length, vsync: this, initialIndex: 5);
    super.initState();
    //fingerOverlay();
    //fingerOverlay1();
    print(dates.toList());
    initializeDateFormatting("en_AU", null);
    _getPref();
    print("today: $today");
    print('///////////////today: ${DateFormat('yyyy-MM-dd').format(today)}');
print(DateFormat('yyyy-MM-dd').format(now.add(new Duration(days: 0))));
    //makeShopList();
  }

  Future<List<MenuModel>> get(String query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //TODO
    if (query == "") {}
    final response = await http.get(hotaalURL + '?' + query);
    if (response.statusCode == 200) {
      print("connected");
      var result = json.decode(response.body); //response data
      List results = result['Items'] as List;
      print("results : ${results}");
      List<MenuModel> items = results
          .map((model) => MenuModel.fromJson(model['content']))
          .toList(); //map json to dart object
      //print("total items: ${items[0].meals}");
      total = items.length;
      items1 = items;
//      total1 = items[0].meals.length;
      print("total $total");
      for(int i=0; i<total; i++){
        print("first meal on each meal plan: ${items[i].meals[0].title}");
        if(DateFormat('yyyy-MM-dd').format(today) == items[i].notes.date){
            for(int j=0; j<items[i].meals.length; j++){
              print('??????????????????????${items[i].meals[j].title}');
              print('///////////////////');
              print(mealPref.getRange(0, mealPref.length));
//              if(prefs.getStringList('meal3').contains(items[i].meals[j].title)){
//                print('already here!!!!!!');
//              }else{
//                mealPref.add(items[i].meals[j].title);
//              }
              mealPref.add(items[i].meals[j].title);
              prefs.setStringList('meal3', mealPref);
            }
        }
      }
      return items;
    } else {
      throw Exception('failed connect');
    }
  }

  void getMealName() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    //pref.setStringList('mealPref', );
  }

  void _getPref() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getStringList('userCredentials'));
    if(prefs.containsKey('userCredentials') ){
      setState(() {
        userPref = prefs.getStringList('userCredentials');
        usernameStored = getUsername(userPref[userPref.length-1]);
      });
      print('username pref now is $userPref');
      print('usernameStored: $usernameStored');
    }
  }

  String getUsername(String value) {
    int i = value.indexOf('@');
    return value.substring(0, i);
  }

//  Widget checkbox(String title, bool boolValue) {
//    return Row(
//      mainAxisAlignment: MainAxisAlignment.center,
//      children: <Widget>[
//        Text(title),
//        Checkbox(
//          value: boolValue,
//          onChanged: (bool value) {
//            setState(() {
//              switch(title){
//                case "Finished":
//                  _value1 = value;
//                  print("finished");
//                  break;
//                case "Dislike":
//                  _value2 = value;
//                  print("disliked");
//                  break;
//              }
//            });
//          },
//        )
//      ],
//    );
//  }

  Widget listViewWidget(List<MenuModel> meals, String mealDate) {
    queryData = MediaQuery.of(context);
    return
      total == 0? Container(
        height: queryData.size.height*0.7,
      ):
      Column(
      children: <Widget>[
        Expanded(
            child: Container(
          color: Colors.grey[200],
          child: ListView.builder(
//              separatorBuilder: (context, index) => Divider(
//                    color: Colors.black,
//                  ),
              itemCount: total,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: <Widget>[
                    meals[index].notes.date == '$mealDate'?
                    //(DateTime.fromMicrosecondsSinceEpoch((double.parse(meals[0].notes.date)*1000).toInt())).toString().substring(0, 10) == '$mealDate'?
                    Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: queryData.size.height*0.8,
                            child: ListView.builder(
//                              itemCount: total1,
                            itemCount: items1[index].meals.length,
                              itemBuilder: (BuildContext context, int index1){
                                return Container(
                                  child: Column(
                                    children: <Widget>[
                                      ((index1 == 0) &&  mealDate !=null )?
                                      Padding(
                                        padding: EdgeInsets.only(left: 0),
                                        child: Material(
                                          elevation: 12.0,
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10.0),
                                            bottomLeft: Radius.circular(10.0),
                                            bottomRight: Radius.circular(10.0),
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                    colors: [Colors.white, Colors.grey],
                                                    end: Alignment.topLeft,
                                                    begin: Alignment.bottomRight)),
                                            child: Container(
                                              margin: EdgeInsets.symmetric(vertical: 1.0),
                                              child: ListTile(
                                                leading: CircleAvatar(
                                                  backgroundColor: Colors.purple,
                                                  child: Text('DL'),
                                                ),
                                                title: Text('Dr. Dong Liang ', style: TextStyle()),
                                                subtitle: Text('${meals[index].notes.message}',
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle()),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                          : new Container(),
                                      SizedBox(height: 10,),
                                      Stack(
                                        children: <Widget>[
                                          Container(
                                            child: Column(
                                                children: <Widget>[
                                                  Material(
                                                    elevation: 28.0,
                                                    borderRadius: BorderRadius.circular(28.0),
                                                    shadowColor: Colors.black,
                                                    color: Colors.grey[300],
                                                    child: Padding(
                                                      padding: EdgeInsets.all(10),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Text('${meals[index].meals[index1].title}',
                                                              style: TextStyle(
                                                                  fontSize: 25,
                                                                  color: Colors.black,
                                                                  fontWeight: FontWeight.bold,
                                                                  fontFamily: 'Title')),
                                                          Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment.start,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment.center,
                                                            children: <Widget>[
                                                              Text(
                                                                //'${meals[index].nutrients.toMap()}',
                                                                'Prepare in ${meals[index].meals[index1].readyInMinutes} mins ',
                                                                style: TextStyle(
                                                                    fontSize: 15,
                                                                    fontFamily: 'Title',
                                                                    color: Colors.black),
                                                              ),
                                                              Icon(Icons.timer,
                                                                  color: Colors.green, size: 24.0),
                                                              Text(
                                                                  '${meals[index].meals[index1].mealTime}', style: TextStyle(
                                                                color: Colors.red[900],
                                                                fontSize: 20
                                                              ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: queryData.size.height / 20),
                                              child: SizedBox.fromSize(
                                                size: Size.fromRadius(30),
                                                child: Material(
                                                  elevation: 20.0,
                                                  shadowColor: Color(0x802196F3),
                                                  //color: Colors.grey[300],
                                                  color: Colors.transparent,
                                                  shape: RoundedRectangleBorder(),
                                                  child: Image.network(
                                                    '${meals[index].meals[index1].imageUrls[0]}',
                                                    height: 300,
                                                    width: 300,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          ListTile(
                                            onTap: () {
                                              setState(() {
                                                _status = false;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
//                        !_status ? _getCheckBox()  : new Container(),
                                      !_status ? mealinfo(meals, index1) : new Container(),
                                      SizedBox(height: 10,)
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    )
                     : new Container(
                    ),
                    //emptyOverlay()

                  ],
                );
              }),
        )),
        //_status ? _getbuttons() : new Container(),
        //!_status ? _getActionButtons()  : new Container(),
      ],
    );
  }

//  void fingerOverlay() async {
//    await new Future.delayed(const Duration(seconds: 2));
//    showOverlay((context, t) {
//      return Opacity(
//        opacity: t,
//        child: overlay(),
//      );
//    });
//  }
//
//  void fingerOverlay1() async {
//    await new Future.delayed(const Duration(seconds: 2));
//    showOverlay((context, t) {
//      return Opacity(
//        opacity: t,
//        child: overlay1(),
//      );
//    });
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: new Text('Menu Lists ', style: TextStyle(
            fontWeight: FontWeight.w700
        ),),
        bottom: TabBar(
          indicatorColor: Colors.grey,
          isScrollable: true,
          onTap: (context){
            Vibrate.vibrate();
          } ,
          labelColor: index == 3?  Colors.white : Colors.red,
          unselectedLabelColor: Colors.grey,
          tabs: myTabs,
//          <Widget>[
//            new Tab(
//              child: Column(
//                children: <Widget>[
//                  Text(DateFormat('EEE d').format(yesterday)),
//                  Text('Yesterday', style: TextStyle(
//                    fontSize: 16
//                  ),),
//                ],
//              ),
//            ),
//            new Tab(
//              child: Column(
//                children: <Widget>[
//                  Text(DateFormat('EEE d').format(now)),
//                  Text('Today', style: TextStyle(
//                    fontSize: 20
//                  ),),
//                ],
//              ),
//            ),
//            new Tab(
//              child: Column(
//                children: <Widget>[
//                  Text(DateFormat('EEE d').format(tomorrow)),
//                  Text('Tomorrow', style: TextStyle(
//                    fontSize: 16
//                  ),),
//                ],
//              ),
//            ),
//          ],
          controller: _tabController,
        ),
      ),

//        actions: <Widget>[
//          Column(
//            children: <Widget>[
//              Padding(
//                padding: EdgeInsets.only(right: 25, top: 5),
//                child: IconButton(icon: new Icon(Icons.update, size: 30,),
//                    onPressed: () {
//                      print("icon ");
//                      _getCheckBox();
//                      fingerOverlay();
//                      fingerOverlay1();
//                }),
//              ),
//            ],
//          )
//        ],
      //backgroundColor: Colors.black,

      body: TabBarView(
        children: dates.map((String k){
          return FutureBuilder(
            //future: _future,
            //future: get("owner=$usernameStored"),
            future: get("owner=HOTAALUOA"),
            builder: (context, snapshot) {
              print("returned data:");
              print(snapshot.data);
              print('k= $k');
              return snapshot.data != null
                  ? listViewWidget(snapshot.data, k)
                  : Center(child: CircularProgressIndicator());
            },
          );
        }).toList(),
//        [
//          FutureBuilder(
//            //future: _future,
//            future: get("owner=$usernameStored"),
//            builder: (context, snapshot) {
//              print("returned data:");
//              print(snapshot.data);
//              return snapshot.data != null
//                  ? listViewWidget(snapshot.data, DateFormat('yyyy-MM-dd').format(yesterday))
//                  : Center(child: CircularProgressIndicator());
//            },
//          ),
//          FutureBuilder(
//            //future: _future,
//            future: get("owner=$usernameStored"),
//            builder: (context, snapshot) {
//              print("returned data:");
//              print(snapshot.data);
//              return snapshot.data != null
//                  ? listViewWidget(snapshot.data, DateFormat('yyyy-MM-dd').format(today))
//                  : Center(child: CircularProgressIndicator());
//            },
//          ),
//          FutureBuilder(
//            //future: _future,
//            future: get("owner=$usernameStored"),
//            builder: (context, snapshot) {
//
//              print("returned data:");
//              print(snapshot.data);
//              return snapshot.data != null
//                  ? listViewWidget(snapshot.data, DateFormat('yyyy-MM-dd').format(tomorrow))
//                  : Center(child: CircularProgressIndicator());
//            },
//          ),
//        ],
        controller: _tabController,
      ),
    );
  }

  Widget mealinfo(List<MenuModel> meals, int nb) {
    return Padding(
      padding: EdgeInsets.only(left: queryData.size.width / 20),
      child: Material(
        elevation: 12.0,
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.green, Colors.lightGreenAccent],
                  end: Alignment.topLeft,
                  begin: Alignment.bottomRight)),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 4.0),
            child: ListTile(
              title: Text(
                  'This food contains ${meals[nb].nutrients.calories} calories, '
                  '${meals[nb].nutrients.fat} fat, '
                  '${meals[nb].nutrients.carbohydrates} carbo, and '
                  '${meals[nb].nutrients.protein} protein ',
                  style: TextStyle()),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getCheckBox() {
    return Container(
      height: 120,
      child: Column(
        children: <Widget>[
          Exercise(
            title: 'Finished',
          ),
          Exercise(
            title: "Disliked",
          )
        ],
      ),
    );
  }

  Widget _getbuttons() {
    return Container(
        color: Colors.white70,
        width: queryData.size.width,
        child: new RaisedButton(
          child: Row(
            children: <Widget>[
              SizedBox(
                width: queryData.size.width / 10,
              ),
              Material(
                color: Colors.black,
                shape: CircleBorder(),
                child: Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Icon(
                    Icons.info_outline,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
              SizedBox(
                width: queryData.size.width / 10,
              ),
              new Text(
                "View Details",
                style: TextStyle(fontSize: 26, fontFamily: 'Title'),
              ),
            ],
          ),
          textColor: Colors.white,
          color: Colors.black,
          onPressed: () {
            setState(() {
              _status = false;
              FocusScope.of(context).requestFocus(new FocusNode());
            });
          },
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(20.0)),
        ));
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(right: queryData.size.width / 20),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: Row(
                  children: <Widget>[
                    Material(
                      color: Colors.green,
                      shape: CircleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Icon(
                          Icons.save_alt,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: queryData.size.width / 20,
                    ),
                    new Text(
                      "Save",
                      style: TextStyle(fontSize: 26),
                    ),
                  ],
                ),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: Row(
                  children: <Widget>[
                    Material(
                      color: Colors.red,
                      shape: CircleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Icon(
                          Icons.cancel,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: queryData.size.width / 20,
                    ),
                    new Text(
                      "Cancel",
                      style: TextStyle(fontSize: 26),
                    ),
                  ],
                ),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }
}

//checkbox class
class Exercise extends StatefulWidget {
  final String title;
  Exercise({this.title});

  @override
  _ExerciseState createState() => _ExerciseState();
}

class _ExerciseState extends State<Exercise> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title),
      trailing: Checkbox(
          value: selected,
          onChanged: (bool val) {
            setState(() {
              selected = val;
            });
          }),
    );
  }
}

class overlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.body1.copyWith(color: Colors.white),
        child: Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width / 1.3,
                top: MediaQuery.of(context).size.height / 12),
            child: Column(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: Colors.black87,
                    padding: EdgeInsets.symmetric(
                      vertical: 1,
                      horizontal: 2,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.arrow_upward,
                          color: Colors.white,
                        ),
                        Text(
                          'Finished your meal?',
                          style: TextStyle(fontSize: 15),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

class overlay1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.body1.copyWith(color: Colors.white),
        child: Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.1,
                top: MediaQuery.of(context).size.height * 0.83),
            child: Column(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: Colors.black45,
                    padding: EdgeInsets.symmetric(
                      vertical: 1,
                      horizontal: 2,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.arrow_downward,
                          color: Colors.white,
                        ),
                        Text(
                          'Wanna see more?',
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}


class emptyOverlay extends StatefulWidget {
  @override
  _emptyOverlayState createState() => _emptyOverlayState();
}

class _emptyOverlayState extends State<emptyOverlay> {

  @override
  void initState() {
    super.initState();
    show();
  }
  void show() {
    AwesomeDialog(
        context: context,
        animType: AnimType.BOTTOMSLIDE,
        dialogType: DialogType.ERROR,
        tittle: 'OOPS!',
        desc: 'You dont have any meal for this day',
        onDissmissCallback: () {
          debugPrint('Dialog Dissmiss from callback');
        }).show();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
