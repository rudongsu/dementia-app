import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

//https://ylr9w8c0q2.execute-api.us-east-1.amazonaws.com/v0

//login
Future<authResponse> createPost(String url, {Map body}) async {
  return http.post(url, body: utf8.encode(json.encode(body))).then((http.Response response) {
    final int statusCode = response.statusCode;
    Map m = json.decode(response.body);
    //print(m);
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    return authResponse.fromJson(m);
  });
}

class authResponse {
  final int code;
  final String msg;
  final String role;
  authResponse({this.code, this.msg, this.role});
  factory authResponse.fromJson(Map<String, dynamic> json) {
    return authResponse(
      code: json['success'],
          msg: json['message'],
      role: json['role']
    );
  }
}

Future<emailResponse> emailPost(String url, {Map body}) async {
  return http.post(url, body: utf8.encode(json.encode(body))).then((http.Response response) {
    final int statusCode = response.statusCode;
    Map n = json.decode(response.body);
    //print(m);
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching email data");
    }
    return emailResponse.fromJson(n);
  });
}

class emailResponse {
  final int code;
  emailResponse({this.code});
  factory emailResponse.fromJson(Map<String, dynamic> json) {
    return emailResponse(
        code: json['state']

    );
  }
}

//sign up
Future<signupResponse> signupPost(String url, {Map body}) async {
  return http.post(url, body: utf8.encode(json.encode(body))).then((http.Response response) {
    final int statusCode = response.statusCode;
    print(response.body.toString());
    Map b = json.decode(response.body);
    //print(m);
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching signup data");
    }
    return signupResponse.fromJson(b);
  });
}

class signupResponse {
  final int code1;
  final String msg;
  //signupResponse({this.code, this.msg});
  signupResponse({this.code1, this.msg});

  factory signupResponse.fromJson(Map<String, dynamic> json) {
    return signupResponse(
        code1: json['success'],
        msg: json['message'],
    );
  }
}

// connect with local broker
//Future<deviceResponse> devicePost(String url, {Map body}) async {
//  return http.post(url, body: utf8.encode(json.encode(body))).then((http.Response response) {
//    final int statusCode = response.statusCode;
//    print(response.body.toString());
//    Map c = json.decode(response.body);
//    //print(m);
//    if (statusCode < 200 || statusCode > 400 || json == null) {
//      throw new Exception("Error while fetching signup data");
//    }
//    else{
//      print(statusCode);
//    }
//    return deviceResponse.fromJson(c);
//  });
//}

class deviceResponse {
  final int code2;
  final String ret;
  deviceResponse({ this.code2, this.ret});

  factory deviceResponse.fromJson(Map<String, dynamic> json) {
    return deviceResponse(
        code2: json['success']
    );
  }
}

Future<deviceResponse> deviceGet(String url, {Map body}) async {
  return http.get(url).then((http.Response response) {
    final int statusCode = response.statusCode;
    print(response.body.toString());
    //Map c = json.decode(response.body);
    //print(m);
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching signup data");
    }
    else{
      print(statusCode);
    }
    return null;
  });
}

// edit profile
Future<editProfileResponse> editProfilePost(String url, {Map body}) async {
  return http.put(url, body: utf8.encode(json.encode(body))).then((http.Response response) {
    final int statusCode = response.statusCode;
    Map m1 = json.decode(response.body);
    //print(m);
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    return editProfileResponse.fromJson(m1);
  });
}

class editProfileResponse {
  final int code;
  final String msg;
  editProfileResponse({this.code, this.msg});
  factory editProfileResponse.fromJson(Map<String, dynamic> json) {
    return editProfileResponse(
        code: json['success'],
      msg: json['message']
    );
  }
}

// get meal plan
