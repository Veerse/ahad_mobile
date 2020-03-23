import 'package:ahadmobile/common/theme.dart';
import 'package:ahadmobile/providers/UserModer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]).then((_){
    runApp(
      MultiProvider(
        providers: [
          Provider(create: (context) => UserModel())
        ],
        child: MyApp(),
      )
    );
  });
}

class MyApp extends StatelessWidget {

  final storage = new FlutterSecureStorage();

  Future<bool> authenticationCheck () async {
    var v = await storage.read(key: "jwt").then((onValue){
      if (onValue == null) {
        return false;
      }
      print('ok $onValue');
      return true;
    }).catchError((err){
      throw err;
    });
    return v;
  }

  @override
  Widget build(BuildContext context) {
    //storage.write(key: "jwt", value: "mykey");

    return MaterialApp(
      title: 'Flutter Demo',
      theme: appTheme,
      darkTheme: ThemeData.dark(),
      home: FutureBuilder(
        future: authenticationCheck(),
        builder: (context, snapshot){
          if (snapshot.hasError){
            print('pb cosmologique');
            return LoginPage();
          }
          if (snapshot.hasData){
            print('la val est ${snapshot.data.toString()}');
            if (snapshot.data == true){
              return Home();
            } else {
              return LoginPage();
            }
          }
          else {
            return Text('pb intercosmique');
          }
        },
      ),
    );
  }
}

class Home extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My app'),
      ),
      body: Center(
        child: Text('yod'),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('log in first please');
  }

}