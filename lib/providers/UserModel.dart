
import 'package:ahadmobile/models/User.dart';
import 'package:flutter/cupertino.dart';

class UserModel extends ChangeNotifier {
  User user;

  User get getUser => user;

  UserModel._privateConstructor();

  static final UserModel _instance = UserModel._privateConstructor();

  factory UserModel(){
    return _instance;
  }

  void logIn(User u){
    this.user = u;
    notifyListeners();
  }

  void wipeUser(){
    this.user = new User();
    notifyListeners();
  }
}