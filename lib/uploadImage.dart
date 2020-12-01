import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<uploadImageResponse> uploadImage(String url, {Map body}) async {
  return http.put(url, body: utf8.encode(json.encode(body))).then((http.Response response) {
      final int statusCode = response.statusCode;
    Map m1 = json.decode(response.body);
    //print(m);
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    return uploadImageResponse.fromJson(m1);
  });
}

class uploadImageResponse {
  final int code;
  final String msg;
  uploadImageResponse({this.code, this.msg});
  factory uploadImageResponse.fromJson(Map<String, dynamic> json) {
    return uploadImageResponse(
        code: json['success'],
        msg: json['message']
    );
  }
}