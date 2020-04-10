
import 'package:ahadmobile/apihelper/apihelper.dart';
import 'package:ahadmobile/models/User.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserRepository {
  static final UserRepository _singleton = UserRepository._internal();

  factory UserRepository() =>_singleton;

  UserRepository._internal();

  final storage = new FlutterSecureStorage();

  Future <User> jwtSignIn () async {
    final storage = new FlutterSecureStorage();
    var id = await storage.read(key: "userid");
    User u = new User(id: int.parse(id));
    var response = await APIHelper().request("/jwtsignin", RequestType.POST, u.toJson()).catchError((e){
      print(e);
      throw e;
    });
    return User.fromJson(response);
  }

  Future <User> emailSignIn (String email, String password) async {
    final User u = new User(email: email, pwd: password);
    var response = await APIHelper().request("/signin", RequestType.POST, u.toJson()).catchError((e){
      print(e);
      throw e;
    });
    if (response != null) {
      storage.write(key: "userid", value: "${User.fromJson(response).id}");
    }
    return User.fromJson(response);
  }

  Future <User> registerSignIn (User u) async {
    u.personType = 3; // Free user
    var response = await APIHelper().request("/registersignin", RequestType.POST, u.toJson()).catchError((e){
      print(e);
      throw e;
    });
    storage.write(key: "userid", value: "${User.fromJson(response).id}");
    return User.fromJson(response);
  }

  Future<List<User>> fetchAllImams () async {
    final queryParameters = {
      'userType': '2', // Imam
    };
    final uri = Uri.https('veerse.xyz', '/users', queryParameters);

    var response = await APIHelper().request(uri.toString(), RequestType.GET_WITH_PARAMETERS);
    List<User> imams = (response as List).map((i)=>User.fromJson(i)).toList();
    return imams;
  }
}