import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotaal/caregiver.dart';
import 'package:hotaal/familymember.dart';
import 'package:hotaal/qr.dart';
import 'package:hotaal/screen/ask.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibrate/vibrate.dart';
import 'dementia_main.dart';
import 'signup.dart';
import 'package:hotaal/userAuth.dart';
import 'profile.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hotaal/qr.dart';
import 'package:ping_discover_network/ping_discover_network.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/services.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class login extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<login> {
  MediaQueryData queryData;
  bool isLoading = false;
  Future<authResponse> authFuture;
  authResponse auth;
  final usernameInput = TextEditingController();
  final passwordInput = TextEditingController();
  bool login_success = false;
  bool isLogining = false;
  bool _obscureText = true;
  bool colorChange = false;
  var _formKey = GlobalKey<FormState>();
  String loginurl = "https://ylr9w8c0q2.execute-api.us-east-1.amazonaws.com/v0/login";
  bool selected = true;
  bool autoLoginSelected = false;
  List <String> userPref = [];
  List <String> passPref = [];
  bool selectPref;
  bool autoLoginSelectedRef;
  bool linkPref ;

  final _storage = new FlutterSecureStorage();

  String usernameStored;
  String passwordStored;

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String fcm_token;

  String noti;
  String ipAdd;
  @override
  void initState() {
    super.initState();
    firebaseCloudMessaging_Listeners();
    _getRememberMeState();
    _getAutoLoginState();

  }

  void firebaseCloudMessaging_Listeners() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        //final title = message['notification']['title'];
        //final body = message['notification']['body'];
        print('on message $message');

        //_notificatio(noti);
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );

    _firebaseMessaging.getToken().then((token){
      print(token);

      fcm_token = token;
    });

    //_notificatio(noti);

  }

  saveIP() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    const port = 8000;
    int found = 0;
    final stream = NetworkAnalyzer.discover2(
      '192.168.0', port,
      timeout: Duration(milliseconds: 5000),
    );
    stream.listen((NetworkAddress addr) {
      if (addr.exists) {
        found++;
        print('Found device: ${addr.ip}:$port');
        ipAdd = addr.ip;
        prefs.setString('IP', ipAdd);
        print('saved ip: ${prefs.getString('IP')}');
      }else{
        print('not found device');
      }
    }).onDone((){
      print('done');
    });
  }


  void _notificatio(String noti) async{
    AwesomeDialog(
        context: context,
        animType: AnimType.BOTTOMSLIDE,
        dialogType: DialogType.ERROR,
        tittle: 'OOPS!',
        desc: noti,
        onDissmissCallback: () {
          debugPrint('Dialog Dissmiss from callback');
        }).show();
  }

  void _login() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      Map map = new Map<String, dynamic>();
        map["username"] = usernameInput.text;
        map["password"] = passwordInput.text;
      if(fcm_token!=null)map["notification_token"]=fcm_token;
      print(map.toString());
      authFuture = createPost(loginurl, body: map);
      authFuture.then((value){
        auth = value;
        print(auth.msg);
        print(auth.role);
        print(" auth: $auth");
        Navigator.pop(context);
        isLoading = false;
        if(auth.code == 1 ) //succeed login
          {
            print('Logged as ${auth.role}');
            login_success = true;
            print('logged in');
            setState(() {
              userPref.add(usernameInput.text);
              prefs.setStringList('userCredentials', userPref);
            });
            print('username stored : $userPref');
            if(selected){
//              passPref.add(passwordInput.text);
//              prefs.setStringList('passCredentials', passPref);
//              print('password stored : $passPref');
              _addNewItem('passwordSecureStored', passwordInput.text);
              _getPass('passwordSecureStored');
            }
          }
        else if(auth.code== 0)
        {
          Vibrate.vibrate();
          errorPopup();
          login_success = false;
        }

        if(auth.role == 'patient') //login as patient
        {
          Navigator.push(context, MaterialPageRoute(
              builder: (_) => patient(usernameInput.text,passwordInput.text)
          ));
        }
        if(auth.role == 'caregiver') //login as caregiver
        {
          //loginPopup(context);
          Navigator.push(context, MaterialPageRoute(
              builder: (_) => Caregiver()
          ));
        }
        if(auth.role == 'family') //login as caregiver
            {
          //loginPopup(context);
          Navigator.push(context, MaterialPageRoute(
              builder: (_) => FamilyMember()
          ));
        }
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(child: CircularProgressIndicator(),);
          });
      isLoading = true;
    }catch(e){
      if(isLoading){
        isLoading = false;
        Navigator.pop(context);
      } else {
      }
    }
  }

  void _autoLogin() async{
    autoLoginSelected = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      Map map = new Map<String, dynamic>();
      String value = await _storage.read(key: 'passwordSecureStored');
      userPref = prefs.getStringList('userCredentials');
      map["username"] = userPref[userPref.length-1];
      map["password"] = value;
      authFuture = createPost(loginurl, body: map);
      authFuture.then((value){
        auth = value;
        print(auth.msg);
        print(auth.role);
        print(" auth: $auth");
        Navigator.pop(context);
        isLoading = false;
        if(auth.code == null){
          AwesomeDialog(
              context: context,
              animType: AnimType.BOTTOMSLIDE,
              dialogType: DialogType.ERROR,
              tittle: 'OOPS!',
              desc: 'Server is done',
              onDissmissCallback: () {
                debugPrint('Dialog Dissmiss from callback');
              }).show();
        }

        if(auth.code == 1 ) //succeed login
            {
          print('Logged as ${auth.role}');

          login_success = true;
          print('logged in');
          setState(() {
            userPref.add(usernameInput.text);
            prefs.setStringList('userCredentials', userPref);
          });
          print('username stored : $userPref');
          if(selected){
            _addNewItem('passwordSecureStored', passwordInput.text);
            _getPass('passwordSecureStored');
          }
          if(autoLoginSelected){
            //auto login starts
          }
        }
        else if(auth.code== 0)
        {
          errorPopup();
          login_success = false;
        }
        if(auth.role == 'patient') //login as patient
            {
          Navigator.push(context, MaterialPageRoute(
              builder: (_) => patient(usernameInput.text,passwordInput.text)
          ));
        }
        if(auth.role == 'caregiver') //login as caregiver
            {
          Navigator.pushNamed(context,'/caregiver');
            }
      });
    }catch(e){
    }
  }


  void _addNewItem(key, value) async {
    await _storage.write(key: key, value: value);
    //_readAll();
  }

  void _getPass(key) async{
    String value = await _storage.read(key: key);
    print('pass saved is : $value');
  }

  void errorPopup(){
      AwesomeDialog(
          context: context,
          animType: AnimType.BOTTOMSLIDE,
          dialogType: DialogType.ERROR,
          tittle: 'OOPS!',
          desc: '${auth.msg}',
          onDissmissCallback: () {
            debugPrint('Dialog Dissmiss from callback');
          }).show();

  }


  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _setRememberMeState() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
      selectPref = selected;
      prefs.setBool('RememberMeStatus', selectPref);
      print('Remember me?: $selectPref');
  }

  void _setAutoLoginState() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    autoLoginSelectedRef = autoLoginSelected;
    prefs.setBool('AutoLoginStatus', autoLoginSelectedRef);
    print('Auto login?: $autoLoginSelectedRef');
  }

  void _getAutoLoginState() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('auto login state: ');
    print(prefs.getBool('AutoLoginStatus'));
    if(prefs.containsKey('AutoLoginStatus')){
      _autoLogin();
    }
  }



  void _getRememberMeState() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String value = await _storage.read(key: 'passwordSecureStored');
    print(prefs.getBool('RememberMeStatus'));
    if(prefs.containsKey('userCredentials') ){
      setState(() {
        userPref = prefs.getStringList('userCredentials');
        usernameStored = userPref[userPref.length-1];
        usernameInput.text = usernameStored;
      });
      print('username pref now is $userPref');
      print('usernameStored: $usernameStored');
    }
//    if(prefs.containsKey('passCredentials') ){
//      setState(() {
//        passPref = prefs.getStringList('passCredentials');
//        passwordStored = passPref[passPref.length-1];
//        passwordInput.text = passwordStored;
//      });
//      print('pass pref now is $passPref');
//      print('passwordStored: $passwordStored');
//    }
    print('value: $value');
    passwordInput.text = value;

    if(prefs.getBool('RememberMeStatus') == false){
      setState(() {
        passwordInput.text = '';
      });
    }
    print('select pref is $selectPref');
  }

  @override
  Widget build(BuildContext context){
    final data = MediaQuery.of(context);
    queryData = MediaQuery.of(context);
    Widget loadingIndicator =isLogining? new Container(
      color: Colors.grey[300],
      width: 70.0,
      height: 70.0,
      child: new Padding(padding: const EdgeInsets.all(5.0),child: new Center(child: new CircularProgressIndicator())),
    ):new Container();
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Form(
            key: _formKey,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: queryData.size.height/20),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Icon(Icons.games, color: Colors.redAccent,
                                size: 45,),
                            ),
                            SizedBox(width: 10),
                            Container(
                              child: RichText(
                                text: TextSpan(
                                    style: Theme.of(context).textTheme.body1.copyWith(fontSize: 45),
                                    children: [
                                      TextSpan(
                                          text: 'H',
                                          style: TextStyle(
                                            fontFamily: "Title",
                                          )
                                      ),
                                      TextSpan(
                                          text: 'o',
                                          style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontFamily: "Title",
                                          )
                                      ),
                                      TextSpan(
                                          text: 'TAAL',
                                          style: TextStyle(
                                            fontFamily: "Title",
                                          )
                                      ),
                                    ]
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: data.size.height/15),

                    Container(
                      padding: EdgeInsets.only(top: 0, left: queryData.size.width/6, right: queryData.size.width/6,),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                labelText: 'Email',
                                icon : const Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: const Icon(Icons.person_outline)),
                                labelStyle: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey
                                )
                            ),
                            controller: usernameInput,
                            validator: (String value){
                              if(value.isEmpty){
                                return 'Please enter username';
                              }
                            },
                          )
                        ],
                      ),
                    ),

                    Container(
                      //padding: EdgeInsets.only(top: 0, right: data.size.width/4, left: data.size.width/3),
                      padding: EdgeInsets.only(top: 0, left: queryData.size.width/6),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                  labelText: 'Password',
                                  icon : const Padding(
                                      padding: const EdgeInsets.only(top: 15.0 ),
                                      child: const Icon(Icons.lock)),
                                  labelStyle: TextStyle(
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey
                                  )
                              ),
                              controller: passwordInput,
                              validator: (String value){
                                if(value.isEmpty){
                                  return 'Please enter password';
                                }
                              },
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: _toggle,
                              child: Padding(
                                padding:  EdgeInsets.only(right: queryData.size.width/8),
                                child: Icon(Icons.remove_red_eye, color: Colors.lightBlueAccent,),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    SizedBox(height: data.size.height/50),

                    Container(
                      margin: EdgeInsets.only(left: queryData.size.width/10),
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Checkbox(
                            value: selected,
                            onChanged: (bool val){
                              setState(() {
                                 selected = val;
                                 _setRememberMeState();
                              });
                            },
                          ),
                         GestureDetector(
                          child: new Text(
                            "Remember me",
                            style: new TextStyle(
                                color: Colors.black,
                              fontFamily: 'Title',
                            ),
                            ),
                           onTap: (){
                            setState(() {
                              selected = !selected;
                              _setRememberMeState();
                            });
                           },
                          ),

                          SizedBox(width: queryData.size.width/30,),

                          Checkbox(
                            value: autoLoginSelected,
                            onChanged: (bool val){
                              setState(() {
                                autoLoginSelected = val;
                                _setAutoLoginState();
                              });
                            },
                          ),
                          GestureDetector(
                            child: new Text(
                              "Auto Login",
                              style: new TextStyle(
                                color: Colors.black,
                                fontFamily: 'Title',
                              ),
                            ),
                            onTap: (){
                              setState(() {
                                autoLoginSelected = !autoLoginSelected;
                                _setAutoLoginState();
                              });
                            },
                          ),

                        ],
                      ),
                    ),

                    SizedBox(height: data.size.height/50),

                    Padding(
                        padding: EdgeInsets.only(
                            //bottom: MediaQuery.of(context).viewInsets.bottom

                        ),
                      child: Container(
                        padding: EdgeInsets.only( right: data.size.width/6, left: data.size.width/6),
                        height: data.size.height/15,
                        child: Material(
                          borderRadius: BorderRadius.circular(30),
                          shadowColor: Colors.greenAccent,
                          color: colorChange? Colors.lightGreen : Colors.green,
                          elevation: 7,
                          child: GestureDetector(
                            onTap: () async{
                              saveIP();
                              setState(() {
                                colorChange = true;
                                isLogining = true;
                              });
                              //TODO
                              if(_formKey.currentState.validate()){
                                _login();
                                setState(() {
                                });
                              }
                              else
                              {
                                  AwesomeDialog(
                                      context: context,
                                      animType: AnimType.BOTTOMSLIDE,
                                      dialogType: DialogType.ERROR,
                                      tittle: 'OOPS!',
                                      desc: 'Invalid inputs!',
                                      onDissmissCallback: () {
                                        debugPrint('Dialog Dissmiss from callback');
                                      }).show();

                              }
                            },
                            child: Center(
                                child: Text(
                                  'LOGIN',
                                  style: TextStyle(
                                    fontFamily: 'Title',
                                    color:  Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  )
                                ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(height: data.size.height/15),
                    Container(
                      alignment: Alignment(0, 0),
                    ),

                    SizedBox(height: data.size.height/60),

                    Column(
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text('No account? ',style: TextStyle(
                            fontFamily: 'Title',
                            fontSize: 22
                        ),),

                        SizedBox(width: 10,),

                        new InkWell(
                          onTap: (){
                            Navigator.pushNamed(context,'/signup');
                          },
                          child: Text('Register with Email',
                            style: TextStyle(
                                fontSize: 22,
                                fontFamily: 'Title',
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline
                            ),
                          ),
                        ),
                      ],
                      //mainAxisAlignment: MainAxisAlignment.center,
                    ),
//                    new InkWell(
//                      onTap: (){
//                        Navigator.pushNamed(context,'/caregiver');
//                      },
//                      child: Text('Caregiver',
//                        style: TextStyle(
//                            fontSize: 28,
//                            fontFamily: 'Title',
//                            color: Colors.black,
//                            fontWeight: FontWeight.bold,
//                            decoration: TextDecoration.underline
//                        ),
//                      ),
//                    ),
                  ],
                )
            )
        )
    );
  }
  bool loginAction() {
    Future.delayed(const Duration(seconds: 3)).then((val){
      Navigator.pop(context);
      return true;
    });
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(child: CircularProgressIndicator(),);
        });
  }
}
