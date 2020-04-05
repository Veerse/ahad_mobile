
import 'dart:ui';

import 'package:ahadmobile/models/Tag.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExploreTags extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Tag> allTags = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Themes'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Center(
          child: ListView.builder(
            itemCount: allTags.length,
            itemBuilder: (context, index) {
              return _TagItem(allTags.elementAt(index));
            },
          ),
        )
      ),
    );
  }
}

class _TagItem extends StatelessWidget {
  final Tag tag;

  _TagItem(this.tag);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      height: 150,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage("https://veerse.xyz/tag/${tag.id}/image"),
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
        child: Text('#${tag.tagName.toLowerCase()}', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
      )
    );
  }
}

/*

Center(
        child: Text('#${tag.tagName}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),

 */