import 'package:hotaal/screen/barcode.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../mealplan.dart';
import '../menu_rest.dart';
import 'package:flutter/services.dart';
import 'package:vibrate/vibrate.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'notification.dart';
import 'meal.dart';
import 'shopping.dart';
import 'camera.dart';
import 'profile.dart';
import 'login.dart';
import 'package:dio/dio.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hotaal/notification_model.dart';
import 'alert.dart';
import 'package:hotaal/noti_rest.dart';
import 'splash_screen.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'ask.dart';
import 'package:hotaal/screen/shopping.dart';
import 'package:ping_discover_network/ping_discover_network.dart';

// dashboard for dementia to use Voice recognition

class patient extends StatelessWidget {
  final String usr;
  final String pass;

  patient(this.usr, this.pass);

  //patient({Key key, @required this.pass}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: new Dementia(usr, pass),
    );
  }
}

class Dementia extends StatefulWidget {
  final String usr;
  final String pass;

  Dementia(this.usr, this.pass);

  @override
  _VoiceRecState createState() => new _VoiceRecState(usr, pass);
}

class _VoiceRecState extends State<Dementia> {
  String username;
  String password;
  MediaQueryData queryData;

  _VoiceRecState(String username, String password) {
    this.username = username;
    this.password = password;
  }

  SpeechRecognition _speechRecognition; //define spe reg object
  bool isAva = false; //if app is able to interact with OS
  bool isListening = false; //if app is listen to microphone
  String output_text = ""; // converted text from voice input
  String warn_text = "meal plan ? ";
  Future<String> _qrcode; //qr code reader
  int dropdownValue;
  StreamController<int> _countControl = StreamController<int>();
  int mealCount = 0;
  int notiCount = 0;

  String ipAdd;
  void initState() {
    super.initState();
    initSpeechRec();
    String currentUser = getUsername(username);
    print('currentuser : $currentUser');
    getMealNumber('HOTAALUOA');
    //getNotificationNumber(username);
  }

  Future<int> getMealNumber(String query) async {
    //TODO
    List<MenuModel> results = await MenuDao.get(query);
    mealCount = results.length;
    print('mealCount: $mealCount');
    _countControl.sink.add(mealCount);
    return mealCount;
  }

  Future<int> getNotificationNumber(String query) async {
    //TODO
    List<Notifications> results = await noti.get(query);
    notiCount = results.length;
    print('mealCount: $notiCount');
    _countControl.sink.add(notiCount);
    return notiCount;
  }


  void overl(BuildContext context) async {
    OverlayState overlayState = Overlay.of(context);
    OverlayEntry overlayEntry =
        new OverlayEntry(builder: (BuildContext context) {
      return Positioned(
        top: 150.0,
        left: 150.0,
        child: new Material(
          color: Colors.white,
          child: new Icon(Icons.warning, color: Colors.white),
        ),
      );
    });
    overlayState.insert(overlayEntry);
    await new Future.delayed(const Duration(seconds: 5));
    overlayEntry.remove();
  }

//  getAlert() async{
//    http.get(notifUrl+'?'+username).then((http.Response response){
//      final responseCode = response.statusCode;
//      print("get alert response code: $responseCode");
//      var result = json.decode(response.body); //response data
//      List results = result['Items'] as List;
//      print("notif results : ${results[0]}");
//      return results;
//    });
//  }

  void initSpeechRec() {
    _speechRecognition = SpeechRecognition();
    _speechRecognition.setAvailabilityHandler(
      (bool result) => setState(() => isAva = result),
    ); //call back

    _speechRecognition.setRecognitionStartedHandler(
      () => setState(() => isListening = true),
    ); // call back

    _speechRecognition.setRecognitionResultHandler(
      (String speech) => setState(
        () => output_text = speech,
      ),
    ); // call back

    _speechRecognition.setRecognitionCompleteHandler(
      () => setState(() => isListening = false),
    ); // call back

    _speechRecognition.activate().then(
          (result) => setState(() => isAva = result),
        );
  }

  void recordingPopup(BuildContext context) {
    var popup = AlertDialog(content: Text(output_text));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return popup;
        });
  }

  bool buttonClicked = false;

  String getUsername(String value) {
    int i = value.indexOf('@');
    return value.substring(0, i);
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new Ask()));
                      });
                    },
                    child: Container(
                      color: Colors.black26,
                      child: Column(
                        children: <Widget>[
                          Text(
                            'My carers',
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Title'),
                          ),
                          Icon(
                            Icons.arrow_downward,
                            color: Colors.lightBlue,
                            size: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: queryData.size.width / 15),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Text(
                              getUsername(username),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: queryData.size.width / 10),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Icon(
                              Icons.call,
                              color: Colors.lightGreen,
                            ),
                            new Text(
                              '123-456-789',
                              style: TextStyle(
                                  color: Colors.lightBlueAccent, fontSize: 12),
                            )
                          ],
                        ),
                        Text(
                          'Call assistance',
                          style: TextStyle(
                              fontSize: 12, color: Colors.lightBlueAccent),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: queryData.size.height * 0.88,
              width: queryData.size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      width: queryData.size.width / 2.5,
                      height: queryData.size.height / 5,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.red[400]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.mic,
                            size: queryData.size.height / 2.2 / 4,
                            color: Colors.white,
                          ),
                          Text(
                            "Press to talk",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontFamily: 'Title',
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      Vibrate.vibrate();

                      setState(() {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => newDialog()));
                      });
                    },
                  ), //

                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: queryData.size.width / 30,
                      ),
                      GestureDetector(
                        child: Container(
                          width: queryData.size.width / 1.2,
                          decoration: BoxDecoration(
                              color: Colors.grey[850],
                              borderRadius: BorderRadius.circular(30)),
                          child: Row(
                            children: <Widget>[
                              StreamBuilder(
                                initialData: 0,
                                stream: _countControl.stream,
                                builder: (_, snapshot) => BadgeIcon(
                                  icon: Material(
                                      color: Colors.blue,
                                      shape: CircleBorder(),
                                      child: Padding(
                                        padding: const EdgeInsets.all(7.0),
                                        child: Icon(Icons.fastfood,
                                            color: Colors.white, size: 35),
                                      )),
                                  badgeCount: snapshot.data,
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'View meals',
                                style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white70,
                                    fontFamily: 'Title'),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: queryData.size.width / 5.5),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey[600],
                                  size: 35,
                                ),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          Vibrate.vibrate();
                          setState(() {
                            print("meal clicked");
                            HapticFeedback.vibrate();
                            //Navigator.pushNamed(context, '/meal');
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new MealPage()));
                          });
                        },
                      ),
                      SizedBox(
                        height: queryData.size.height / 30,
                      ),
                      GestureDetector(
                          child: Container(
                            width: queryData.size.width / 1.2,
                            //padding: EdgeInsets.only( right: data.size.width/3, left: data.size.width/3),
                            decoration: BoxDecoration(
                                color: Colors.grey[850],
                                borderRadius: BorderRadius.circular(30)),
                            child: Column(children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Material(
                                          color: Colors.orange,
                                          shape: CircleBorder(),
                                          child: Padding(
                                            padding: const EdgeInsets.all(7.0),
                                            child: Icon(
                                              Icons.add_photo_alternate,
                                              color: Colors.white,
                                              size: 35,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Text(
                                            'Record meals',
                                            style: TextStyle(
                                                fontSize: 26,
                                                color: Colors.white70,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Title'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: queryData.size.width / 8.5),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.grey[600],
                                      size: 35,
                                    ),
                                  )
                                ],
                              ),
                            ]),
                          ),
                          onTap: () {
                            setState(() {
                              print("upload images clicked");
                              //Navigator.pushNamed(context, '/camera');
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) =>
                                          new cameraScreen()));
                            });
                          }),
                      SizedBox(
                        height: queryData.size.height / 30,
                      ),
                      GestureDetector(
                          child: Container(
                            width: queryData.size.width / 1.2,
                            //padding: EdgeInsets.only( right: data.size.width/3, left: data.size.width/3),
                            decoration: BoxDecoration(
                                color: Colors.grey[850],
                                borderRadius: BorderRadius.circular(30)),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  child: Row(children: <Widget>[
                                    Material(
                                        color: Colors.green,
                                        shape: CircleBorder(),
                                        child: Padding(
                                          padding: const EdgeInsets.all(7.0),
                                          child: Icon(
                                            Icons.add_shopping_cart,
                                            color: Colors.white,
                                            size: 35,
                                          ),
                                        )),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      'Shopping',
                                      style: TextStyle(
                                          fontSize: 26,
                                          color: Colors.white70,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Title'),
                                    ),
                                  ]),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: queryData.size.width / 4.5),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.grey[600],
                                    size: 35,
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            Vibrate.vibrate();
                            setState(() {
                              buttonClicked = true;
                              print("Shopping clicked");
                              //Navigator.pushNamed(context, '/shopping');
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) =>
                                          new ShopItemsPage()));
                            });
                          }),
                      SizedBox(
                        height: queryData.size.height / 30,
                      ),
                      GestureDetector(
                          child: Container(
                            width: queryData.size.width / 1.2,
                            //padding: EdgeInsets.only( right: data.size.width/3, left: data.size.width/3),
                            decoration: BoxDecoration(
                                color: Colors.grey[850],
                                borderRadius: BorderRadius.circular(30)),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  child: Row(children: <Widget>[
                                    Material(
                                        color: Colors.grey,
                                        shape: CircleBorder(),
                                        child: Padding(
                                          padding: const EdgeInsets.all(7.0),
                                          child: Icon(
                                            Icons.person_outline,
                                            color: Colors.white,
                                            size: 35,
                                          ),
                                        )),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      'Profile',
                                      style: TextStyle(
                                          fontSize: 26,
                                          color: Colors.white70,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Title'),
                                    ),
                                  ]),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: queryData.size.width / 3),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.grey[600],
                                    size: 35,
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            Vibrate.vibrate();

                            setState(() {
                              print("profile clicked");
                              //Navigator.pushNamed(context, '/profile');
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new ProfilePage()));
                            });
                          }),
                      SizedBox(
                        height: queryData.size.height / 30,
                      ),
                      GestureDetector(
                          child: Container(
                            width: queryData.size.width / 1.2,
                            //padding: EdgeInsets.only( right: data.size.width/3, left: data.size.width/3),
                            decoration: BoxDecoration(
                                color: Colors.grey[850],
                                borderRadius: BorderRadius.circular(30)),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  child: Row(children: <Widget>[
                                    Material(
                                        color: Colors.purpleAccent,
                                        shape: CircleBorder(),
                                        child: Padding(
                                          padding: const EdgeInsets.all(7.0),
                                          child: Icon(
                                            Icons.settings_overscan,
                                            color: Colors.white,
                                            size: 35,
                                          ),
                                        )),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      'Consume',
                                      style: TextStyle(
                                          fontSize: 26,
                                          color: Colors.white70,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Title'),
                                    ),
                                  ]),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: queryData.size.width / 4),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.grey[600],
                                    size: 35,
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            Vibrate.vibrate();
                            setState(() {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new BarCode()));
                            });
                          }),
                      SizedBox(
                        height: queryData.size.height / 30,
                      ),
                      GestureDetector(
                          child: Container(
                            width: queryData.size.width / 1.2,
                            //padding: EdgeInsets.only( right: data.size.width/3, left: data.size.width/3),
                            decoration: BoxDecoration(
                                color: Colors.grey[850],
                                borderRadius: BorderRadius.circular(30)),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  child: Row(children: <Widget>[
                                    Material(
                                        color: Colors.white,
                                        shape: CircleBorder(),
                                        child: Padding(
                                          padding: const EdgeInsets.all(7.0),
                                          child: Icon(
                                            Icons.add_alert,
                                            color: Colors.redAccent,
                                            size: 35,
                                          ),
                                        )),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      'Notifications',
                                      style: TextStyle(
                                          fontSize: 26,
                                          color: Colors.white70,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Title'),
                                    ),
                                  ]),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: queryData.size.width / 7),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.grey[600],
                                    size: 35,
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            Vibrate.vibrate();
                            setState(() {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new Alert()));
                            });
                          }),
                    ],
                  ),
                  //SizedBox(height: 120,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class newDialog extends StatefulWidget {
  @override
  newDialogState createState() => newDialogState();
}

class newDialogState extends State<newDialog> {
  SpeechRecognition _speechRecognition; //define spe reg object
  bool isAva = false; //if app is able to interact with OS
  bool isListening = false; //if app is listen to microphone
  String output_text = ""; // converted text from voice input

  String check1 = "meal";
  String check2 = "food";
  String check3 = "lunch";
  String check4 = "dinner";
  String check5 = "breakfast";
  String check6 = "hungry";

  String camera1 = "camera";
  String camera2 = "image";
  String camera3 = "photo";
  String camera4 = "upload";
  String camera5 = "caregiver";
  String camera6 = "doctor";
  String camera7 = "update";
  String profile1 = "profile";
  String profile2 = "password";
  String shop1 = "shopping";
  String shop2 = "buy";
  String shop3 = "purchase";
  String shop4 = "new";

  @override
  void initState() {
    super.initState();
    initSpeechRec();
  }

  void initSpeechRec() {
    _speechRecognition = SpeechRecognition();
    _speechRecognition.setAvailabilityHandler(
      (bool result) => setState(() => isAva = result),
    ); //call back

    _speechRecognition.setRecognitionStartedHandler(
      () => setState(() => isListening = true),
    ); // call back

    _speechRecognition.setRecognitionResultHandler(
      (String speech) => setState(
        () => output_text = speech,
      ),
    ); // call back

    _speechRecognition.setRecognitionCompleteHandler(
      () => setState(() => isListening = false),
    ); // call back

    _speechRecognition.activate().then(
          (result) => setState(() => isAva = result),
        );
    _speechRecognition
        .listen(locale: "en_AU")
        .then((result) => print('$result'));
  }

  //POST meal
  void addMeal() {
    Meals m1 = Meals(
        id: 1,
        title: "Breakfast",
        readyInMinutes: 29,
        image: "image",
        imageUrls: ['https://picsum.photos/id/1080/200/300'],
        servings: 1);
    //Meals m2 = Meals(id: 1,title: "dassad",readyInMinutes: 24320,image: "image",imageUrls: [],servings: 42);
    Nutrients n =
        Nutrients(calories: 350, fat: 20, carbohydrates: 1, protein: 13);
    //MenuModel menu = MenuModel(meals: [m1,m2], nutrients: n);
    MenuModel menu = MenuModel(meals: [m1], nutrients: n);
    Map req = {"owner": "meal", "content": menu.toMap()};
    //print(menu.toJson());
    Future<int> success = MenuDao.post(json.encode(req));
    success.then((val) {
      if (val == 1) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                content: Text("SUCCESS!"),
              );
            });
      } else {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                content: Text("Failed!!!!"),
              );
            });
      }
      setState(() {});
    });
  }

  void errorPopup(BuildContext context) {
    var popup = AlertDialog(
        content: Text(
      "oops! I don't understand it, Sorry! ",
      style: TextStyle(fontFamily: 'Title', fontSize: 20),
    ));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return popup;
        });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Say something...',
        style: TextStyle(fontSize: 36, fontFamily: 'Title'),
      ),
      content: Container(
          height: 200,
          width: 500,
          child: Center(
            child: Text(output_text),
          )),
      actions: <Widget>[
        Container(
          height: 60,
          width: 70,
          child: Material(
            borderRadius: BorderRadius.circular(10),
            shadowColor: Colors.greenAccent,
            color: Colors.green,
            elevation: 7,
            child: GestureDetector(
              onTap: () {
                Vibrate.vibrate();
                //addMeal();
                print('pressed yes');
                if (output_text.contains(check1) ||
                    output_text.contains(check2) ||
                    output_text.contains(check3) ||
                    output_text.contains(check4) ||
                    output_text.contains(check5) ||
                    output_text.contains(check6)) {
                  setState(() {
                    print("meal.............");
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new MealPage()));
                  });
                } else if (output_text.contains(camera1) ||
                    output_text.contains(camera2) ||
                    output_text.contains(camera3) ||
                    output_text.contains(camera4) ||
                    output_text.contains(camera5) ||
                    output_text.contains(camera6) ||
                    output_text.contains(camera7)) {
                  setState(() {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new cameraScreen()));
                  });
                } else if (output_text.contains(profile1) ||
                    output_text.contains(profile2)) {
                  setState(() {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new ProfilePage()));
                  });
                } else if (output_text.contains(shop1) ||
                    output_text.contains(shop2) ||
                    output_text.contains(shop3) ||
                    output_text.contains(shop4)) {
                  setState(() {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new ShopItemsPage()));
                  });
                }else if (output_text.contains('notification')) {
                  setState(() {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new Alert()));
                  });
                } else if (output_text.contains('scan')|| output_text.contains('barcode')) {
                  setState(() {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new BarCode()));
                  });
                }
                else {
                  errorPopup(context);
                  print("not recognized");
                }
              },
              child: Center(
                child: Text(
                  'Go',
                  style: TextStyle(
                    fontFamily: 'Title',
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          height: 60,
          width: 70,
          child: Material(
            borderRadius: BorderRadius.circular(10),
            shadowColor: Colors.greenAccent,
            color: Colors.red,
            elevation: 7,
            child: GestureDetector(
              onTap: () {
                Vibrate.vibrate();

                Navigator.pop(context);
              },
              child: Center(
                child: Text(
                  'Back',
                  style: TextStyle(
                    fontFamily: 'Title',
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),

//        Container(
//          height: 60,
//          width: 70,
//          child: Material(
//            borderRadius: BorderRadius.circular(10),
//            shadowColor: Colors.greenAccent,
//            color: Colors.red,
//            elevation: 7,
//            child: GestureDetector(
//              onTap: (){
//                addMeal();
//              },
//              child: Center(
//                child: Text(
//                  'add meal',
//                  style: TextStyle(
//                    fontFamily: 'Title',
//                    color: Colors.white,
//                    fontSize: 28,
//                    fontWeight: FontWeight.bold,
//                  ),
//                ),
//              ),
//            ),
//          ),
//        ),
      ],
    );
  }
}
