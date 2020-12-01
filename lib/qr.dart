import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'dart:async' show Future;
import 'dart:convert';
import 'userAuth.dart';

class MyApp extends StatelessWidget {
  //MyApp(this.device);
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'QRCode Reader',
      home: new qrscan(),
    );
  }
}

class qrscan extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<qrscan> {
  Future<String> _barcodeString;
/*
  @override
  void initState() {
    _barcodeString = Future.value("Click button to start registeration...");
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    super.dispose();
  }
*/

  bool _isButtonDisabled;
  Future<deviceResponse> deviceFuture;
  deviceResponse auth;

  void _devicesignup(BuildContext context){
    Map map = new Map<String, dynamic>();
    map["device"] = device;
    String textToSendBack = device;

    print(map.toString());
    Navigator.pop(context, textToSendBack);

//    deviceFuture = deviceGet(url);
//    deviceFuture.then((value){
//      auth = value;
//      if (auth.code2 == 1){
//        succPopup(context);
//
//      }
//      else
//        {
//          errorPopup(context);
//        }
//      Navigator.pop(context, textToSendBack);
//
//
//    });

    print("here");
  }

  void succPopup(BuildContext context){
    var popup = AlertDialog(content: Text("Congras! $device device is ready... Go back to finish signup..  "));
    showDialog(context: context,
        builder: (BuildContext context){
          return popup;
        });
  }

  void errorPopup(BuildContext context){
    var popup = AlertDialog(content: Text("Something wrong!"));
    showDialog(context: context,
        builder: (BuildContext context){
          return popup;
        });
  }

  // get the device and send it back to the FirstScreen
//  void _sendDataBack(BuildContext context) {
//    String textToSendBack = device;
//    Navigator.pop(context, textToSendBack);
//    print("here");
//  }

  String device; //device id
  String url;
  String res;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(

      body: Padding(
        padding: EdgeInsets.only(top: 100, ),
        child: new Center(
            child: new FutureBuilder<String>(
                future: _barcodeString,
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return new Text('Use Camera...', style: TextStyle(
                        fontSize: 25
                      ),);
                    case ConnectionState.waiting:
                      return new Text('loading camera...', style: TextStyle(
                          fontSize: 25
                      ));
                    default:
                      if (snapshot.hasError)
                        return new Text('Error: ${snapshot.error}');
                      else
                        print(snapshot.data);
                      //device = snapshot.data.substring(17, 23);
                      final res = json.decode(snapshot.data.toString());
                      url = res['broker_healthcheck_url'];
                      device = res['device_uuid'];
                      print("url: ");
                      print(url);
                      print("device: " );
                      print(device);
                        //return createView(context, snapshot);
                        return Padding(
                          padding: const EdgeInsets.only(top: 100, left: 500),
                          child: new ListView(
                            children: <Widget>[
                              //new Text(snapshot.data),
                              Container(
                                child: Text("Detected device is:  "
                                    "$device"
                                "\nClick below to save this device...", style: TextStyle(
                                    fontSize: 30,

                                )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 80, right: 500),
                                child: Container(
                                  child: Column(
                                    children: <Widget>[
                                        FloatingActionButton(
                                          heroTag: 1,
                                          onPressed: (){
                                            setState(() {
                                              _devicesignup(context);
                                            });
                                          },
                                         child: new Icon(Icons.cached),
                                      ),
//                                      FloatingActionButton(
//                                        child: new Icon(Icons.last_page),
//                                        heroTag: 2,
//                                        onPressed: (){
//                                          setState(() {
//                                            //Navigator.pop(context, device);
//                                            //_sendDataBack(context);
//                                            print("???");
//                                          });
//                                        },
//                                      )
                                    ],
                                  )
                                ),
                              )
                            ]
                          ),
                        );
                  }
                }
            )
        ),
      ),

      floatingActionButton: Padding(
        padding: EdgeInsets.only(top: 600, right: 600),
        child:  Column(
          children: <Widget>[
             FloatingActionButton(
              heroTag: "btn1",
              onPressed: (){
                setState(() {
                  _barcodeString = new QRCodeReader()
                      .setAutoFocusIntervalInMs(200)
                      .setForceAutoFocus(true)
                      .setTorchEnabled(true)
                      .setHandlePermissions(true)
                      .setExecuteAfterPermissionGranted(true)
                      //.setFrontCamera(false)
                      .scan();
                });
                final body = json.decode(_barcodeString.toString());
                device = body['device_uuid'];
              },
            child: new Icon(Icons.add_a_photo)
      ),
          ],
        ),
      ),
    );
  }
}

/*
// to be created after scan
Widget createView(BuildContext context, AsyncSnapshot snapshot){
  var now = new DateTime.now();
  return new Column(
    //body: new Center(
      //child: ListView(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(top: 200, right: 200),
              child: Container(
                child: Text(snapshot.data, style: TextStyle(fontSize: 30),),
              )
          ),
          FloatingActionButton(
            //heroTag: "btn2",
            onPressed: () {
              print( DateFormat("dd-MM-yyyy").format(now));
            },
            child: new Icon(Icons.backup),
          ),
        ],
      //),
    //),
  );
}
*/
