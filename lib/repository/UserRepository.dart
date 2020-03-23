
import 'dart:developer';

import 'package:ahadmobile/apihelper/apihelper.dart';
import 'package:ahadmobile/models/User.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserRepository {
  static final UserRepository _singleton = UserRepository._internal();

  factory UserRepository() =>_singleton;

  UserRepository._internal();

  final storage = new FlutterSecureStorage();

  // We pass user in body in complement of jwt token to make sure that userId == jwt id
  Future <User> jwtSignIn () async {
   var id = await storage.read(key: "userid").catchError((e){
      log('Error when reading key userId from secured storage ${e.toString()}');
      throw e;
    });

    User u = new User(id: int.parse(id));

    return await APIHelper().request("/jwtsignin", RequestType.POST, u.toJson()).then((r){
      return User.fromJson(r);
    }).catchError((e){
      log('Error when jwt signing in ${e.toString()}');
      throw e;
    });
  }

  Future <User> emailSignIn (String email, String password) async {
    final User u = new User(email: email, pwd: password);

    return await APIHelper().request("/signin", RequestType.POST, u.toJson()).then((r){
      if (r != null) storage.write(key: "userid", value: "${User.fromJson(r).id}");
      return User.fromJson(r);
    }).catchError((e){
      print(e);
      throw e;
    });
  }

  Future <User> registerSignIn (User u) async {
    u.personType = 3; // Free user

    return await APIHelper().request("/registersignin", RequestType.POST, u.toJson()).then((r){
      if (r != null) storage.write(key: "userid", value: "${User.fromJson(r).id}");
      return User.fromJson(r);
    }).catchError((e){
      print(e);
      throw e;
    });
  }

  Future<List<User>> fetchAllImams () async {
    final queryParameters = {
      'userType': '2', // Imam
    };

    final uri = Uri.https('veerse.xyz', '/users', queryParameters);

    return await APIHelper().request(uri.toString(), RequestType.GET_WITH_PARAMETERS).then((r){
      return (r as List).map((i)=>User.fromJson(i)).toList();
    }).catchError((e){
      log('Error when fetching all imams ${e.toString()}');
      throw e;
    });
  }
}