import 'dart:async';
import 'dart:convert';
import 'package:hotaal/model/message_model.dart';
import 'package:http/http.dart' as http;

class MessageDao{
  static Future<MessageModel> fetch(String url) async{
    final response = await http.get(url);
    if(response.statusCode == 200){
      var result = json.decode(response.body);
      return MessageModel.fromJson(result);
    }else{
      throw Exception('failed connect');
    }
  }
}
