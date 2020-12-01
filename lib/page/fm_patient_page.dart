import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotaal/dao/patient_dao.dart';
import 'package:hotaal/model/patient_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// caregiver
class FMPatientPage extends StatefulWidget {
  @override
  _FMPatientPageState createState() => _FMPatientPageState();
}

class _FMPatientPageState extends State<FMPatientPage> {
  PatientModel patientModel;
  int selectIndex;
  String patientName;
  String url =
      'https://ylr9w8c0q2.execute-api.us-east-1.amazonaws.com/v0/lookupusers?role=patient';

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    PatientDao.fetch(url).then((PatientModel model) {
      setState(() {
        patientModel = model;
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
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
          title: Text('     patient', style: TextStyle(color: Colors.grey, fontSize: 25)),
        ),
        body: Center(
          child: ListView.builder(
              itemCount: patientModel?.patientItems?.length ?? 0,
              itemBuilder: (BuildContext context, int position) {
                return _item(position);
              }),
        ));
  }

  _item(int position) {
    if (patientModel == null || patientModel.patientItems == null) return null;
    Items patients = patientModel.patientItems[position];
    return Container(
      height: 50,
      margin: EdgeInsets.only(left: 20, top: 1, bottom: 1, right: 20),
      child: Container(
        color: selectIndex != null && selectIndex == position ? Colors.blue : Colors.grey,
        child: ListTile(
          leading: new Icon(Icons.account_box, color: Colors.white,),
          title: Text('${patients.profile.name}',
            style: TextStyle(color: Colors.white, fontSize: 25),
            textAlign: TextAlign.center,
          ),
          onTap: () {
            _onSelected(position);
            _savePatient(position);
          }
        ),
      ),
    );
  }

  _onSelected(int index){
    setState(() => selectIndex = index);
  }

  _savePatient(int index) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String email = patientModel.patientItems[index].profile.email;
    patientName = email;
    sp.setString('patientForfm', patientName);
  }
}

