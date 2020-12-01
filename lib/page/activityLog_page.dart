import 'package:flutter/material.dart';
import 'package:flutter_calendar/flutter_calendar.dart';
import 'package:hotaal/dao/activity_dao.dart';
import 'package:hotaal/dao/message_dao.dart';
import 'package:hotaal/model/activityLog_model.dart';
import 'package:hotaal/model/message_model.dart';

/// caregiver
class ActivityPage extends StatefulWidget {
  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  TextEditingController _controller = TextEditingController();
  List<String> list = new List<String>(20);
  ActivityLogModel activityLogModel;
  MessageModel messageModel;
  bool event = false;
  bool message = false;
  int itemLength = 0;
  String hour = '';
  String imageUrl;
  String note;
  String url =
      'https://ylr9w8c0q2.execute-api.us-east-1.amazonaws.com/v0/message?group=HOTAALUOA';

  @override
  void initState() {
    super.initState();
    loadData();
    loadMsg();
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

  loadMsg() async {
    MessageDao.fetch(url).then((MessageModel model) {
      setState(() {
        messageModel = model;
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (activityLogModel == null || messageModel == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.grey,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title:
          Text('weekly activity log', style: TextStyle(color: Colors.grey)),
        ),
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
                    ? !message
                    ? Container(
                    child: Column(
                      children: <Widget>[_buildOneTimeLine('no events')],
                    ))
                    : Container(
                    child: Column(
                      children: <Widget>[
                        _buildOneTimeLine('no activitys')
                      ],
                    ))
                    : Container(
                  height: 500,
                  child: ListView.builder(
                      itemCount: itemLength,
                      itemBuilder: (BuildContext context, int position) {
                        return _buildTimeLine(position);
                      }),
                ),
                message ? _buildMsgLine(imageUrl) : Container(),
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
    message = false;
    for (var i = 0; i < activityLogModel.items.length; i++) {
      int length = 0;
      if (getDate(activityLogModel.items[i].timestampLocal) ==
          date.toString().substring(0, 10)) {
        for (var j = 0; j < activityLogModel.items[i].devices.length; j++) {
          for (var u = 0;
          u < activityLogModel.items[i].devices[j].usages.length;
          u++) {
            list[u + length] = activityLogModel.items[i].devices[j].usages[u] +
                '      uses ' +
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

    String timestemp = DateTime.fromMillisecondsSinceEpoch(
        (messageModel.items[0].timestamp * 1000).toInt())
        .toString();
    for (var i = 0; i < messageModel.items.length; i++) {
      if (messageModel.items[i].image != null) {
        hour = timestemp.substring(11, 16);
        String day = timestemp.substring(0, 10);
        if (day == date.toString().substring(0, 10)) {
//          if(list != null){
//            for(var j = 0; j < itemLength; j++){
//              if(getInt(list[j]) > getInt(hour)){
//                list.insert(j, hour + messageModel.items[i].image[0]);
//              }
//            }
//          }else{
//            list.add(hour + messageModel.items[i].image[0]);
//          }
          imageUrl = messageModel.items[i].image[0];
          message = true;
        }
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
              child: Text(
                list[index],
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
              child: Text(
                message,
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

//  Widget _buildMsgLine(url) {
//    return Stack(
//      children: <Widget>[
//        Padding(
//          padding: const EdgeInsets.only(left: 50.0),
//          child: Card(
//            margin: EdgeInsets.all(20.0),
//            child: Container(
//              child: Row(
//                children: <Widget>[
//                  Text(hour,
//                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
//                  Image.network(
//                    url,
//                    height: 200,
//                    width: 200,
//                    alignment: Alignment.center,
//                  ),
//                ],
//              )
//            ),
//          ),
//        ),
//        Positioned(
//          top: 0.0,
//          bottom: 0.0,
//          left: 35.0,
//          child: Container(
//            height: double.infinity,
//            width: 5.0,
//            color: Colors.grey,
//          ),
//        ),
//        Positioned(
//          top: 100.0,
//          left: 21.5,
//          child: Container(
//            margin: EdgeInsets.all(3.0),
//            height: 26.0,
//            width: 26.0,
//            decoration:
//                BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
//          ),
//        )
//      ],
//    );
//  }

  Widget _buildMsgLine(url) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 50.0),
          child: Container(
            margin: EdgeInsets.all(20.0),
            child: ListTile(
              leading: Text(
                hour,
                style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              title: Image.network(
                url,
                height: 160,
                alignment: Alignment.centerLeft,
              ),
              trailing: Text(note == null ? '' : note,
                  style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              onTap: () {
                return showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, state) {
                        return AlertDialog(
                          title: Text('please input note: '),
                          content: Card(
                            elevation: 0.0,
                            child: Column(
                              children: <Widget>[
                                TextField(
                                    maxLines: 6,
                                    controller: _controller,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(30),
                                        ),
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          width: 1,
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('cancel'),
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                                note = _controller.text;
                                setState(() {});
                              },
                              child: Text('confirm'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
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
          top: 80.0,
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
