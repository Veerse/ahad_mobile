
import 'package:ahadmobile/providers/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My app'),
        actions: <Widget>[
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/profile'),
            icon: Icon(Icons.account_circle),
          )
        ],
      ),
      body: Center(
        child: Text('Welcome, ${Provider.of<UserModel>(context, listen: false).user.id}'),
      ),
    );
  }
}