// achieved alert function in week 7

import 'package:flutter/material.dart';
import 'package:hotaal/dao/alert_dao.dart';
import 'package:hotaal/model/alert_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// caregiver
class AlertPage extends StatefulWidget{
  @override
  _AlertPageState createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {
  AlertModel alertModel;
  String url = 'https://ylr9w8c0q2.execute-api.us-east-1.amazonaws.com/v0/notification?user=';
  String username;

  @override
  void initState() {
    super.initState();
    _patientName();
  }

  Future<AlertModel> loadData() async {
    await AlertDao.fetch(url + 'rudongsu@gmail.com').then((AlertModel model) {
      alertModel = model;
    });
    return alertModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: Text('Notification', style: TextStyle(color: Colors.grey)),
      ),
      body: FutureBuilder(
          future: loadData(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting)
              return Center(
                child: CircularProgressIndicator(),
              );
            if (snapshot.hasData && alertModel != null) {
              return ListView.builder(
                  key: Key(UniqueKey().toString()),
                  itemCount: alertModel.alerts.length,
                  itemBuilder: (context, index) {
                    return _alert(index);
                  });
            } else {
              return Text('loading...');
            }
          }
      ),
    );
  }

  _alert(int position) {
    if (alertModel == null || alertModel.alerts == null) return null;
    Items alerts = alertModel.alerts[position];
    return Container(
        padding: EdgeInsets.all(10),
        child: ListTile(
          leading: Icon(Icons.notification_important, size: 40, color: Colors.blue),
          title: Text('${alerts.content.title}', style: TextStyle(fontWeight: FontWeight.bold),),
          subtitle: Text('${alerts.content.body}'),
          trailing: Column(
            children: <Widget>[
              Text('${DateTime.fromMillisecondsSinceEpoch((alerts.timestamp*1000).toInt()).toString().substring(0, 10)}'),
              Text('${DateTime.fromMillisecondsSinceEpoch((alerts.timestamp*1000).toInt()).toString().substring(11, 16)}'),
            ],
          ),
        )
    );
  }

  _patientName() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    username = sp.getString('patient');
  }
}
