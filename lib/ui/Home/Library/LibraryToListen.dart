
import 'package:ahadmobile/models/Audio.dart';
import 'package:ahadmobile/ui/Common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LibraryToListen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final List<Audio> audios = ModalRoute.of(context).settings.arguments;
    if (audios != null)
      audios.sort((a, b) => a.user.firstName.compareTo(b.user.firstName));

    return Scaffold(
      appBar: AppBar(
        title: Text('A écouter'),
      ),
      floatingActionButton: FloatingActionPlay(),
      body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overScroll) {
            overScroll.disallowGlow();
            return null;
          },
          child: audios != null ?
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 16),
                  Center(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: audios.length,
                      itemBuilder: (context, index) {
                        return AudioItemList(audios.elementAt(index));
                      },
                    ),
                  ),
                  SizedBox(height: 64)
                ],
              ),
            ),
          ):
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 64),
              child: RichText(
                text: TextSpan(
                    style: Theme.of(context).textTheme.subhead,
                    children: [
                      TextSpan(text: 'Sauvegarder des audios pour plus tard en cliquant sur le bouton ', style: Theme.of(context).textTheme.subhead,),
                      WidgetSpan(child: Icon(Icons.add)),
                    ]
                ),
              ),
            ),
          )
      ),
    );
  }

}