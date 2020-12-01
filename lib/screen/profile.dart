import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hotaal/screen/ask.dart';
import '../userAuth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
class ProfilePage extends StatefulWidget {

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {

  Future<editProfileResponse> editProfileFuture;
  editProfileResponse auth;
  String a;

  String _editUrl = "https://ylr9w8c0q2.execute-api.us-east-1.amazonaws.com/v0/edituserprofile";
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  final  pass = new TextEditingController();
  final username = new TextEditingController();
  final  mobile = new TextEditingController();
  final  age = new TextEditingController();
  final  gender = new TextEditingController();
  final  address = new TextEditingController();
  MediaQueryData queryData;
  List <String> userPref = [];
  String usernameStored;

  @override
  void initState() {
    username.text = " ";
    mobile.text = " ";
    age.text = " ";
    gender.text = " ";
    address.text = " ";
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
        print('username to edit: ${userPref[userPref.length-1]}');
      });
    }
  }

  void dispose() {
    username.dispose();
    myFocusNode.dispose();
    super.dispose();
  }

  String getUsername(String value) {
    int i = value.indexOf('@');
    return value.substring(0, i);
  }

  void _editProfile(){
    Map map = new Map<String, dynamic>();
    map["username"] = userPref[userPref.length-1];
    map["password"] = pass.text;
    map["profile"] =
    {
      "age": age.text,
      "gender": gender.text,
      "mobile": mobile.text,
      "address": address.text
    };
    print(map.toString());
    editProfileFuture = editProfilePost(_editUrl, body: map);
    editProfileFuture.then((value){
      auth = value;
      print(auth.code);
      print(auth.msg);
      if (auth.code == 0)
      {
        print(auth.msg);
      }
      else if (auth.code == 1)
      {
        print(auth.msg);


      }
      else{
        print(auth.msg);
      }
    });
  }
  void edit(){
  }

  failPop(){
    AwesomeDialog(
        context: context,
        animType: AnimType.BOTTOMSLIDE,
        dialogType: DialogType.ERROR,
        tittle: 'OOPS!',
        desc: 'Something wrong',
        onDissmissCallback: () {
          debugPrint('Dialog Dissmiss from callback');
        }).show();
  }

  successPop(){
    AwesomeDialog(
        context: context,
        animType: AnimType.BOTTOMSLIDE,
        dialogType: DialogType.SUCCES,
        tittle: 'Done',
        desc: 'You have just set up a new password',
        onDissmissCallback: () {
          debugPrint('Dialog Dissmiss from callback');
        }).show();
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.black,
          title: new Text('Profile' , style: TextStyle(
        fontWeight: FontWeight.w700)),
        ),
        body: new Container(
          color: Colors.grey,
          child: new ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  new Container(
                    color: Colors.grey,
                    //height: 750,
                    height: 810,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 25.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          //form starts here
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,

                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Change Password? ',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      decoration: const InputDecoration(
                                          hintText: "Enter new password here"),
                                      enabled: !_status,
                                      controller: pass,
                                    ),

                                  ),
                                ],
                              )),
//                          Padding(
//                              padding: EdgeInsets.only(
//                                  left: 25.0, right: 25.0, top: 25.0),
//                              child: new Row(
//                                mainAxisSize: MainAxisSize.max,
//                                children: <Widget>[
//                                  new Column(
//                                    mainAxisAlignment: MainAxisAlignment.start,
//                                    mainAxisSize: MainAxisSize.min,
//                                    children: <Widget>[
//                                      new Text(
//                                        'Mobile',
//                                        style: TextStyle(
//                                            fontSize: 16.0,
//                                            fontWeight: FontWeight.bold),
//                                      ),
//                                    ],
//                                  ),
//                                ],
//                              )),
//                          Padding(
//                              padding: EdgeInsets.only(
//                                  left: 25.0, right: 25.0, top: 2.0),
//                              child: new Row(
//                                mainAxisSize: MainAxisSize.max,
//                                children: <Widget>[
//                                  new Flexible(
//                                    child: new TextField(
//                                      decoration: const InputDecoration(
//                                          hintText: "Enter Mobile Number"),
//                                      enabled: !_status,
//                                      controller: mobile,
//                                    ),
//                                  ),
//                                ],
//                              )),
//                          Padding(
//                              padding: EdgeInsets.only(
//                                  left: 25.0, right: 25.0, top: 25.0),
//                              child: new Row(
//                                mainAxisSize: MainAxisSize.max,
//                                mainAxisAlignment: MainAxisAlignment.start,
//                                children: <Widget>[
//                                  Expanded(
//                                    child: Container(
//                                      child: new Text(
//                                        'Age',
//                                        style: TextStyle(
//                                            fontSize: 16.0,
//                                            fontWeight: FontWeight.bold),
//                                      ),
//                                    ),
//                                    flex: 2,
//                                  ),
//                                  Expanded(
//                                    child: Container(
//                                      child: new Text(
//                                        'Gender',
//                                        style: TextStyle(
//                                            fontSize: 16.0,
//                                            fontWeight: FontWeight.bold),
//                                      ),
//                                    ),
//                                    flex: 2,
//                                  ),
//                                ],
//                              )),
//                          Padding(
//                              padding: EdgeInsets.only(
//                                  left: 25.0, right: 25.0, top: 2.0),
//                              child: new Row(
//                                mainAxisSize: MainAxisSize.max,
//                                mainAxisAlignment: MainAxisAlignment.start,
//                                children: <Widget>[
//                                  Flexible(
//                                    child: Padding(
//                                      padding: EdgeInsets.only(right: 10.0),
//                                      child: new TextField(
//                                        keyboardType: TextInputType.numberWithOptions(),
//                                        decoration: const InputDecoration(
//                                            hintText: "Enter Age"),
//                                        enabled: !_status,
//                                        controller: age,
//                                      ),
//                                    ),
//                                    flex: 2,
//                                  ),
//                                  Flexible(
//                                    child: new TextField(
//                                      decoration: const InputDecoration(
//                                          hintText: "Select Gender"),
//                                      enabled: !_status,
//                                      controller: gender,
//                                    ),
//                                    flex: 2,
//                                  ),
//                                ],
//                              )),

//                          Padding(
//                              padding: EdgeInsets.only(
//                                  left: 25.0, right: 25.0, top: 25.0),
//                              child: new Row(
//                                mainAxisSize: MainAxisSize.max,
//                                children: <Widget>[
//                                  new Column(
//                                    mainAxisAlignment: MainAxisAlignment.start,
//                                    mainAxisSize: MainAxisSize.min,
//                                    children: <Widget>[
//                                      new Text(
//                                        'Address',
//                                        style: TextStyle(
//                                            fontSize: 16.0,
//                                            fontWeight: FontWeight.bold),
//                                      ),
//                                    ],
//                                  ),
//                                ],
//                              )),
//                          Padding(
//                              padding: EdgeInsets.only(
//                                  left: 25.0, right: 25.0, top: 2.0),
//                              child: new Row(
//                                mainAxisSize: MainAxisSize.max,
//                                children: <Widget>[
//                                  new Flexible(
//                                    child: new TextField(
//                                      decoration: const InputDecoration(
//                                          hintText: "Enter address"),
//                                      enabled: !_status,
//                                      controller: address,
//                                    ),
//                                  ),
//                                ],
//                              )),

                          Padding(
                              padding: EdgeInsets.only(
                                  left: queryData.size.width/2.5,  top: 25.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      _status ? _getEditIcon() : new Container(),
                                    ],
                                  )
                                ],
                              )

                          ),

                          !_status ? _getActionButtons() : new Container(),

//                          Flexible(
//                            child: Align(
//                              alignment: FractionalOffset.bottomCenter,
//                              child: Container(
//                                height: 90.0,
//
//                                child: BottomAppBar(
//                                  //color: Color.fromRGBO(58, 65, 86, 150),
//                                  color: Colors.black54,
//                                  child: Row(
//                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                    children: <Widget>[
//                                      FlatButton(
//                                        onPressed: ()  {
//                                          setState(() {
//                                            //Navigator.pushNamed(context, '/dementia');
//                                            Navigator.push(context, new MaterialPageRoute(
//                                                builder: (context) =>
//                                                new Dementia())
//                                            );
//                                          });
//                                        },
//                                        color: Colors.purpleAccent,
//
//                                        //color: Colors.white70,
//                                        //padding: EdgeInsets.all(10.0),
//                                        child: Column( // Replace with a Row for horizontal icon + text
//                                          children: <Widget>[
//                                            Icon(Icons.home, size: 50,color: Colors.white),
//                                            Text("Home",
//                                              style: TextStyle(
//                                                  fontSize: 23,
//                                                  color: Colors.white,
//                                                  fontWeight: FontWeight.bold,
//                                                  fontFamily: 'Title'
//                                              ),)
//                                          ],
//                                        ),
//                                      ),
//                                    ],
//                                  ),
//                                ),
//                              ),
//                            ),
//                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                    child: new Text("Save"),
                    textColor: Colors.white,
                    color: Colors.green,
                    onPressed: () {
                      setState(() {
                        _status = true;
                        FocusScope.of(context).requestFocus(new FocusNode());
                        _editProfile();
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
                    child: new Text("Cancel"),
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

  Widget _getEditIcon() {
    return GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.redAccent,
        radius: 42.0,
        child: new FlatButton(
          onPressed: ()  {
            setState(() {
              _status = false;
            });
          },
          padding: EdgeInsets.all(10.0),
          child: Column( // Replace with a Row for horizontal icon + text
            children: <Widget>[
              Icon(Icons.edit, color: Colors.white, size: 30,),
              Text("Edit",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontFamily: 'Title'
                ),)
            ],
          ),
        ),
      ),
    );
  }
}
