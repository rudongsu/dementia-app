import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../userAuth.dart';
import '../qr.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'qrScan.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => new _SignupState();
}

class _SignupState extends State<Signup> {
  String url_email =
      "https://ylr9w8c0q2.execute-api.us-east-1.amazonaws.com/v0/checkemail";
  String url =
      "https://ylr9w8c0q2.execute-api.us-east-1.amazonaws.com/v0/signup";

  Future<emailResponse> checkEmailFuture;
  emailResponse auth1;

  Future<signupResponse> signupFuture;
  signupResponse auth;
  MediaQueryData queryData;

  final usernameSign = TextEditingController();
  final passwordSign = TextEditingController();
  final emailSign = TextEditingController();
  String group;
  String role;
  String gender;
  var _formKey = GlobalKey<FormState>();
  var _formKey1 = GlobalKey<FormState>();

  String _email;
  bool _validate = false;
  bool _verify = false;
  bool _valiEmail = false;
  bool _isloading = false;
  bool isPressed = false;
  bool female = false;
  bool genderPressed = false;
  bool femalePressed = false;
  int rolePressed = 0;
  bool isMale = false;
  bool isSigned = false;
  bool colorChange = false;

// overlay for verifying email address if registered
  showOverlay(BuildContext context) async {
    OverlayState overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
              top: 330,
              right: MediaQuery.of(context).size.width / 2.8,
              child: Icon(Icons.check_circle, color: Colors.green, size: 40),
            ));
    overlayState.insert(overlayEntry);
    await Future.delayed(Duration(seconds: 3));
    overlayEntry.remove();
  }

  showOverlay1(BuildContext context) async {
    OverlayState overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
              top: 330,
              right: MediaQuery.of(context).size.width / 2.8,
              child: Icon(Icons.error, color: Colors.red, size: 40),
            ));
    overlayState.insert(overlayEntry);
    await Future.delayed(Duration(seconds: 3));
    overlayEntry.remove();
  }

  void _signup() {
    Map map = new Map<String, dynamic>();
    map["password"] = passwordSign.text;
    map["role"] = role;
    if (group != null) map["group"] = group;
    map["profile"] = {
      "email": emailSign.text,
      "name": usernameSign.text,
      "gender": gender,
    };
    print(map.toString());
    signupFuture = signupPost(url, body: map);
    signupFuture.then((value) {
      auth = value;
      if (auth.code1 == 0) {
        print("existed!!!");
        errorPopup(context);
      } else if (auth.code1 == 1) {
        print("ok");
        succPopup(context);
        isSigned = true;
      } else {
        print(auth.msg);
        print(auth.code1);
        print("missing values!");
        errorPopup(context);
      }
      setState(() {});
    });
  }

  void errorPopup(BuildContext context) {
    AwesomeDialog(
        context: context,
        animType: AnimType.BOTTOMSLIDE,
        dialogType: DialogType.ERROR,
        tittle: 'OOPS!',
        desc: ' ',
        onDissmissCallback: () {
          debugPrint('Dialog Dissmiss from callback');
        }).show();
  }

  void succPopup(BuildContext context) {
    AwesomeDialog(
        context: context,
        animType: AnimType.BOTTOMSLIDE,
        dialogType: DialogType.SUCCES,
        desc: 'Please verify your email  \n'
              '${emailSign.text}',
        tittle: 'Welcome!',
        onDissmissCallback: () {
          debugPrint('Dialog Dissmiss from callback');
        }).show();
  }

  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      child: new Dialog(
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            new CircularProgressIndicator(),
            new SizedBox(
              width: 20,
            ),
            new Text(
              "Loading",
              style: TextStyle(
                fontSize: 23,
              ),
            ),
          ],
        ),
      ),
    );

    new Future.delayed(new Duration(seconds: 1), () {
      Navigator.pop(context); //pop dialog
      //_login();
    });
  }

  //to verify the status of entered email address
  void _verifyEmal(BuildContext context) {
    Map map1 = new Map<String, dynamic>();
    map1["email"] = emailSign.text;
    checkEmailFuture = emailPost(url_email, body: map1);
    checkEmailFuture.then((value) {
      auth1 = value;
      if (auth1.code == 0) //email unregistered
      {
        print("OKKK!!!");
        _verify = true;
        _valiEmail = true;
        //_indicator1(context);
        //showOverlay(context);
      } else {
        _valiEmail = false;
        //_indicator(context);
        //showOverlay1(context);
      }
    });
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Please enter valid email';
    else
      _valiEmail = true;
    _verifyEmal(context);
    return null;
  }

  void _awaitReturnValueFromSecondScreen(BuildContext context) async {
    final deviceID = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => qr(),
        ));

    setState(() {
      group = deviceID;
    });
  }

  _pressed() {
    var newVal = true;
    if (isPressed) {
      newVal = false;
    } else {
      newVal = true;
    }
    // This function is required for changing the state.
    // Whenever this function is called it refresh the page with new value
    setState(() {
      isPressed = newVal;
    });
  }

  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Form(
            key: _formKey,
            autovalidate: _validate, //auto validation on form
            child: Padding(
                padding: EdgeInsets.only(top: queryData.size.height / 50),
                child: ListView(
                  children: <Widget>[
                    Center(
                      child: Container(
                        child: Text('Create account',
                            style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Title')),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        top: queryData.size.height / 50,
                        left: queryData.size.width / 5,
                        right: queryData.size.width / 5,
                      ),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Name',
                                labelStyle: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey)),
                            maxLength: 20,
                            controller: usernameSign,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Please enter username';
                              }
                            },
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: queryData.size.width / 5,
                        right: queryData.size.width / 5,
                      ),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey)),
                            maxLength: 20,
                            controller: passwordSign,

                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Please enter password';
                              }
                            },
                          )
                        ],
                      ),
                    ),
                    Form(
                      key: _formKey1,
                      autovalidate: _validate, //auto validation on form
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: queryData.size.width / 5,
                          right: queryData.size.width / 5,
                        ),
                        child: Row(children: <Widget>[
                          Container(
                              width: queryData.size.width * 0.6,
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    labelText: 'Email',
                                    //contentPadding: new EdgeInsets.symmetric( horizontal: 5.0),
                                    labelStyle: TextStyle(
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey)),
                                maxLength: 30,
                                controller: emailSign,
                                validator: validateEmail,
                                onSaved: (String val) {
                                  _email = val;
                                },
                              )),
                        ]),
                      ),
                    ),
                    SizedBox(height: queryData.size.height/40,),
                    Container(
                      padding: EdgeInsets.only(
                        left: queryData.size.width / 5,
                        right: queryData.size.width / 5,
                      ),
                      width: 30.0,
                      child: Text(
                        "Gender",
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.only(
                        left: queryData.size.width / 5,
                        right: queryData.size.width / 5,
                      ),
                      child: Row(
                        children: <Widget>[
                          CircleAvatar(
                            //backgroundColor: Colors.blue[50],
                            //backgroundColor: _iconColor1,
                            backgroundColor: isMale
                                ? Colors.lightBlueAccent
                                : Colors.white,
                            child: new IconButton(
                                icon: Icon(
                                  Icons.face,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  gender = 'male';
                                  setState(() {
                                    //genderPressed = ! genderPressed;
                                    isMale = true;
                                  });
                                  print(gender);
                                }),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Container(
                            width: 50.0,
                            child: Text(
                              "Male",
                              textAlign: TextAlign.left,
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          CircleAvatar(
                            backgroundColor: !isMale
                                ? Colors.lightBlueAccent
                                : Colors.white,
                            child: new IconButton(
                                icon: Icon(
                                  Icons.pregnant_woman,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  gender = 'female';
                                  setState(() {
                                    //female = ! female;
                                    isMale = false;
                                  });
                                  print(gender);
                                }),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Container(
                            width: 50.0,
                            child: Text(
                              "Female",
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.only(
                        left: queryData.size.width / 5,
                        right: queryData.size.width / 5,
                      ),
                      width: 30.0,
                      child: Text(
                        "I'm  ",
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundColor: rolePressed == 0
                                      ? Colors.lightBlueAccent
                                      : Colors.white,
                                  child: new IconButton(
                                      icon: Icon(
                                        Icons.accessible,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () {
                                        role = 'patient';
                                        setState(() {
                                          rolePressed = 0;
                                        });
                                        print(role);
                                      }),
                                ),
                                SizedBox(height: queryData.size.height/70,),

                                Container(
                                  width: 60.0,
                                  child: Text(
                                    "The older",
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),

                            Column(
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundColor: rolePressed == 1
                                      ? Colors.lightBlueAccent
                                      : Colors.white,
                                  child: IconButton(
                                      icon: Icon(
                                        Icons.people,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () {
                                        role = 'family';
                                        setState(() {
                                          rolePressed = 1;
                                        });
                                        print(role);
                                      }),
                                ),
                                SizedBox(height: queryData.size.height/70,),
                                Container(
                                  width: 60.0,
                                  child: Text(
                                    "Families",
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),

                            Column(
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundColor: rolePressed == 2
                                      ? Colors.lightBlueAccent
                                      : Colors.white,
                                  child: new IconButton(
                                      icon: Icon(
                                        Icons.local_hospital,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () {
                                        role = 'caregiver';
                                        setState(() {
                                          rolePressed = 2;
                                        });
                                        print(role);
                                      }),
                                ),
                                SizedBox(height: queryData.size.height/70,),

                                Container(
                                  width: 60.0,
                                  child: Text(
                                    "Caregiver",
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            )

                          ],
                        )),
                    SizedBox(height: 20),
                    group != null?
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            //width: 70.0,
                            child: Icon(Icons.done_outline, color: Colors.green, size: 40,)
                          ),
                          SizedBox(
                            width: queryData.size.width / 20,
                          ),
                        ],
                      ),
                    )
                     :
                    Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                                top: 0, left: queryData.size.width / 5),
                            //width: 70.0,
                            child: Text(
                              "Start registering your device: ",
                              textAlign: TextAlign.center,
                            ),
                          ),

                          SizedBox(
                            width: queryData.size.width / 20,
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: new IconButton(
                                icon: Icon(
                                  Icons.devices,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _awaitReturnValueFromSecondScreen(context);
                                  });
                                }),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.only(
                          left: queryData.size.width / 10, right: queryData.size.width/10),
                      height: 45,
                      child: Material(
                        borderRadius: BorderRadius.circular(30),
                        shadowColor: Colors.greenAccent,
                        color: colorChange ? Colors.lightGreen : Colors.green,
                        elevation: 5,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_formKey.currentState.validate() &&
                                  _formKey1.currentState.validate()) {
                                _onLoading();
                                _formKey.currentState.save();
                                _formKey1.currentState.save();
                                _signup();
                                _isloading = true;
                              } else {
                                AwesomeDialog(
                                    context: context,
                                    animType: AnimType.BOTTOMSLIDE,
                                    dialogType: DialogType.ERROR,
                                    tittle: 'OOPS!',
                                    desc: 'Invalid input',
                                    onDissmissCallback: () {
                                      debugPrint('Dialog Dissmiss from callback');
                                    }).show();
                                setState(() {
                                  _validate = true;
                                });
                              }
                              if (isSigned = true) {
                                //_onLoading();

                              }
                            });
                          },
                          child: Center(
                            child: Text(
                              'SIGN UP',
                              style: TextStyle(
                                fontSize: 28,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.only(
                          left: queryData.size.width / 10, right: queryData.size.width/10),
                      height: 45,
                      color: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black,
                                style: BorderStyle.solid,
                                width: 1.0),
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(30)),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Center(
                            child: Text(
                              'BACK',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ))));
  }
}
