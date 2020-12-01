import 'dart:async';
import 'dart:convert';
import 'package:hotaal/model/mealInfo_model.dart';
import 'package:http/http.dart' as http;

class MealInfoDao{
  static Future<MealInfoModel> fetch(String url) async{
    final response = await http.get(url);
    if(response.statusCode == 200){
      var result = json.decode(response.body);
      return MealInfoModel.fromJson(result);
    }else{
      throw Exception('failed connect');
    }
  }
}
