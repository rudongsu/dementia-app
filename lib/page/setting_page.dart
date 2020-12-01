import 'package:flutter/material.dart';
import 'package:hotaal/page/nutritionTarget_page.dart';
import 'package:hotaal/page/patient_page.dart';

const Setting_Name = ['   profile', '   general', '   patient', '   nutrition', '   feedback', '   terms of service',
  '   version'];
var Image_Path = 'https://www.eguardtech.com/wp-content/uploads/2018/08/Network-Profile.png';

/// caregiver
class SettingPage extends StatefulWidget{
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage>{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListView(
          children: <Widget> [
          Image.network(Image_Path, width: 200, height: 200),
            Column(
            children:
            _buildList(),
            )
          ]
        )
      ),
    );
  }
  List<Widget> _buildList() {
    return Setting_Name.map((setting) => _item(setting)).toList();
  }

  Widget _item(String setting){
    if (setting == '   patient') {
      return GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => PatientPage()));
          },
          child: Container(
              height: 50,
              margin: EdgeInsets.only(bottom: 1),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(color: Colors.grey),
              child: ListTile(
                title: Text(
                  setting, style: TextStyle(color: Colors.white, fontSize: 25),),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
              )
          ),
      );
    }else if(setting == '   nutrition'){
      return GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => NutritionTargetPage()));
        },
        child: Container(
            height: 50,
            margin: EdgeInsets.only(bottom: 1),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(color: Colors.grey),
            child: ListTile(
              title: Text(
                setting, style: TextStyle(color: Colors.white, fontSize: 25),),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
            )
        ),
      );
    } else {
      return Container(
          height: 50,
          margin: EdgeInsets.only(bottom: 1),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(color: Colors.grey),
          child: ListTile(
            title: Text(
              setting, style: TextStyle(color: Colors.white, fontSize: 25),),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
          )
      );
    }
  }
}
