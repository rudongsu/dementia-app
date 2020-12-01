import 'dart:async';
import 'dart:convert';
import 'package:hotaal/model/search_model.dart';
import 'package:http/http.dart' as http;

class SearchDao{
  static Future<SearchModel> fetch(String url) async{
    final response = await http.get(url);
    if(response.statusCode == 200){
      var result = json.decode(response.body);
      return SearchModel.fromJson(result);
    }else{
      throw Exception('failed connect');
    }
  }
}
