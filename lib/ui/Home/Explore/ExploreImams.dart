
import 'dart:ui';

import 'package:ahadmobile/models/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExploreImams extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<User> allImams = ModalRoute.of(context).settings.arguments;

    if (allImams != null)
      allImams.sort((a, b) => a.firstName.compareTo(b.firstName));

    return Scaffold(
      appBar: AppBar(
        title: Text('Imams'),
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overScroll) {
          overScroll.disallowGlow();
          return null;
        },
        child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 32),
                    GridView.count(
                      //scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: allImams.map((imam) => _ImamItem(imam)).toList(),
                    ),
                  ],
                )
            )
        ),
      )
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
        child: Column(
          children: <Widget>[
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage("https://veerse.xyz/user/${imam.id}/avatar"),
                      fit: BoxFit.fitWidth

                  ),
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment(0.8, 0.0),
                    colors: [const Color(0XFF263238), const Color(0XFF3E2723)], // whitish to gray
                    tileMode: TileMode.repeated, //
                  )
              ),

              alignment: Alignment.bottomCenter,
            ),
            SizedBox(height: 8),
            Text('${imam.firstName} ${imam.lastName}', style: Theme.of(context).textTheme.body2)
          ],
        )
    );
  }
}