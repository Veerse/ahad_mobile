
import 'dart:convert';

import 'package:ahadmobile/models/AudioInfo.dart';
import 'package:ahadmobile/models/User.dart';
import 'package:ahadmobile/providers/AudioModel.dart';
import 'package:ahadmobile/providers/UserModel.dart';
import 'package:ahadmobile/repository/AudioRepository.dart';
import 'package:ahadmobile/repository/UserRepository.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  final globalKey = GlobalKey<ScaffoldState>();

  final _firstNameFocus = new FocusNode();
  final _lastNameFocus = new FocusNode();
  final _birthFocus = new FocusNode();
  //final _isMaleFocus = new FocusNode();
  final _cityFocus = new FocusNode();
  //final _countryFocus = new FocusNode();
  final _emailFocus = new FocusNode();
  final _pwdFocus = new FocusNode();

  bool _firstNameHasFocus = false,
      _lastNameHasFocus = false,
      //_birthHasFocus = false,
      //_isMaleHasFocus = false,
      _cityHasFocus = false,
      //_countryHasFocus = false,
      _emailHasFocus = false,
      _pwdHasFocus = false;

  bool _pwdIsVisible = false;
  bool _isLoading = false;

  @protected
  void initState() {
    super.initState();
    _firstNameFocus.addListener((){
      setState(() {
        _firstNameHasFocus = _firstNameFocus.hasFocus;
      });
    });
    _lastNameFocus.addListener((){
      setState(() {
        _lastNameHasFocus = _lastNameFocus.hasFocus;
      });
    });
    _cityFocus.addListener((){
      setState(() {
        _cityHasFocus = _cityFocus.hasFocus;
      });
    });
    _emailFocus.addListener(() {
      //print("email focus: ${_emailFocus.hasFocus}");
      setState(() {
        _emailHasFocus = _emailFocus.hasFocus;
      });
    });
    _pwdFocus.addListener(() {
      //print("pwd as focus: ${_pwdFocus.hasFocus}");
      setState(() {
        _pwdHasFocus = _pwdFocus.hasFocus;
      });
    });
  }

  bool keyboardIsVisible(){
    return _firstNameHasFocus || _lastNameHasFocus || _cityHasFocus || _emailHasFocus || _pwdHasFocus;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      resizeToAvoidBottomPadding: false,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {FocusScope.of(context).unfocus();},
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              keyboardIsVisible() ? Container():
              Column(
                children: <Widget>[
                  Text('Inscription', style: Theme.of(context).textTheme.display3),
                  SizedBox(height: 32)
                ],
              ),
              FormBuilder(
                key: _fbKey,
                initialValue: {
                  'birth': DateTime(1994),
                  'ismale': 'true',
                  'country': 'France',
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: FormBuilderTextField(
                              readOnly: _isLoading ? true:false,
                              attribute: "firstname",
                              enabled: false,
                              autocorrect: false,
                              decoration: InputDecoration(
                                labelText: "Prénom",
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                              ),
                              maxLines: 1,
                              focusNode: _firstNameFocus,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_){
                                _firstNameFocus.unfocus();
                                FocusScope.of(context).requestFocus(_lastNameFocus);
                              },
                              validators: [
                                FormBuilderValidators.required(errorText: "Requis")
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          Flexible(
                            child: FormBuilderTextField(
                              readOnly: _isLoading ? true:false,
                              attribute: "lastname",
                              autocorrect: false,
                              decoration: InputDecoration(
                                labelText: 'Nom',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                              ),
                              maxLines: 1,
                              focusNode: _lastNameFocus,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_){
                                _lastNameFocus.unfocus();
                              },
                              validators: [
                                FormBuilderValidators.required(errorText: "Requis")
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: FormBuilderDateTimePicker(
                              resetIcon: null,
                              readOnly: _isLoading ? true:false,
                              attribute: "birth",
                              inputType: InputType.date,
                              decoration: InputDecoration(
                                labelText: "Naissance",
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                              ),
                              format: DateFormat("dd-MM-yyyy"),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                              maxLines: 1,
                              focusNode: _birthFocus,
                              validators: [
                                FormBuilderValidators.required(errorText: "Requis")
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          Flexible(
                            child: FormBuilderDropdown(
                              readOnly: _isLoading ? true:false,
                              attribute: "ismale",
                              items:[
                                DropdownMenuItem(
                                  child: Text('Homme'),
                                  value: "true",
                                ),
                                DropdownMenuItem(
                                  child: Text('Femme'),
                                  value: "false",
                                ),
                                DropdownMenuItem(
                                  child: Text('Helicoptere de combat'),
                                  value: "euh",
                                ),
                              ],
                              decoration: InputDecoration(
                                labelText: 'Sexe',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 16),
                      Divider(),
                      SizedBox(height: 16),
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: FormBuilderTextField(
                              readOnly: _isLoading ? true:false,
                              attribute: "city",
                              autocorrect: false,
                              decoration: InputDecoration(
                                labelText: "Ville",
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                              ),
                              maxLines: 1,
                              focusNode: _cityFocus,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_){
                                _cityFocus.unfocus();
                              },
                              validators: [
                                FormBuilderValidators.required(errorText: "Requis")
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          Flexible(
                            child: FormBuilderDropdown(
                              readOnly: _isLoading ? true:false,
                              attribute: "country",
                              items: [
                                DropdownMenuItem(
                                  child: Text('France'),
                                  value: "France",
                                ),
                                DropdownMenuItem(
                                  child: Text('Algérie'),
                                  value: "Algerie",
                                ),
                                DropdownMenuItem(
                                  child: Text('Maroc'),
                                  value: "Maroc",
                                ),
                                DropdownMenuItem(
                                  child: Text('Sénégal'),
                                  value: "Senegal",
                                ),
                                DropdownMenuItem(
                                  child: Text('Autre'),
                                  value: "Other",
                                ),
                              ],
                              decoration: InputDecoration(
                                labelText: 'Pays',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 16),
                      Divider(),
                      SizedBox(height: 16),
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: FormBuilderTextField(
                              readOnly: _isLoading ? true:false,
                              attribute: "email",
                              decoration: InputDecoration(
                                labelText: "Email",
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              maxLines: 1,
                              focusNode: _emailFocus,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_){
                                _emailFocus.unfocus();
                                FocusScope.of(context).requestFocus(_pwdFocus);
                              },
                              validators: [
                                FormBuilderValidators.required(errorText: "Requis"),
                                FormBuilderValidators.email(errorText: "Doit etre une adresse mail")
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          Flexible(
                            child: FormBuilderTextField(
                              readOnly: _isLoading ? true:false,
                              attribute: "pwd",
                              decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _pwdIsVisible = !_pwdIsVisible;
                                    });
                                  },
                                  child: Icon(!_pwdIsVisible ? Icons.visibility_off:Icons.visibility),
                                ),
                                labelText: 'Mot de passe',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                              ),
                              obscureText: !_pwdIsVisible,
                              maxLines: 1, // To allow obscuring password (maybe a bug ?)
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_){_pwdFocus.unfocus();},
                              focusNode: _pwdFocus,
                              validators: [
                                FormBuilderValidators.minLength(6, errorText: "6 caractères mini !"),
                                FormBuilderValidators.required(errorText: "Requis")
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 16),
                      _isLoading ?
                      SpinKitFoldingCube(
                        color: Colors.lightGreen,
                        size: 32.0,
                      ):SizedBox(
                        width: 128,
                        child: RaisedButton(
                          color: Theme.of(context).canvasColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.white70, width: 1)
                          ),
                          elevation: 4,

                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            if(_fbKey.currentState.saveAndValidate()){
                              setState(() {
                                _isLoading = true;
                              });

                              String pwd = _fbKey.currentState.value['pwd'].toString().trim();
                              var pwdBytes = utf8.encode(pwd);
                              String hashedPwd = sha512.convert(pwdBytes).toString();

                              User u = new User(
                                firstName: _fbKey.currentState.value['firstname'].toString().trim(),
                                lastName: _fbKey.currentState.value['lastname'].toString().trim(),
                                birth: _fbKey.currentState.value['birth'],
                                isMale: _fbKey.currentState.value['ismale'] == "true" ? true:false,
                                city: _fbKey.currentState.value['city'].toString().trim(),
                                country: _fbKey.currentState.value['country'].toString().trim(),
                                email: _fbKey.currentState.value['email'].toString().trim(),
                                pwd: hashedPwd
                              );

                              UserRepository().registerSignIn(u).then((User u){
                                setState(() {
                                  _isLoading = false;
                                });

                                Provider.of<UserModel>(context, listen: false).wipeUser();
                                Provider.of<UserModel>(context, listen: false).logIn(u);

                                // Retrieve last audio played by user
                                AudioRepository().fetchLastListenedAudio().then((a) async {
                                  if (a != null) {
                                    Provider.of<AudioModel>(context, listen: false).audio = a;
                                    /*await AudioRepository().fetchListening(a.id).then((Listening l) async {
                                      await Provider.of<AudioModel>(context, listen: false).audioPlayer.setUrl("https://veerse.xyz/audio/${a.id}/download", isLocal: false).then((v){
                                      }).catchError((e){
                                        print('Error when trying to initialize and play ${e.toString()}');
                                      });
                                      Provider.of<AudioModel>(context, listen: false).audioPlayer.seek(new Duration(seconds: l != null ? l.position: 0));
                                      Provider.of<AudioModel>(context, listen: false).audioPlayer.pause();
                                    });*/
                                  }
                                });

                                Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);
                              }).catchError((e){
                                setState(() {
                                  _isLoading = false;
                                });
                                if (e.toString().contains("409")){
                                  globalKey.currentState.hideCurrentSnackBar();
                                  globalKey.currentState.showSnackBar(SnackBar(
                                    backgroundColor: Theme.of(context).hintColor,
                                    content: Text('Adresse email déjà utilisée 😦'),
                                  ));
                                } else {
                                  globalKey.currentState.hideCurrentSnackBar();
                                  globalKey.currentState.showSnackBar(SnackBar(
                                    backgroundColor: Theme.of(context).errorColor,
                                    content: Text('Impossible de joindre le serveur 😞'),
                                  ));
                                }
                              });

                            } else {
                              globalKey.currentState.hideCurrentSnackBar();
                              globalKey.currentState.showSnackBar(SnackBar(
                                backgroundColor: Theme.of(context).hintColor,
                                content: Text('Champs incorrects 😕'),
                              ));
                            }
                          },
                          child: Text('Valider'),
                        ),
                      ),
                      SizedBox(height: keyboardIsVisible() ? 192:64),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _birthFocus.dispose();
    _cityFocus.dispose();
    _pwdFocus.dispose();
    _emailFocus.dispose();

  }
}