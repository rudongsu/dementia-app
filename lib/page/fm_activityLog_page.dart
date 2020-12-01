import 'package:flutter/material.dart';
import 'package:flutter_calendar/flutter_calendar.dart';
import 'package:hotaal/dao/activity_dao.dart';
import 'package:hotaal/model/activityLog_model.dart';

/// caregiver
class FMActivityPage extends StatefulWidget {
  @override
  _FMActivityPageState createState() => _FMActivityPageState();
}

class _FMActivityPageState extends State<FMActivityPage> {
  List<String> list = new List<String>(20);
  ActivityLogModel activityLogModel;
  bool event = false;
  int itemLength = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    ActivityLogDao.fetch().then((ActivityLogModel model) {
      setState(() {
        activityLogModel = model;
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (activityLogModel == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: 2.0,
              vertical: 10.0,
            ),
            child: Column(
              children: <Widget>[
                Calendar(
                  onDateSelected: (date) {
                    handleNewDate(date);
                    setState(() {});
                  },
                ),
                Divider(
                  height: 50.0,
                ),
                !event
                    ? Container(
                    child: Column(
                      children: <Widget>[_buildOneTimeLine('no events')],
                    ))
                    :
                Container(
                  height: 500,
                  child: ListView.builder(
                      itemCount: itemLength,
                      itemBuilder: (BuildContext context, int position) {
                        return _buildTimeLine(position);
                      }),
                )
              ],
            ),
          ),
        ),
      );
    }
  }

  /// handle new date selected event
  void handleNewDate(date) {
    event = false;
    for (var i = 0; i < activityLogModel.items.length; i++) {
      int length = 0;
      if (getDate(activityLogModel.items[i].timestampLocal) ==
          date.toString().substring(0, 10)) {
        for (var j = 0; j < activityLogModel.items[i].devices.length; j++) {
          for (var u = 0;
          u < activityLogModel.items[i].devices[j].usages.length;
          u++) {
            list[u + length] = activityLogModel.items[i].devices[j].usages[u] +
                ' open ' +
                activityLogModel.items[i].devices[j].deviceName;
          }
          length += activityLogModel.items[i].devices[j].usages.length;
        }
        for (var e = 1; e < length; e++) {
          for (var E = 0; E < length - e; E++) {
            if (getInt(list[E]) > getInt(list[E + 1])) {
              var temp = list[E];
              list[E] = list[E + 1];
              list[E + 1] = temp;
            }
          }
        }
        itemLength = length;
        event = true;
      }
    }
  }

  Widget _buildTimeLine(int index) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 50.0),
          child: Card(
            margin: EdgeInsets.all(20.0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              width: double.infinity,
              child: Text(list[index],
                style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        Positioned(
          top: 0.0,
          bottom: 0.0,
          left: 35.0,
          child: Container(
            height: double.infinity,
            width: 5.0,
            color: Colors.grey,
          ),
        ),
        Positioned(
          top: 21.0,
          left: 21.5,
          child: Container(
            margin: EdgeInsets.all(3.0),
            height: 26.0,
            width: 26.0,
            decoration:
            BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
          ),
        )
      ],
    );
  }

  Widget _buildOneTimeLine(String message) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 50.0),
          child: Card(
            margin: EdgeInsets.all(20.0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              width: double.infinity,
              child: Text(message,
                style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        Positioned(
          top: 0.0,
          bottom: 0.0,
          left: 35.0,
          child: Container(
            height: double.infinity,
            width: 5.0,
            color: Colors.grey,
          ),
        ),
        Positioned(
          top: 21.0,
          left: 21.5,
          child: Container(
            margin: EdgeInsets.all(3.0),
            height: 26.0,
            width: 26.0,
            decoration:
            BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
          ),
        )
      ],
    );
  }

  static int getInt(String str) {
    int res;
    res = int.parse(str.substring(0, 2) + str.substring(3, 5));
    return res;
  }

  static String getDate(String date) {
    String res = '';
    String d, m, y;
    d = date.substring(0, 2);
    m = getMonth(date.substring(3, 6));
    y = date.substring(7, 11);
    res = y + '-' + m + '-' + d;
    print(res);
    return res;
  }

  static String getMonth(String month) {
    String m = '';
    switch (month) {
      case 'Jan':
        m = '01';
        break;
      case 'Feb':
        m = '02';
        break;
      case 'Mar':
        m = '03';
        break;
      case 'Apr':
        m = '04';
        break;
      case 'May':
        m = '05';
        break;
      case 'Jun':
        m = '06';
        break;
      case 'Jul':
        m = '07';
        break;
      case 'Aug':
        m = '08';
        break;
      case 'Sep':
        m = '09';
        break;
      case 'Oct':
        m = '10';
        break;
      case 'Nov':
        m = '11';
        break;
      case 'Dec':
        m = '12';
        break;
    }
    return m;
  }
}
