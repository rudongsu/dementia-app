import 'dart:async';
import 'dart:io';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:hotaal/barcodeRest.dart';
import 'package:ping_discover_network/ping_discover_network.dart';

class BarCode extends StatefulWidget {
  @override
  _BarCodeState createState() => new _BarCodeState();
}

class _BarCodeState extends State<BarCode> {
  String barcode = "";
  String storeUrl = "http://HOTAALUOA:8000/groceries/store/";
  String consumeUrl = "http://HOTAALUOA:8000/groceries/consume/";
  MediaQueryData querydata;
  bool colorChange = false;
  Future<consumeResponse> consumeFuture;
  consumeResponse auth1;
  String ipAdd;

  @override
  initState() {
    super.initState();
    barcodeScanning();
  }

  void _consume(){
    Map map = new Map<String, dynamic>();
    consumeFuture = consumePost(consumeUrl + barcode, body: map);
    consumeFuture.then((value){
      auth1 = value;
      print(auth1.code);
    });
  }

  consume() {
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
      Dio dio = new Dio(); //Dio is http client
      print("http://$ipAdd:8000/groceries/consume/" + barcode);
      dio.post("http://$ipAdd:8000/groceries/consume/" + barcode, options: Options(
        method: 'POST',
        responseType: ResponseType.plain,
      )).then((response) {
        print("response: $response");
        print(response.statusCode);
        if(response.statusCode == 200){
          successPopup(context);
        }else
        {
          failPopup(context);
        }
        setState(() {
          colorChange = true;
        });
      }).catchError((error) => print("error: $error"));
    });

  }

  store() {
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
      Dio dio = new Dio(); //Dio is http client
      dio.post( "http://$ipAdd:8000/groceries/store/" + barcode, options: Options(
        method: 'POST',
        responseType: ResponseType.plain,
      )).then((response) {
        print("response: $response");
        print(response.statusCode);
        if(response.statusCode == 200){
          successPopup(context);
        }else
        {
          failPopup(context);
        }
      }).catchError((error) => print("error: $error"));
    });

  }

  void successPopup(BuildContext context){
    var popup = AlertDialog(content: Text("Uploaded successfully!"));
    showDialog(context: context,
        builder: (BuildContext context){
          return popup;
        });
  }

  void failPopup(BuildContext context){
    var popup = AlertDialog(content: Text("Uploaded failed!"));
    showDialog(context: context,
        builder: (BuildContext context){
          return popup;
        });
  }

  @override
  Widget build(BuildContext context) {
    querydata = MediaQuery.of(context);
    return Scaffold(
          appBar: new AppBar(
            title: new Text('Read barcode', style: TextStyle(
                fontWeight: FontWeight.w700
            ),),
            backgroundColor: Colors.black,
          ),
          body: new Center(
            child: new Column(
              children: <Widget>[

                SizedBox(height: querydata.size.height/5,),

                new Text("Barcode Number Scanned : \n" , style: TextStyle(
                  fontSize: 16
                ),),
                SizedBox(height: querydata.size.height/20,),

                new Text(barcode , style: TextStyle(
                    fontSize: 26
                ),),
                SizedBox(height: querydata.size.height/5  ,),

                Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only( right: querydata.size.width/6, left: querydata.size.width/6),
                      height: querydata.size.height/15,
                      child: Material(
                        borderRadius: BorderRadius.circular(30),
                        shadowColor: Colors.greenAccent,
                        color: colorChange? Colors.lightGreen : Colors.green,
                        elevation: 7,
                        child: GestureDetector(
                          onTapDown: (detail){
                            setState(() {
                              colorChange = true;
                            });
                          },
                          onTapUp: (detail){
                            setState(() {
                              colorChange = false;
                            });
                          },
                          onTap: store,
                          child: Center(
                            child: Text(
                                'Store',
                                style: TextStyle(
                                  fontFamily: 'Title',
                                  color:  Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                )
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: querydata.size.height/20,),

                    Container(
                      padding: EdgeInsets.only( right: querydata.size.width/6, left: querydata.size.width/6),
                      height: querydata.size.height/15,
                      child: Material(
                        borderRadius: BorderRadius.circular(30),
                        shadowColor: Colors.greenAccent,
                        color:  Colors.lightGreen,
                        elevation: 7,
                        child: GestureDetector(
                          onTap: consume,
                          child: Center(
                            child: Text(
                                'Eat',
                                style: TextStyle(
                                  fontFamily: 'Title',
                                  color:  Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                )
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ));
  }

  Future barcodeScanning() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'No camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode = 'Nothing captured!');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}
