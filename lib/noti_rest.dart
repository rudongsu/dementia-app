import 'dart:async';
import 'dart:convert';
import 'package:hotaal/notification_model.dart';
import 'package:http/http.dart' as http;

const hotaalURL = 'https://ylr9w8c0q2.execute-api.us-east-1.amazonaws.com/v0/mealplan';

class noti{
  static Future<List<Notifications>> get(String query) async{
    final response = await http.get(hotaalURL + '?' + query);
    if(response.statusCode == 200){
      print("connected");
      var result = json.decode(response.body);  //response data
      List results = result['Items'] as List;
      List<Notifications> notifications = results
          .map((model) => Notifications.fromJson(model['content']))
          .toList(); //map json to dart object
      return notifications;
    }else{
      throw Exception('failed connect');
    }
  }
}