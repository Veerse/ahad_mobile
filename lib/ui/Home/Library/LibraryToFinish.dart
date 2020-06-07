
import 'package:ahadmobile/models/Audio.dart';
import 'package:ahadmobile/repository/AudioRepository.dart';
import 'package:ahadmobile/ui/Common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LibraryToFinish extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('A terminer'),
      ),
      floatingActionButton: FloatingActionPlay(),
      body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overScroll) {
            overScroll.disallowGlow();
            return null;
          },
          child: FutureBuilder<List<Audio>>(
            future: AudioRepository().fetchCurrentlyPlayingAudiosOfUser(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Audio> audios = snapshot.data;

                if (audios.length > 0) {
                  //audios.sort((a, b) => a.user.firstName.compareTo(b.user.firstName));

                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 8),
                          ListView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              return AudioItemList(audios.elementAt(index));
                            },
                            itemCount: audios.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 64),
                      child: RichText(
                        text: TextSpan(
                            style: Theme.of(context).textTheme.subhead,
                            children: [
                              TextSpan(text: 'Les audios commencés et '),
                              TextSpan(text: 'non terminés ', style: Theme.of(context).textTheme.body2,),
                              TextSpan(text: 'apparaîtront automatiquement sur cette page'),
                            ]
                        ),
                      ),
                    ),
                  );
                }
              } else if (snapshot.hasError) {
                return Center(child: Text('Erreur ${snapshot.error.toString()}'),);
              } else{
                return Center(
                  child: SpinKitFoldingCube(
                    color: Theme.of(context).primaryColor,
                    size: 25.0,
                  ),
                );
              }
            },
          )
      ),
    );
  }

}