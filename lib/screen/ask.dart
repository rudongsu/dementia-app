import 'package:flutter/material.dart';
import 'package:hotaal/barcodeRest.dart';
import 'package:hotaal/screen/dementia_main.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hotaal/lookup_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hotaal/linkuser_rest.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class Ask extends StatefulWidget {
  @override
  _AskState createState() => _AskState();
}

class _AskState extends State<Ask> {
  PatientModel patientModel;
  String Name;
  String username;
  int selectIndex;
  List<String> userPref = [];
  String url =
      'https://ylr9w8c0q2.execute-api.us-east-1.amazonaws.com/v0/lookupusers?role=caregiver';
  String linkUrl =
      'https://ylr9w8c0q2.execute-api.us-east-1.amazonaws.com/v0/linkuser';
  String total;
  Future<linkCaregiver> linkResponse;
  String caregiver;
  List<bool> linkPref = [];
  MediaQueryData queryData;
  int layer = 0;

  void initState() {
    //getCaregiver();
    super.initState();
    checkLinkState();
    loadData();
  }

  void checkLinkState() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    layer++;
    if(prefs.getBool('link2') == true){
      AwesomeDialog(
          context: context,
          animType: AnimType.BOTTOMSLIDE,
          dialogType: DialogType.WARNING,
          tittle: 'OOPS!',
          desc: 'You have already linked with one caregiver' ,
          onDissmissCallback: () {
            layer--;
            debugPrint('Dialog Dissmiss from callback');
          }).show();
    }else{
    }

  }

  void _linkCaregiver(int position) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Items patients = patientModel.patientItems[position];
    Map map = new Map<String, dynamic>();
    caregiver = patientModel.patientItems[position].profile.email;
    print('caregiver : $caregiver');
    map["username"] = caregiver;
    map["link"] = 'HOTAALUOA';
    layer++;
    AwesomeDialog(
        context: context,
        dialogType: DialogType.INFO,
        tittle: 'Infor!',
        body: Container(
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    ' ${patients.profile.name} ',
                    style: TextStyle(
                      fontFamily: 'Title',
                      color: Colors.black,
                      fontSize: 20,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    ' ${patients.profile.gender}',
                    style: TextStyle(
                      fontFamily: 'Title',
                      color: Colors.black,
                      fontSize: 15,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(left: queryData.size.width/7),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.email),
                        Text(
                          ' ${patients.profile.email}',
                          style: TextStyle(
                            fontFamily: 'Title',
                            color: Colors.black,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Material(
                borderRadius: BorderRadius.circular(30),
                shadowColor: Colors.black,
                color: Colors.black,
                elevation: 7,
                child: GestureDetector(
                  onTap: () {
                    linkResponse = link(linkUrl, body: map);
                    linkResponse.then((value) {
                      print(value.msg);
                      print(value.code);
                        if (value.code == 1) {
                          prefs.setBool('link2', true);
                          layer++;
                          AwesomeDialog(
                              context: context,
                              animType: AnimType.LEFTSLIDE,
                              dialogType: DialogType.SUCCES,
                              tittle: 'Success!',
                              desc:
                              '     Congrats! You have new caregiver ${getUsername(caregiver)} with you now',
                              onDissmissCallback: () {
                                layer--;
                                debugPrint('Dialog Dissmiss from callback');
                              }).show();
                        } else {
                          prefs.setBool('linkState', false);
                          layer++;
                          AwesomeDialog(
                              context: context,
                              animType: AnimType.BOTTOMSLIDE,
                              dialogType: DialogType.ERROR,
                              tittle: 'OOPS!',
                              desc: 'This doctor is ' + value.msg,
                              onDissmissCallback: () {
                                layer--;
                                debugPrint('Dialog Dissmiss from callback');
                              }).show();
                        }
                    });
                    setState(() {});
                  },
                  child: Center(
                    child: Text('I want you',
                        style: TextStyle(
                          fontFamily: 'Title',
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
        onDissmissCallback: () {
          layer--;

          debugPrint('Dialog Dissmiss from callback');
//      Navigator.push(context, MaterialPageRoute(
//          builder: (_) => patient( '', '')
//      ));
        }).show();
  }

  String getUsername(String value) {
    int i = value.indexOf('@');
    return value.substring(0, i);
  }

  loadData() {
    PatientDao.fetch(url).then((PatientModel model) {
      setState(() {
        patientModel = model;
      });
    }).catchError((e, s) {
      print(e);
      print(s);
    });
  }

//  Future<List<PatientModel>> getCaregiver() async {
//    //TODO
//    final response = await http.get(url);
//    print("response code: ${response.statusCode}");
//    if (response.statusCode == 200) {
//      var result = json.decode(response.body); //response data
//      List results = result['Items'] as List;
//      print("results : $results");
//      List<PatientModel> shops = results
//          .map((model) => PatientModel.fromJson(model['Items']))
//          .toList(); //map json to dart object
//      //total = shops.length;
//      print("total items: ${shops.length}");
//      print(shops);
//      return shops;
//    } else {
//      throw Exception('failed connect');
//    }
//  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Find your caregiver'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        child: ListView.builder(
            //itemCount: patientModel?.patientItems?.length ?? 0,
            itemCount: 1,
            itemBuilder: (BuildContext context, int position) {
              //return _item(position);
              return _item(position);
            }),
      ),
    );
  }

  _item(int position) {
    if (patientModel == null || patientModel.patientItems == null) return null;
    Items patients = patientModel.patientItems[position];
    return Column(
      children: <Widget>[
        Container(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    child: Column(children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Material(
                        elevation: 28.0,
                        borderRadius: BorderRadius.circular(28.0),
                        shadowColor: Colors.black,
                        color: Colors.grey[300],
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                Icons.local_hospital,
                                color: Colors.green,
                              ),
                              SizedBox(
                                width: queryData.size.width / 15,
                              ),
                              GestureDetector(
                                child: Text('${patients.profile.name}',
                                    style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Title')),
                                onTap: () {
                                  _onSelected(position);
                                  _savePatient(position);
                                  _linkCaregiver(position);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );

//    return Container(
//      height: 50,
//      margin: EdgeInsets.only(left: 20, top: 1, bottom: 1, right: 20),
//      child: Container(
//        color: selectIndex != null && selectIndex == position ? Colors.blue : Colors.grey,
//        child: ListTile(
//            leading: new Icon(Icons.account_box, color: Colors.white,),
//            title: Text('${patients.profile.name}',
//              style: TextStyle(color: Colors.white, fontSize: 25),
//              textAlign: TextAlign.center,
//            ),
//            onTap: () {
//              _onSelected(position);
//              _savePatient(position);
//              _linkCaregiver(position);
//            }
//        ),
//      ),
//    );
  }

  _onSelected(int index) {
    setState(() => selectIndex = index);
  }

  _savePatient(int index) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String email = patientModel.patientItems[index].profile.email;
    int length = patientModel.patientItems[index].profile.email.length;
    int endIndex;
    for (var i = 0; i < length; i++) {
      if (email[i] == '@') {
        endIndex = i;
        break;
      }
    }
    Name = email.substring(0, endIndex);
    sp.setString('patient', Name);
  }

  Widget caregiverInfo(List<PatientModel> meals, int nb) {
    Items patients = patientModel.patientItems[nb];

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
              title: Text(' ${patients.profile.email} , ', style: TextStyle()),
            ),
          ),
        ),
      ),
    );
  }
}

class PatientDao {
  static Future<PatientModel> fetch(String url) async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      return PatientModel.fromJson(result);
    } else {
      throw Exception('failed connect');
    }
  }
}
