import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:ahadmobile/apihelper/customexception.dart';

enum RequestType { GET, POST, PUT, DELETE }

class APIHelper {
  // 10.0.2.2 on Android, localhost on iOS
  final String _baseURI = "http://10.0.2.2:8095";

  static String _JWTcookie;

  Future<dynamic> request(String resource, RequestType requestType, [reqBody]) async {
    var responseJSON;
    try {
      http.Response response;
      switch (requestType) {
        case RequestType.GET:
          response = await http.get(_baseURI + resource, headers: {HttpHeaders.cookieHeader:"$_JWTcookie"});
          break;
        case RequestType.POST:
          print("body: ${json.encode(reqBody)}");
          response = await http.post(_baseURI + resource, headers: {HttpHeaders.contentTypeHeader:"application/json"}, body: json.encode(reqBody));
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
    if(response.headers['set-cookie'] != ""){
      _JWTcookie = response.headers['set-cookie'];
      print(_JWTcookie);
    }
    /*if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers['cookie'] =
      (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }*/
  }
}