import 'dart:async';
import 'dart:convert';
import 'package:hotaal/model/menu_model.dart';
import 'package:http/http.dart' as http;

const URL = 'https://api.spoonacular.com/recipes/mealplans/generate?'
    'timeFrame=day&apiKey=53a56460fcf24acf82b91106279f8130';
const hotaalURL = 'https://ylr9w8c0q2.execute-api.us-east-1.amazonaws.com/v0/mealplan';

class MenuDao{
  static Future<MenuModel> fetch() async{
    final response = await http.get(URL);
    if(response.statusCode == 200){
      var result = json.decode(response.body);
      return MenuModel.fromJson(result);
    }else{
      throw Exception('failed connect');
    }
  }

  static Future<int> post(String body) async{
    final response = await http.post(hotaalURL,headers: {"Content-Type":"application/json"},body: body);
    if(response.statusCode == 200){
      var result = json.decode(response.body);
      return result['success'];
    }else{
      throw Exception('failed connect');
    }
  }

  static Future<List<MenuModel>> get(String url) async{
    final response = await http.get(url);
    if(response.statusCode == 200){
      var result = json.decode(response.body);
      List results = result['Items'] as List;
      List<MenuModel> items = results
          .map((model) => MenuModel.fromJson(model['content']))
          .toList();
      return items;
    }else{
      throw Exception('failed connect');
    }
  }
}
