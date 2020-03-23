
import 'package:ahadmobile/models/Audio.dart';
import 'package:ahadmobile/ui/Common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExploreAll extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final List<Audio> allAudios = ModalRoute.of(context).settings.arguments;
    allAudios.sort((a, b) => a.user.firstName.compareTo(b.user.firstName));

    return Scaffold(
      appBar: AppBar(
        title: Text('Tous les audios'),
      ),
      floatingActionButton: FloatingActionPlay(),
      body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overScroll) {
            overScroll.disallowGlow();
            return null;
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 16),
                  Center(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: allAudios.length,
                      itemBuilder: (context, index) {
                        return AudioItemList(allAudios.elementAt(index));
                      },
                    ),
                  ),
                  SizedBox(height: 64)
                ],
              ),
            ),
          )
      ),
    );
  }

}
