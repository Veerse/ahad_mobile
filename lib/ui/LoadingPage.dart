
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Text('Ahad', style: Theme.of(context).textTheme.display3),
            //SizedBox(height: 48),
            SpinKitFoldingCube(
              color: Colors.lightGreen,
              size: 50.0,
            )
          ],
        ),
      ),
    );
  }
}