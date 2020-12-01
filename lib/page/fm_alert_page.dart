import 'package:flutter/material.dart';
import 'package:hotaal/dao/alert_dao.dart';
import 'package:hotaal/model/alert_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// caregiver
class FMAlertPage extends StatefulWidget{
  @override
  _FMAlertPageState createState() => _FMAlertPageState();
}

class _FMAlertPageState extends State<FMAlertPage> {
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
        leading: Icon(Icons.notification_important, size: 25, color: Colors.blue),
        title: Text('${alerts.content.title}'),
        subtitle: Text('${alerts.content.body}'),
        trailing: Text('${DateTime.fromMillisecondsSinceEpoch(alerts.timestamp.toInt()).toString().substring(0, 16)}'),
      )
    );
  }

  _patientName() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    username = sp.getString('patientForfm');
  }
}
