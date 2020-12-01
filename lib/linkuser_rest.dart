import 'dart:convert';
import 'package:http/http.dart' as http;

Future<linkCaregiver> link(String url, {Map body}) async {
  return http.put(url, body: utf8.encode(json.encode(body))).then((http.Response response) {
    final int statusCode = response.statusCode;
    Map m = json.decode(response.body);
    print('link res code $statusCode');
    //print(m);
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    return linkCaregiver.fromJson(m);
  });
}

class linkCaregiver {
  final int code;
  final String msg;
  linkCaregiver({this.code, this.msg});
  factory linkCaregiver.fromJson(Map<String, dynamic> json) {
    return linkCaregiver(
        code: json['success'],
        msg: json['message']
    );
  }
}