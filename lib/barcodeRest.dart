import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

//consume
Future<consumeResponse> consumePost(String url, {Map body}) async {
  return http.post(url, body: utf8.encode(json.encode(body))).then((http.Response response) {
    final int statusCode = response.statusCode;
    print(response.body.toString());
    //Map a = json.decode(response.body);
    //print(m);
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    return null;
  });
}

class consumeResponse {
  final int code;
  consumeResponse({this.code});
  factory consumeResponse.fromJson(Map<String, dynamic> json) {
    return consumeResponse(
        code: json['success']
      //msg: json['message'],
    );
  }
}

//eat
Future<eatResponse> eat(String url, {Map body}) async {
  return http.post(url, body: utf8.encode(json.encode(body))).then((http.Response response) {
    final int statusCode = response.statusCode;
    print(response.body.toString());
    Map b = json.decode(response.body);
    //print(m);
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    return eatResponse.fromJson(b);
  });
}

class eatResponse {
  final int code;
  eatResponse({this.code});

  factory eatResponse.fromJson(Map<String, dynamic> json) {
    return eatResponse(
        code: json['success']
      //msg: json['message'],
    );
  }
}