import 'package:ahadmobile/common/theme.dart';
import 'package:ahadmobile/models/User.dart';
import 'package:ahadmobile/providers/UserModel.dart';
import 'package:ahadmobile/repository/UserRepository.dart';
import 'package:ahadmobile/ui/HomePage.dart';
import 'package:ahadmobile/ui/LoadingPage.dart';
import 'package:ahadmobile/ui/LoginPage.dart';
import 'package:ahadmobile/ui/OnboardingPage.dart';
import 'package:ahadmobile/ui/RegisterPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]).then((_){
    runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => UserModel())
          ],
          child: MyApp(),
        )
    );
  });
}

class MyApp extends StatelessWidget {
  final storage = new FlutterSecureStorage();

  Future <Widget> authenticationCheck (BuildContext context) async {
    storage.write(key: "jwt", value: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidXNlcl90eXBlIjowLCJleHAiOjE1ODUxNzI4NzN9.5AjXzcqmMnF5-O39Soq78ly6jj5xcjP6gR7laVJYLxY");
    storage.write(key: "userid", value: "4");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("onboarding");
    if (!prefs.containsKey("onboarding")){
      // prefs.setBool("onboarding", true);
      return OnBoardingPage();
    }

    var jwt = await storage.read(key: "jwt").catchError((err){throw err;});
    var userId = await storage.read(key: "userid").catchError((err){throw err;});

    if (jwt != null && userId != null){
      User u = await UserRepository().JWTSignIn().catchError((err){
        if (jwt != null){storage.delete(key: "jwt");}
        if (userId != null) {storage.delete(key: "userid");}
        throw err;
      });
      Provider.of<UserModel>(context, listen: false).logIn(u);
      return HomePage();
    } else {
      if (jwt != null){storage.delete(key: "jwt");}
      if (userId != null) {storage.delete(key: "userid");}
      throw("Token or userid not found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ahad',
      theme: appTheme,
      darkTheme: ThemeData.dark(),
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/register': (context) => RegisterPage(),
      },
      // The home depends on if the user is logged or not
      home: FutureBuilder(
        future: authenticationCheck(context),
        builder: (context, snapshot) {
          if (snapshot.hasData){
            return snapshot.data; // OnboardingPage or HomePage
          }
          if (snapshot.hasError){
            print('Error caught on app startup : ${snapshot.error.toString()}');
            return LoginPage();
          }
          else {
            return LoadingPage();
          }
        },
      ),
    );
  }
}







