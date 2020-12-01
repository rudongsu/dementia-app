import 'dart:async';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hotaal/uploadImage.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as Path;
import 'dart:typed_data';
import 'dart:convert';
//Uri.encodeComponent();
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class cameraScreen extends StatefulWidget{
  @override
  _cameraScreenState createState() => _cameraScreenState();
}

class _cameraScreenState extends State<cameraScreen>{
  File imageFile;
  String imgUrl = "https://ylr9w8c0q2.execute-api.us-east-1.amazonaws.com/v0/hotaalimages/su";
  String msgBoxUrl = "https://ylr9w8c0q2.execute-api.us-east-1.amazonaws.com/v0/message";
  Future<uploadImageResponse> authFuture;
  uploadImageResponse auth;
  List <String> userPref = [];
  MediaQueryData queryData;
  String group;
  String meal;
  List <String> meals = [];
  List <String> newMeals = [];
  String _selectedMeal;
  String ipAdd;
  void initState(){
    super.initState();
    getMealName();
    getIp();
    _openCamera(context);
  }

  getIp() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('IP')!= null){
      ipAdd = prefs.getString('IP');
      print('ip add: $ipAdd');
    }
  }

  getMealName() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getStringList('meal3') != null){
      meals = prefs.getStringList('meal3');
      print("meals pref: $meals");
      newMeals = meals.toSet().toList();
      print('newmeals: $newMeals');
      //meal = Uri.encodeComponent(meals[meals.length-1]);
      //print('meal: encode: $meal ');
    }
  }

  callHeartBeat(){
    if(_selectedMeal != null){
      successPopup();
      meal = Uri.encodeComponent(_selectedMeal);
      print('meal: encode: $meal ');
      http.post('http://$ipAdd:8000/meal/consume/$_selectedMeal' , body: null).then((http.Response response){
        print('respons heartbeat ${response.statusCode}');
      });
    }else{
      failPopup(context);
    }
  }

  bool colorChange = false;
  final GlobalKey _scaffoldKey = GlobalKey();

  _openGallery(BuildContext context)async {
    var pic = await ImagePicker.pickImage(source: ImageSource.gallery,imageQuality: 50, maxHeight: 400, maxWidth: 480);
    this.setState(
            (){
          imageFile = pic;
        }
    );
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async{
    var pic = await ImagePicker.pickImage(source: ImageSource.camera,imageQuality: 50, maxHeight: 400, maxWidth: 480);
    this.setState(
            (){
          imageFile = pic;
        }
    );
  }

  Future<void> _dialog(BuildContext context){
    return showDialog(context: context , builder: (BuildContext context){
      return AlertDialog(
        title: Text("Upload images from"),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              GestureDetector(
                child: Text("Gallery"),
                onTap: (){
                  _openGallery(context);
                },
              ),
              Padding(
                padding: EdgeInsets.all(7),
              ),
              GestureDetector(
                child: Text("Camera"),
                onTap: (){
                  _openCamera(context);
                },
              )
            ],
          ),
        ),
      );
    });
  }

  String getFileType(String value){
    int i =value.indexOf('.');
    return value.substring(i+1, value.length);
  }

  UploadFile() async{
//    Dio dio = new Dio(); //Dio is http client
//    FormData formdata = new FormData();
//    formdata.add("photos1", new UploadFileInfo(imageFile, Path.basename(imageFile.path)));
//    print("image : $imageFile");
    String imageType = getFileType(Path.basename(imageFile.path));
    print(imageType);
    http.put(
        imgUrl + ".$imageType",
      headers: {
        "Content-Type":"image/$imageType"
      },
      body:(imageFile.readAsBytesSync() as Uint8List),
    ).then((response) {
      print("response: $response");
      print(response.statusCode);
      if(response.statusCode == 200){
        callHeartBeat();
        print("ok");
        callMsgBox();
        callHeartBeat();
      }else
      {
        failPopup(context);
      }
    })
        .catchError((error) => print("error: $error"));
//    dio.put(imgUrl + ".$imageType", data: (imageFile.readAsBytesSync() as Uint8List).buffer, options: Options(
//        method: 'PUT',
//        contentType:ContentType.binary,
//        responseType: ResponseType.plain,
//        headers: {
//          "Content-Type":"image/$imageType"
//        }
//    ))
//        .then((response) {
//        print("response: $response");
//        print(response.statusCode);
//        if(response.statusCode == 200){
//          print("ok");
//          successPopup(context);
//        }else
//          {
//            failPopup(context);
//          }
//    })
//        .catchError((error) => print("error: $error"));
  }

  callMsgBox() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String imageType = getFileType(Path.basename(imageFile.path));
    String msg = 'I have finished this meal';
    Map map = new Map<String, dynamic>();
    map["img"] = imgUrl + ".$imageType";
    map["group"] = 'HOTAALUOA';
    map["name"] = 'rudong';
    map["message"] = msg;
    http.post(msgBoxUrl,
        body: utf8.encode(json.encode(map)))
        .then((http.Response response){
    final int statusCode = response.statusCode;
    print('call msgbox return code: $statusCode');
    });
  }

  String getUsername(String value) {
    int i = value.indexOf('@');
    return value.substring(0, i);
  }
  
  ReadFile() async{
    Dio dio1 = new Dio(); //Dio is http client
    dio1.get(imgUrl, options: Options(
        method: 'GET',
        responseType: ResponseType.plain,
        headers: {
          "Content-Type":"image/jpg"
        }
    ))
        .then((response) =>
        print("response: $response"))
        .catchError((error) => print("error: $error"));
  }

  void successPopup(){
    AwesomeDialog(
        context: context,
        animType: AnimType.LEFTSLIDE,
        dialogType: DialogType.SUCCES,
        tittle: 'Success!',
        desc:
        'Just uploaded',
        onDissmissCallback: () {
          debugPrint('Dialog Dissmiss from callback');
        }).show();
  }

  void failPopup(BuildContext context){
    AwesomeDialog(
        context: context,
        animType: AnimType.LEFTSLIDE,
        dialogType: DialogType.ERROR,
        tittle: 'OOPS!',
        desc:
        'Something is wrong!',
        onDissmissCallback: () {
          debugPrint('Dialog Dissmiss from callback');
        }).show();
  }

  @override
  Widget build(BuildContext context){
    queryData = MediaQuery.of(context);
    return Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text('Upload my food', style: TextStyle(
              fontWeight: FontWeight.w700
          ),),
          backgroundColor: Colors.black,
        ),
        body: Container(
          color: Colors.grey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Center(
                  child: imageFile == null
                  ? new Text('no image')
                      :  Image.file(imageFile, width: queryData.size.width/2, height: queryData.size.height/3,)
                ),

                  Container(
                    width: queryData.size.width*0.9,
                    height: queryData.size.height*0.1,
                    child: DropdownButton<String>(
                      value: _selectedMeal,
                        isExpanded: true,
                        underline: Container(
                          color: Colors.black,
                          height: 1,
                        ),
                        icon: Icon(Icons.arrow_drop_down_circle, color: Colors.black38,),
                        hint: Text('What is the food on this image?' , style: TextStyle(
                          fontSize: 21,
                          color: Colors.white,
                          backgroundColor: Colors.black
                        ),),
                        items: newMeals.map((String value){
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value, style: TextStyle(
                              fontSize: 20
                            ),),
                          );
                        }).toList(),
                        onChanged: (T){
                          setState(() {
                            _selectedMeal = T;
                            print(_selectedMeal);
                          });
                        }),
                  ),

                Column(
                  children: <Widget>[
                    GestureDetector(
                        child: Container(
                          width: queryData.size.width/2,
                          //padding: EdgeInsets.only( right: data.size.width/3, left: data.size.width/3),
                          decoration: BoxDecoration(
                              color: Colors.grey[850],
                              borderRadius: BorderRadius.circular(30)
                          ),
                          child: Row(
                            children: <Widget>[
                              Container(
                                child: Row(
                                    children: <Widget>[
                                      Material(color: Colors.green,
                                          shape: CircleBorder(),
                                          child: Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Icon(Icons.cloud_upload, color: Colors.white, size: 35,),
                                          )),
                                      SizedBox(width: 15,),
                                      Text('Upload',
                                        style: TextStyle(
                                            fontSize: 26,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Title'
                                        ),
                                      ),
                                    ]
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Icon(Icons.arrow_upward, color: Colors.grey[600], size: 35,),
                              )
                            ],
                          ),
                        ),
                        onTap: (){
                          setState(() {
                            print("upload clicked");
                            UploadFile();
                            ReadFile();
                          });
                        }
                    ),
                    SizedBox(height: 20,),
                    GestureDetector(
                        child: Container(
                          width: queryData.size.width/2,
                          //padding: EdgeInsets.only( right: data.size.width/3, left: data.size.width/3),
                          decoration: BoxDecoration(
                              color: Colors.grey[850],
                              borderRadius: BorderRadius.circular(30)
                          ),
                          child: Row(
                            children: <Widget>[
                              Container(
                                child: Row(
                                    children: <Widget>[
                                      Material(color: Colors.red,
                                          shape: CircleBorder(),
                                          child: Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Icon(Icons.error_outline, color: Colors.white, size: 35,),
                                          )),
                                      SizedBox(width: 20,),
                                      Text('New',
                                        style: TextStyle(
                                            fontSize: 26,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Title'
                                        ),
                                      ),
                                    ]
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 40),
                                child: Icon(Icons.repeat, color: Colors.grey[600], size: 35,),
                              )
                            ],
                          ),
                        ),
                        onTap: (){
                          setState(() {
                            _dialog(context);
                          });
                        }
                    ),

                  ],
                ),
              ],
            ),
          ),
        )
    );
  }
}
