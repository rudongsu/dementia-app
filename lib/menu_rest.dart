import 'dart:async';
import 'dart:convert';
import 'mealplan.dart';
import 'package:http/http.dart' as http;

//const URL = '';
const hotaalURL = 'https://ylr9w8c0q2.execute-api.us-east-1.amazonaws.com/v0/mealplan';

class MenuDao{

  //add meal plan
  static Future<int> post(String body) async{
    final response = await http.post(hotaalURL,headers: {"Content-Type":"application/json"},body: body);
    if(response.statusCode == 200){
      var result = json.decode(response.body);
      //print(result['message']);
      return result['success'];
    }else{
      throw Exception('failed connect');
    }
  }

  //query = "owner=<groupid>"
  // Get meal plan request
  static Future<List<MenuModel>> get(String query) async{
    final response = await http.get(hotaalURL + '?owner=' + query);
    if(response.statusCode == 200){
      print("connected");
      var result = json.decode(response.body);  //response data
      List results = result['Items'] as List;
      List<MenuModel> items = results.map((model)=> MenuModel.fromJson(model['content'])).toList(); //map json to dart object
      return items;
    }else{
      throw Exception('failed connect');
    }
  }

  //query = "owner=<groupid>"
  // delete meal plan request
  static Future<List<MenuModel>> delete(String query) async{
    //final response = await http.delete(hotaalURL + '?' + query);
    final client = http.Client();
    final sresponse = await client.send(http.Request('DELETE',Uri.parse(hotaalURL))
      ..body=query);
    if(sresponse.statusCode == 200){
      print("connected");
      var response = await http.Response.fromStream(sresponse);
      var result = json.decode(response.body);  //response data
      List results = result['Items'] as List;
      List<MenuModel> items = results.map((model)=> MenuModel.fromJson(model)).toList(); //map json to dart object
      return items;
    }else{
      throw Exception('failed connect');
    }
  }

}
