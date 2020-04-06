
import 'package:ahadmobile/models/Audio.dart';
import 'package:ahadmobile/ui/Common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExploreAll extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final List<Audio> allAudios = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Tous les audios'),
      ),
      floatingActionButton: FloatingActionPlay(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Center(
          child: ListView.builder(
            itemCount: allAudios.length,
            itemBuilder: (context, index) {
              return AudioItemList(allAudios.elementAt(index));
            },
          ),
        ),
      ),
    );
  }
}

