
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => LoginPageState();

}

class LoginPageState extends State<LoginPage> {
  final globalKey = GlobalKey<ScaffoldState>();

  final _emailController = TextEditingController();
  final _pwdController = TextEditingController();

  final _emailFocus = new FocusNode();
  final _pwdFocus = new FocusNode();

  bool _pwdIsVisible = false;

  bool _emailHasFocus = false;
  bool _pwdHasFocus = false;

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
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'E-mail',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                      ),
                      enableSuggestions: false,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_){
                        _emailFocus.unfocus();
                        FocusScope.of(context).requestFocus(_pwdFocus);
                      },
                      controller: _emailController,
                      focusNode: _emailFocus,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 16),
                    TextFormField(

                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _pwdIsVisible = !_pwdIsVisible;
                            });
                          },
                          child: Icon(_pwdIsVisible ? Icons.visibility_off:Icons.visibility),
                        ),
                        labelText: 'Mot de passe',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                      ),
                      enableSuggestions: false,
                      obscureText: _pwdIsVisible,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_){_pwdFocus.unfocus();},
                      controller: _pwdController,
                      focusNode: _pwdFocus,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              SizedBox(
                width: 128,
                child: RaisedButton(
                  color: Theme.of(context).canvasColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.white70, width: 1)
                  ),
                  elevation: 4,
                  onPressed: (){
                    print('snackbared!!');
                    final snackBar = SnackBar(
                      backgroundColor: Theme.of(context).errorColor,
                      content: Text('Impossible de joindre le serveur!'),

                    );

                    // Find the Scaffold in the widget tree and use
                    // it to show a SnackBar.
                    globalKey.currentState.showSnackBar(snackBar);
                  },
                  child: Text('Connexion'),
                ),
              ),
              SizedBox(height: 32),
              Text('S\'inscrire'),
              SizedBox(height: 32),
              Text('Mot de pass oublié ?'),
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
    _emailController.dispose();
    _pwdController.dispose();
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