import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'dart:async' show Future;
import 'dart:convert';
import 'package:hotaal/userAuth.dart';
import 'package:ping_discover_network/ping_discover_network.dart';
import 'package:dio/dio.dart';

class qr extends StatefulWidget {
  @override
  _qrState createState() => _qrState();
}

class _qrState extends State<qr> {
  Future<dynamic> _barcodeString;
  Future<deviceResponse> deviceFuture;
  deviceResponse auth;
  String device; //device id
  String url;
  String res;
  String ipAdd;
  bool isFinished = false;

  void initState() {
    _barcodeString = Future.value("Click button to start registeration...");
    super.initState();
    scan();
  }
  void scan(){
    print('hhh');
    getIp();
    trigger_qrscan();
  }

  trigger_qrscan(){
    _barcodeString = new QRCodeReader()
        .setAutoFocusIntervalInMs(200)
        .setForceAutoFocus(true)
        .setTorchEnabled(true)
        .setHandlePermissions(true)
        .setExecuteAfterPermissionGranted(true)
    //.setFrontCamera(false)
        .scan();
    _barcodeString.then((val){
      final body = json.decode(val);
      device = body['device_uuid'];
      if(ipAdd!=null&&!isFinished){
        isFinished = true;
        heartbeat_call();
      }
    }).catchError((e){
      print('qrcode error');
    });
  }

  getIp() {
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
      }
    }).onDone(() {
      print('Finish. Found $found device(s)');
      if(device!=null&&!isFinished){
        isFinished = true;
        heartbeat_call();
      }
    });
  }
  heartbeat_call(){
    Dio dio = new Dio(); //Dio is http client
    dio.get( "http://$ipAdd:8000/" , options: Options(
      method: 'GET',
      responseType: ResponseType.plain,
    )).then((response) {
      print("response: $response");
      print(response.statusCode);
      if(response.statusCode == 200){
        print('success: $ipAdd');
        _devicesignup(context);
      }else
      {
      }
    }).catchError((error) => print("error: $error"));
  }
  void _devicesignup(BuildContext context){
    print('device $device');
    Map map = new Map<String, dynamic>();
    map["device"] = device;
    print(map.toString());
    Navigator.pop(context, device);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      if(res != null){
                        url = res['broker_healthcheck_url'];
                        device = res['device_uuid'];
                      }else{
                        Navigator.pop(context, null);
                      }
                      print("url: ");
                      print(url);
                      print("device: " );
                      print(device);
                      //return createView(context, snapshot);
                  return Container();
//                      return Padding(
//                        padding: const EdgeInsets.only(top: 100, left: 500),
//                        child: new ListView(
//                            children: <Widget>[
//                              //new Text(snapshot.data),
//                              Container(
//                                child: Text("Detected device is:  "
//                                    "$device"
//                                    "\nClick below to save this device...", style: TextStyle(
//                                  fontSize: 30,
//                                )),
//                              ),
//                              Padding(
//                                padding: const EdgeInsets.only(top: 80, right: 500),
//                                child: Container(
//                                    child: Column(
//                                      children: <Widget>[
//                                        FloatingActionButton(
//                                          heroTag: 1,
//                                          onPressed: (){
//                                            setState(() {
//                                              _devicesignup(context);
//                                            });
//                                          },
//                                          child: new Icon(Icons.cached),
//                                        ),
//                                      ],
//                                    )
//                                ),
//                              )
//                            ]
//                        ),
//                      );
                  }
                }
            )
        ),
      ),

//      floatingActionButton: Padding(
//        padding: EdgeInsets.only(top: 600, right: 600),
//        child:  Column(
//          children: <Widget>[
//            FloatingActionButton(
//                heroTag: "btn1",
//                onPressed: (){
//                  setState(() {
//                    _barcodeString = new QRCodeReader()
//                        .setAutoFocusIntervalInMs(200)
//                        .setForceAutoFocus(true)
//                        .setTorchEnabled(true)
//                        .setHandlePermissions(true)
//                        .setExecuteAfterPermissionGranted(true)
//                    //.setFrontCamera(false)
//                        .scan();
//                  });
//                  final body = json.decode(_barcodeString.toString());
//                  device = body['device_uuid'];
//                },
//                child: new Icon(Icons.add_a_photo)
//            ),
//          ],
//        ),
//      ),
    );
  }
}

