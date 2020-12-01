import 'dart:async';
import 'dart:convert';
import 'package:hotaal/model/patient_model.dart';
import 'package:http/http.dart' as http;

class PatientDao{
  static Future<PatientModel> fetch(String url) async{
    final response = await http.get(url);
    if(response.statusCode == 200){
      var result = json.decode(response.body);
      return PatientModel.fromJson(result);
    }else{
      throw Exception('failed connect');
    }
  }
}
