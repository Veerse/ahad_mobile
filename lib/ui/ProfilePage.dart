
import 'package:ahadmobile/models/User.dart';
import 'package:ahadmobile/providers/UserModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Mon profil'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 32),
              ClipOval(
                child: Provider.of<UserModel>(context).getUser.isMale ? Image.asset("assets/images/profile/muslim_man.png", height: 150):Image.asset("assets/images/profile/muslim_woman.png", height: 150),
              ),
              SizedBox(height: 32),
              Text('${Provider.of<UserModel>(context).getUser.firstName} ${Provider.of<UserModel>(context, listen: false).getUser.lastName}', style: Theme.of(context).textTheme.display1),
              Expanded(
                child: SizedBox(),
              ),
              RaisedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    child: AlertDialog(
                      title: Text('Quitter ? 😭'),
                      content: Image.asset("assets/images/profile/exit.png", height: 300),
                      actions: <Widget>[
                        FlatButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Non')
                        ),
                        FlatButton(
                            onPressed: () {
                              final storage = new FlutterSecureStorage();
                              storage.delete(key: "ahad_token");
                              storage.delete(key: "userid");
                              Navigator.pop(context);
                              Navigator.pushNamedAndRemoveUntil(context, '/login', (Route<dynamic> route) => false);

                            },
                            child: Text('Oui')
                        ),
                      ],
                    )
                  );
                },
                child: Text('Déconnexion'),
              ),
              SizedBox(height: 32),
              Text('Muslimy MVP (Minimum Viable Product)', style: Theme.of(context).textTheme.caption),
              SizedBox(height: 16)
            ],
          ),
        ),
      ),
    );
  }

}