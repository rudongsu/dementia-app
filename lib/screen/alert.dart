import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hotaal/notification_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Alert extends StatefulWidget {
  @override
  _AlertState createState() => _AlertState();
}

class _AlertState extends State<Alert> {
  String notifUrl =
      "https://ylr9w8c0q2.execute-api.us-east-1.amazonaws.com/v0/notification";
  List<String> userPref;
  String usernameStored;
  int total;
  MediaQueryData queryData;

  @override
  void initState() {
    super.initState();
    _getPref();
  }

  Future<List<Notifications>> getAlert(String query) async {
    //TODO
    if (query == "") {}
    final response = await http.get(notifUrl + '?user=' + query);
    if (response.statusCode == 200) {
      print("connected");
      var result = json.decode(response.body); //response data
      List results = result['Items'] as List;
      print("results : $results");
      List<Notifications> notifications = results
          .map((model) => Notifications.fromJson(model['content']))
          .toList(); //map json to dart object
      total = notifications.length;
      print("total items: ${notifications.length}");
      print(notifications);
      return notifications;
    } else {
      throw Exception('failed connect');
    }
  }

  void _getPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getStringList('userCredentials'));
    if (prefs.containsKey('userCredentials')) {
      setState(() {
        userPref = prefs.getStringList('userCredentials');
        usernameStored = userPref[userPref.length - 1];
      });
      print('username pref list is $userPref');
      print('usernameStored now: $usernameStored');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: new Text(
          'Nofitications',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: FutureBuilder(
          future: getAlert(usernameStored),

          builder: (context, snapshot) {
            return snapshot.data != null
                ? listViewWidget(snapshot.data, snapshot.data)
                : Center(child: CircularProgressIndicator());
          }),
    );
  }

  Widget listViewWidget(List<Notifications> title, List<Notifications> body) {
    queryData = MediaQuery.of(context);
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            color: Colors.grey[200],
            child: ListView.separated(
                separatorBuilder: (context, index) => Divider(
                    color: Colors.white,
                  ),
                itemCount: total,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Stack(
                        children: <Widget>[
                          Container(
                            child: Column(
                              children: <Widget>[
                                Material(
                                  elevation: 30,
                                  borderRadius: BorderRadius.circular(28.0),
                                  shadowColor: Colors.black,
                                  color: Colors.grey[300],
                                  child: Padding(
                                      padding: EdgeInsets.only(left: queryData.size.width/20),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Icon(Icons.sim_card_alert),
                                              Text('${title[index].title}', style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Title'
                                              ),),
                                            ],
                                          ),
                                          Text('${title[index].body}', style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.red,
                                              fontWeight: FontWeight.normal,
                                              fontFamily: 'Title'
                                          ),),
                                        ],
                                      ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
          ),
        )
      ],
    );
  }
}
