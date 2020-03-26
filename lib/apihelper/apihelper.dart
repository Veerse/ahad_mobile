import 'dart:io';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:ahadmobile/apihelper/customexception.dart';

enum RequestType { GET, POST, PUT, DELETE }

class APIHelper {
  // 10.0.2.2 on Android, localhost on iOS
  final String _baseURI = "http://10.0.2.2:8095";

  final storage = new FlutterSecureStorage();

  Future<dynamic> request(String resource, RequestType requestType, [reqBody]) async {

    var jwtCookie = await storage.read(key: "jwt");
    print("jwt token inside helper is $jwtCookie");
    print("reqbody is ${reqBody}");

    var responseJSON;
    try {
      http.Response response;
      switch (requestType) {
        case RequestType.GET:
          response = await http.get(_baseURI + resource, headers: {HttpHeaders.cookieHeader:"$jwtCookie"});
          updateCookie(response);
          break;
        case RequestType.POST:
          print("body: ${json.encode(reqBody)}");
          response = await http.post(_baseURI + resource, headers: {HttpHeaders.contentTypeHeader:"application/json", HttpHeaders.cookieHeader:new Cookie("ahad_token", jwtCookie).toString()}, body: json.encode(reqBody));
          updateCookie(response);
          break;
        case RequestType.PUT:
          response = await http.put(_baseURI + resource);
          break;
        case RequestType.DELETE:
          response = await http.delete(_baseURI + resource);
          break;
      }
      responseJSON = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJSON;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(utf8.decode(response.bodyBytes));
        // print(responseJson);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
        throw UnauthenticatedException(response.body.toString());
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 409:
        throw ConflictException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  void updateCookie(http.Response response) {
    if(response.headers['set-cookie'] != null){
      var responseCookie = response.headers['set-cookie'];
      storage.delete(key: "ahad_token");
      storage.write(key: "ahad_token", value: responseCookie);
    }
    /*if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers['cookie'] =
      (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }*/
  }
}