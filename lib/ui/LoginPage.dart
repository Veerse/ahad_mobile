
import 'package:ahadmobile/providers/AudioModel.dart';
import 'package:ahadmobile/providers/UserModel.dart';
import 'package:ahadmobile/repository/UserRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => LoginPageState();

}

class LoginPageState extends State<LoginPage> {
  final globalKey = GlobalKey<ScaffoldState>();

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  final _emailFocus = new FocusNode();
  final _pwdFocus = new FocusNode();

  bool _pwdIsVisible = false;

  bool _emailHasFocus = false;
  bool _pwdHasFocus = false;

  bool _isLoading = false;

  @protected
  void initState() {
    super.initState();

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
    return _emailHasFocus || _pwdHasFocus;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      resizeToAvoidBottomPadding: false,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {FocusScope.of(context).unfocus();}, // To dismiss keyboard when clicking on body
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              keyboardIsVisible() ? Container():LoginPageHeader(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: FormBuilder(
                  initialValue: {
                    //'email':'mailFromSharedPrefs'
                  },
                  key: _fbKey,
                  child: Column(
                    children: <Widget>[
                      FormBuilderTextField(
                        //readOnly: _isLoading ? true:false,
                        attribute: "email",
                        decoration: InputDecoration(
                          labelText: 'E-mail',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_){
                          _emailFocus.unfocus();
                          FocusScope.of(context).requestFocus(_pwdFocus);
                        },
                        focusNode: _emailFocus,
                        keyboardType: TextInputType.emailAddress,
                        validators: [
                          FormBuilderValidators.required(errorText: "Requis"),
                          FormBuilderValidators.email(errorText: "Doit etre une adresse mail")
                        ],
                      ),
                      SizedBox(height: 16),
                      FormBuilderTextField(
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
                          FormBuilderValidators.required(errorText: "Requis BATARD")
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32),
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
                  onPressed: (){
                    FocusScope.of(context).unfocus();
                    if(_fbKey.currentState.saveAndValidate()){
                      setState(() {
                        _isLoading = true;
                      });

                      var email = _fbKey.currentState.value['email'].toString().trim();
                      var pwd = _fbKey.currentState.value['pwd'].toString().trim();

                      UserRepository().emailSignIn(email, pwd).then((u){
                        // AUTH SUCCESS
                        setState(() {
                          _isLoading = !_isLoading;
                        });
                        Provider.of<UserModel>(context, listen: false).logIn(u);
                        Provider.of<AudioModel>(context, listen: false).userId = u.id;
                        // STORE EMAIL IN SHAREDPREF HERE
                        /*var v = SharedPreferences.getInstance().then((i){
                          i.setString("email", email.toString().trim());
                          print('Stored');
                        }).catchError((e){
                          print('Impossible to store email in SharedPrefs ${e.toString()}');
                        });*/

                        //Navigator.pushReplacementNamed(context, "/home");
                        Navigator.pop(context);
                        Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);
                      }).catchError((e){
                        // AUTH ERROR
                        setState(() {
                          _isLoading = !_isLoading;
                        });
                        print('error on login ${e.toString()}');
                        if(e.toString().contains("422")){
                          globalKey.currentState.hideCurrentSnackBar();
                          globalKey.currentState.showSnackBar(SnackBar(
                            backgroundColor: Theme.of(context).errorColor,
                            content: Text('Mot de passe ou login erroné 😬'),
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
                  child: Text('Connexion'),
                ),
              ),
              SizedBox(height: 32),
              GestureDetector(
                onTap: () => _isLoading ? null:Navigator.pushNamed(context, "/register"),
                child: Text('S\'inscrire'),
              ),
              SizedBox(height: 32),
              Text('Mot de passe oublié ?'),
              SizedBox(height: keyboardIsVisible() ? 256:64)
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pwdFocus.dispose();
    _emailFocus.dispose();
  }
}

class LoginPageHeader extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset("assets/images/login/lantern.png", height: 200.0),
        Text('Muslimy', style: Theme.of(context).textTheme.display3),
        SizedBox(height: 32),
      ],
    );
  }

}