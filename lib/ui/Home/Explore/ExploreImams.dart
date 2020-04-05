
import 'dart:ui';

import 'package:ahadmobile/models/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExploreImams extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<User> allImams = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Imams'),
      ),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Center(
            child: ListView.builder(
              itemCount: allImams.length,
              itemBuilder: (context, index) {
                return _ImamItem(allImams.elementAt(index));
              },
            ),
          )
      ),
    );
  }
}

class _ImamItem extends StatelessWidget {
  final User imam;

  _ImamItem(this.imam);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/explore/imam/details', arguments: imam),
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          height: 150,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage("https://veerse.xyz/tag/${imam.id}/image"),
                  fit: BoxFit.fitWidth
              ),
              borderRadius: BorderRadius.circular(8),
              //color: Colors.black
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment(0.8, 0.0), // 10% of the width, so there are ten blinds.
                colors: [const Color(0XFF263238), const Color(0XFF3E2723)], // whitish to gray
                tileMode: TileMode.repeated, //
              )
            //image:
          ),
          child: Center(
            child: Text('#${imam.firstName.toLowerCase()}', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          )
      ),
    );
  }
}

/*

Center(
        child: Text('#${tag.tagName}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),

 */