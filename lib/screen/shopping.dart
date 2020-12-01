import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:core';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibrate/vibrate.dart';
import 'shoplist_model.dart';

class ShopItemsPage extends StatefulWidget
{
  @override
  _ShopItemsPageState createState() => _ShopItemsPageState();
}

class _ShopItemsPageState extends State <ShopItemsPage> with SingleTickerProviderStateMixin
{
  bool isLoading = false;
  int total;
  String query;
  MediaQueryData queryData;
  int index;
  static DateTime now = DateTime.now();
  String todayDate =  DateFormat('EEEE').format(now);
  final today=now.subtract(new Duration(days: 0)); //yesterday
  final yesterday=now.subtract(new Duration(days: 1)); //yesterday
  final tomorrow=now.subtract(new Duration(days: -1)); //tomorrow
  List <String> userPref = [];
  String usernameStored;
  List <String> menuByDate = [];
  static String k;
  String MealDate;
  String shopUrl = 'https://ylr9w8c0q2.execute-api.us-east-1.amazonaws.com/v0/shoppinglist';
  bool _status = false;
  @override
  void initState(){
    super.initState();
    _getPref();
  }

  void _getPref() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getStringList('userCredentials'));
    if(prefs.containsKey('userCredentials') ){
      setState(() {
        userPref = prefs.getStringList('userCredentials');
        usernameStored = getUsername(userPref[userPref.length-1]);
      });
    }
  }

  String getUsername(String value) {
    int i = value.indexOf('@');
    return value.substring(0, i);
  }

  Future<List<shopModel>> getShopList(String query) async {
    //TODO
    if (query == "") {}
    final response = await http.get(shopUrl + '?' + query);
    print("response code: ${response.statusCode}");
    if (response.statusCode == 200) {
      var result = json.decode(response.body); //response data
      List results = result['Items'] as List;
      print("results : $results");
      List<shopModel> shops = results
          .map((model) => shopModel.fromJson(model['content']))
          .toList(); //map json to dart object
      //total = shops.length;
      total = shops[0].groceries.length;
      print("total items: $total");
      print(shops);
      return shops;
    } else {
      throw Exception('failed connect');
    }
  }

  makeShopList() async{ //call once
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getStringList('userCredentials'));
    Map map = new Map<String, dynamic>();
    map["owner"] = usernameStored;
    map["item"] = 'skim milk';
    map["time"] = '2/11/19';
    map["location"] = 'Coles';
    map["price"] = '5 dollars';
    map["image"] = 'https://spoonacular.com/recipeImages/asparagus-prosciutto-bundles-with-arugula-8694.jpg';
    print(map);
    if(prefs.containsKey('userCredentials') ) {
      setState(() {
        http.post("https://ylr9w8c0q2.execute-api.us-east-1.amazonaws.com/v0/generateshoppinglist",
            body: utf8.encode(json.encode(map)) )
            .then((http.Response response){
          final int statusCode = response.statusCode;
          print('make shopping list return code: $statusCode');
        });
      });
    }
  }

  Widget listViewWidget(List<shopModel> list, snapshot) {
    queryData = MediaQuery.of(context);
    return Column(
      children: <Widget>[
        Expanded(
            child: Container(
              color: Colors.grey[200],
              child: ListView.separated(
              separatorBuilder: (context, index) => Divider(
                    color: Colors.black,
                  ),
                  itemCount: total,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                        children: <Widget>[
                          //meals[index].time == '$mealDate'?
                          Container(
                            child: Column(
                              children: <Widget>[
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
                                                    Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: Container(
                                                            child:  Text('${index+1})  '
                                                                '${list[0].groceries[index].name}'
                                                                '    ',
                                                              style: TextStyle(
                                                                  fontSize: 26,
                                                                  color: Colors.black,
                                                                  fontWeight: FontWeight.bold,
                                                                  fontFamily: 'Title'),
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                            padding: new EdgeInsets.only(right: 13.0),
                                                            child: Text(    '${list[0].groceries[index].amount.round()}'
                                                                '${list[0].groceries[index].unit}  ', style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.bold,
                                                                fontFamily: 'Title'
                                                            ),
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:  EdgeInsets.only(left: queryData.size.width/10),
                                                      child: Row(
//                                                      mainAxisAlignment:
//                                                      MainAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                      crossAxisAlignment:
//                                                      CrossAxisAlignment.center,
                                                        children: <Widget>[
                                                          Text(''),
                                                          !list[0].groceries[index].isInInventory?
                                                          Text('Not in the fridge yet', style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.white,
                                                            backgroundColor: Colors.red
                                                          ),)
                                                              : Text('Already in the fridge', style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 16,
                                                              backgroundColor: Colors.green
                                                          )),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ]),
                                    ),
//                                  Align(
//                                    alignment: Alignment.bottomRight,
//                                    child: Padding(
//                                      padding: EdgeInsets.only(
//                                          top: queryData.size.height / 20),
//                                      child: SizedBox.fromSize(
//                                        size: Size.fromRadius(30),
//                                        child: Material(
//                                          elevation: 20.0,
//                                          shadowColor: Color(0x802196F3),
//                                          //color: Colors.grey[300],
//                                          color: Colors.transparent,
//                                          shape: RoundedRectangleBorder(),
//                                          child: Image.network(
//                                            '${list[index].image}',
//                                            height: 300,
//                                            width: 300,
//                                          ),
//                                        ),
//                                      ),
//                                    ),
//                                  ),
                                    ListTile(
                                      onTap: () {
                                        setState(() {
                                          _status = true;
                                          print('1111');
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                _status ? _getCheckBox()  : new Container(),
                              ],
                            ),
                          ),
//                          _status ? _getCheckBox()  : new Container(),
                        ],
                      );
                  }),
            )),
        //!_status ? _getCheckBox()  : new Container(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: new Text('Shopping List', style: TextStyle(
            fontWeight: FontWeight.w700
        ),),
        actions: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 25, top: 5),
                child: IconButton(icon: new Icon(Icons.update, size: 30,),
                    onPressed: () {
                      _status = !_status;
                      print(_status);
                     // _getCheckBox();
                }),
              ),
            ],
          )
        ],
      ),
      body: FutureBuilder(
            //future: _future,
            //future: getShopList("owner=$usernameStored"),
        future: getShopList("owner=HOTAALUOA"),

        builder: (context, snapshot) {
              print("returned data:");
              print(snapshot.data);
              return snapshot.data != null
                  ? listViewWidget(snapshot.data, snapshot)
                  : Center(child: CircularProgressIndicator());
                },
              )
    );
  }


  Widget _getCheckBox() {
    return Container(
      height: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Exercise(
            title: 'Bought',
          ),
        ],
      ),
    );
  }

}

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