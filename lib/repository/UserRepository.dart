

import 'package:ahadmobile/apihelper/apihelper.dart';
import 'package:ahadmobile/models/User.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserRepository {
  static final UserRepository _singleton = UserRepository._internal();

  factory UserRepository() =>_singleton;

  UserRepository._internal();

  Future <User> JWTSignIn () async {
    final storage = new FlutterSecureStorage();
    var id = await storage.read(key: "userid");
    User u = new User(id: int.parse(id));
    var response = await APIHelper().request("/jwtsignin", RequestType.POST, u.toJson());
    return User.fromJson(response);
  }

  Future <User> EmailSignIn (String email, String password) async {
    final User u = new User(email: email, pwd: password);
    print('logging user ${u.toString()}');
  }
}