import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:hotaal/dao/mealInfo_dao.dart';
import 'package:hotaal/model/mealInfo_model.dart';
import 'package:hotaal/provide/mealplan_provide.dart';
import 'package:provide/provide.dart';

const URL = 'https://api.spoonacular.com/recipes/';
const apiKey = '/information?includeNutrition=true&apiKey=53a56460fcf24acf82b91106279f8130';

class WebView extends StatefulWidget {
  final String url;
  final int id;
  final String title;
  final int readyInMinutes;
  final int servings;
  final bool backForbid;


  const WebView(
      {Key key,
        this.url,
        this.id,
        this.title,
        this.readyInMinutes,
        this.servings,
        this.backForbid})
      : super(key: key);

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  final webViewReference = FlutterWebviewPlugin();
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  StreamSubscription<WebViewHttpError> _onHttpError;
//  bool _isFavorited = false;
  List<String> choice = ['breakfast', 'lunch', 'dinner'];
  MealInfoModel mealInfoModel;
  final List<Tab> myTabs = <Tab>[
    new Tab(text: 'Ingredients'),
    new Tab(text: 'Nutrients'),
  ];
  String protein;
  String fiber = '0';
  String vitaminA = '0';
  String vitaminC = '0';

//  FocusNode focusNode = new FocusNode();
//  OverlayEntry overlayEntry;

  @override
  void initState() {
    super.initState();
    loadData();
    webViewReference.close();
    _onUrlChanged = webViewReference.onUrlChanged.listen((String url) {});
    _onStateChanged =
        webViewReference.onStateChanged.listen((WebViewStateChanged state) {
          switch (state.type) {
            case WebViewState.startLoad:
              break;
            default:
              break;
          }
        });
    _onHttpError =
        webViewReference.onHttpError.listen((WebViewHttpError error) {
          print(error);
        });
  }

  loadData() async {
    MealInfoDao.fetch(URL + widget.id.toString() + apiKey).then((MealInfoModel model) {
      setState(() {
        mealInfoModel = model;
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void dispose() {
    _onStateChanged.cancel();
    _onUrlChanged.cancel();
    _onHttpError.cancel();
    webViewReference.dispose();
    super.dispose();
  }

//  void _logFavorite() {
//    setState(() {
//      if (_isFavorited) {
//        _isFavorited = false;
//      } else {
//        _isFavorited = true;
//      }
//    });
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mealInfoModel != null ? _appBar :
      AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: EdgeInsets.only(left: 10),
            child: Icon(
              Icons.close,
              color: Colors.grey,
              size: 26,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.network(
              widget.url,
              height: 300,
              alignment: Alignment.center,
//              fit: BoxFit.fill,
            ),
            Container(
              margin: EdgeInsets.all(20),
              alignment: Alignment.centerLeft,
              child: Text(widget.title,
                  style: TextStyle(color: Colors.grey, fontSize: 30)),
            ),
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  alignment: Alignment.centerLeft,
                  child: Text('readyInMinutes: ' + widget.readyInMinutes.toString(),
                      style: TextStyle(color: Colors.grey, fontSize: 18)),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  alignment: Alignment.centerLeft,
                  child: Text('servings: ' + widget.servings.toString(),
                      style: TextStyle(color: Colors.grey, fontSize: 18)),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.all(20),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(width: 0.3, color: Colors.grey))
              ),
              child: Text('Nutrients',
                  style: TextStyle(color: Colors.grey, fontSize: 25, fontWeight: FontWeight.bold)),
            ),
            Container(
              height: 1000,
              child: ListView.builder(
                  itemCount: mealInfoModel?.nutrition?.nutrients?.length ?? 0, itemBuilder: (BuildContext context, int position) {
                return _item(position);
              }
              ),
            ),


//              Container(
//                width: 400,
//                height: 1000,
//                margin: EdgeInsets.only(top: 20),
//                child: new SafeArea(
//                  child: new DefaultTabController(
//                      length: myTabs.length,
//                      child: new Scaffold(
//                        appBar: new TabBar(
//                          labelColor: Colors.grey,
//                          labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                          indicatorColor: Colors.grey,
//                          indicatorWeight: 3.0,
//                          tabs: myTabs,
//                        ),
//                        body: new TabBarView(
//                          children: myTabs.map((Tab tab) {
//                            return new Center(child: new Text(tab.text));
//                          }).toList(),
//                        ),
//                      )),
//                ),
//              ),
          ],
        ),
      ),
    );
  }

//  @override
//  Widget build(BuildContext context) {
//    // TODO: implement build
//    return Scaffold(
//      body: Column(
//        children: <Widget>[
//          _appBar,
//          Image.network(
//              widget.url,
//              height: 300,
//              alignment: Alignment.center,
//              fit: BoxFit.fill,
//          ),
//          Container(
//            margin: EdgeInsets.all(20),
//            alignment: Alignment.center,
//            child: Text(widget.title, style: TextStyle(color: Colors.grey, fontSize: 20)),
//          ),
//          Container(
//            margin: EdgeInsets.all(20),
//            alignment: Alignment.center,
//            child: Text('readyInMinutes: ' + widget.readyInMinutes.toString(), style: TextStyle(color: Colors.grey, fontSize: 20)),
//          ),
//          Container(
//            margin: EdgeInsets.all(20),
//            alignment: Alignment.center,
//            child: Text('servings: ' + widget.servings.toString(), style: TextStyle(color: Colors.grey, fontSize: 20)),
//          ),
//        ],
//      ),
//    );
//  }

//  Widget get _appBar{
//    return Container(
//      padding: EdgeInsets.fromLTRB(0, 40, 0, 10),
//      child: FractionallySizedBox(
//        widthFactor: 1,
//        child: Stack(
//          children: <Widget>[
//            GestureDetector(
//              onTap: () {
//                Navigator.pop(context);
//              },
//              child: Container(
//                margin: EdgeInsets.only(left: 10),
//                child: Icon(
//                  Icons.close,
//                  color: Colors.grey,
//                  size: 26,
//                ),
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }

  Widget get _appBar {
    return AppBar(
      backgroundColor: Colors.white,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          margin: EdgeInsets.only(left: 10),
          child: Icon(
            Icons.close,
            color: Colors.grey,
            size: 26,
          ),
        ),
      ),
//      actions: <Widget>[
//        IconButton(
//          icon: Icon(_isFavorited ? Icons.favorite : Icons.favorite_border),
//          padding: EdgeInsets.only(right: 15),
//          iconSize: 35,
//          color: _isFavorited ? Colors.blue : Colors.grey,
//          onPressed: (){
//            _logFavorite();
//            if(_isFavorited) {
//              _saveId();
//            }
//          },
//        )
//      ],

//      actions: <Widget>[
//        IconButton(
//          icon: Icon(Icons.add),
//          padding: EdgeInsets.only(right: 15),
//          iconSize: 35,
//          color: Colors.blue,
//          onPressed: () async{
//              await Provide.value<MealPlanProvide>(context).save(widget.id.toString(), widget.title, widget.readyInMinutes.toString(), widget.servings.toString(), widget.url);
//          },
//        )
//      ],

//      actions: <Widget>[
//        IconButton(
//            icon: Icon(Icons.add),
//            padding: EdgeInsets.only(right: 15),
//            iconSize: 35,
//            color: Colors.grey,
//            onPressed: () {
//              OverlayEntry overlayEntry = new OverlayEntry(builder: (context) {
//                return new Positioned(
//                    top: kToolbarHeight,
//                    right: 0,
//                    width: 100,
//                    height: 200,
//                    child: new SafeArea(
//                        child: new Material(
//                      child: new Container(
//                        color: Colors.grey,
//                        child: new Column(
//                          children: <Widget>[
//                            Expanded(
//                              child: new ListTile(
//                                onTap: () {
//                                  setState(() {
//                                    focusNode.unfocus();
//                                  });
//                                },
//                                title: new Text(
//                                  "breakfast",
//                                  style: TextStyle(color: Colors.white),
//                                ),
//                              ),
//                            ),
//                            Expanded(
//                              child: new ListTile(
//                                onTap: () {
//                                  focusNode.unfocus();
//                                  setState(() {
//
//                                  });
//                                },
//                                title: new Text("lunch",
//                                    style: TextStyle(color: Colors.white)),
//                              ),
//                            ),
//                            Expanded(
//                              child: new ListTile(
//                                onTap: () {
//                                  focusNode.unfocus();
//                                },
//                                title: new Text("dinner",
//                                    style: TextStyle(color: Colors.white)),
//                              ),
//                            ),
//                          ],
//                        ),
//                      ),
//                    )));
//              });
//              Overlay.of(context).insert(overlayEntry);
//            })
//      ],


      actions: <Widget>[
        new PopupMenuButton(
          icon: Icon(Icons.add, color: Colors.grey, size: 32),
          padding: EdgeInsets.only(right: 15),
          onSelected: _select,
          itemBuilder: (BuildContext context){
            return choice.map((String choice){
              return new PopupMenuItem<String>(
                  value: choice,
                  child: new Text(choice, style: TextStyle(color: Colors.grey),));
            }).toList();
          },
        )
      ],


    );
  }

  _item(int position) {
    if (mealInfoModel == null || mealInfoModel.nutrition == null) return null;
    Nutrients nutrients = mealInfoModel.nutrition.nutrients[position];
    return Container(
      height: 50,
      margin: EdgeInsets.only(left: 20, top: 2, bottom: 2),
      child: Container(
        width: 350,
        child: Text(
          '${nutrients.title} : ${nutrients.amount} ${nutrients.unit}',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ),
    );
  }


  _select(String choice) async{
    for(var i = 4; i < mealInfoModel.nutrition.nutrients.length; i++){
      if(mealInfoModel.nutrition.nutrients[i].title == 'Protein'){
        protein = mealInfoModel.nutrition.nutrients[i].amount.toString();
      }
      if(mealInfoModel.nutrition.nutrients[i].title == 'Fiber'){
        fiber = mealInfoModel.nutrition.nutrients[i].amount.toString();
      }
      if(mealInfoModel.nutrition.nutrients[i].title == 'Vitamin C'){
        vitaminC = mealInfoModel.nutrition.nutrients[i].amount.toString();
      }
    }
    await Provide.value<MealPlanProvide>(context).save(widget.id.toString(), widget.title,
        widget.readyInMinutes.toString(), widget.servings.toString(), widget.url, choice,
        mealInfoModel.nutrition.nutrients[0].amount.toString(),
        mealInfoModel.nutrition.nutrients[1].amount.toString(),
        mealInfoModel.nutrition.nutrients[3].amount.toString(),
        protein, fiber, vitaminC
    );
  }

//  _saveId() async{
//    SharedPreferences sp = await SharedPreferences.getInstance();
//    sp.setInt('id', widget.id);
//    sp.setString('title', widget.title);
//    sp.setInt('readyInMinutes', widget.readyInMinutes);
//    sp.setString('url', widget.url);
//    sp.setInt('servings', widget.servings);
//  }
}
