import 'dart:async';
import 'dart:convert';
import 'package:hotaal/model/activityLog_model.dart';
import 'package:http/http.dart' as http;

const String url = 'https://ylr9w8c0q2.execute-api.us-east-1.amazonaws.com/v0/broker/summary?group=HOTAALUOA';

class ActivityLogDao{
  static Future<ActivityLogModel> fetch() async{
    final response = await http.get(url);
    if(response.statusCode == 200){
      var result = json.decode(response.body);
      return ActivityLogModel.fromJson(result);
    }else{
      throw Exception('failed connect');
    }
  }
}
