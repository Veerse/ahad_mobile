import 'dart:io';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:ahadmobile/apihelper/customexception.dart';

enum RequestType { GET, POST, PUT, DELETE }

class APIHelper {
  // 10.0.2.2 on Android, localhost on iOS
  final String _baseURI = "http://93.6.197.182:8095";

  final storage = new FlutterSecureStorage();

  Future<dynamic> request(String resource, RequestType requestType, [reqBody]) async {


    var jwtCookie = await storage.read(key: "ahad_token");

    //print("jwt token inside helper is $jwtCookie");
    //print("Reqbody is $reqBody");

    var responseJSON;
    try {
      http.Response response;
      switch (requestType) {
        case RequestType.GET:
          response = await http.get(_baseURI + resource, headers: {HttpHeaders.cookieHeader:"$jwtCookie"});
          updateCookie(response);
          break;
        case RequestType.POST:
          response = await http.post(_baseURI + resource, headers: {HttpHeaders.contentTypeHeader:"application/json", HttpHeaders.cookieHeader: jwtCookie == null ? null:new Cookie("ahad_token", jwtCookie).toString()}, body: json.encode(reqBody));
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

  void updateCookie(http.Response response) async {
    if(response.headers['set-cookie'] != null){
      var rawCookie = response.headers['set-cookie'];

      int semicolon = rawCookie.indexOf(";");
      int equal = rawCookie.indexOf("=");

      var jwt = rawCookie.substring(equal+1, semicolon);

      storage.delete(key: "ahad_token");
      storage.write(key: "ahad_token", value: jwt);
    }
  }
}