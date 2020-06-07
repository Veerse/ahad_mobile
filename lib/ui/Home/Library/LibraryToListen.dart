
import 'package:ahadmobile/models/Audio.dart';
import 'package:ahadmobile/models/AudioInfo.dart';
import 'package:ahadmobile/providers/AudioModel.dart';
import 'package:ahadmobile/providers/UserModel.dart';
import 'package:ahadmobile/repository/AudioRepository.dart';
import 'package:ahadmobile/ui/Common.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:provider/provider.dart';

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
          child: FutureBuilder<List<Audio>>(
            future: AudioRepository().fetchToBeListenedAudiosOfUser(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Audio> audios = snapshot.data;

                if (audios.length > 0 ) {
                  audios.sort((a, b) => a.user.firstName.compareTo(b.user.firstName));

                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 8),
                          ListView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              return _AudioTblItemList(audios.elementAt(index));
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
                              TextSpan(text: 'Sauvegarder des audios pour plus tard en cliquant sur le bouton ', style: Theme.of(context).textTheme.subhead,),
                              WidgetSpan(child: Icon(Icons.more_vert)),
                            ]
                        ),
                      ),
                    ),
                  );
                }
              } else if (snapshot.hasError) {
                return Center(child: Text('Erreur : ${snapshot.error.toString()}'),);
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
      )
    );
  }
}



class _AudioTblItemList extends StatelessWidget {
  final Audio a;

  _AudioTblItemList(this.a);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: FutureBuilder(
          future: AudioRepository().fetchAudioInfo(a.id),
          builder: (context, snapshot) {
            return ListTile(
                onLongPress: () => showAudioDialog(context, a),
                leading: Consumer<AudioModel>(
                  builder: (context, audio, child) {
                    return IconButton(
                        onPressed: () {
                          Vibrate.canVibrate.then((v){
                            if (v == true){
                              Vibrate.feedback(FeedbackType.light);
                            }
                          });
                          audio.playOrPause(a);
                        },
                        icon: Icon(
                          audio.audio != null &&
                              audio.audio.id == a.id &&
                              audio.audioPlayer.state == AudioPlayerState.PLAYING
                              ? Icons.pause:Icons.play_arrow,)
                    );
                  },
                ),
                //trailing: snapshot.hasData ? _ListenLaterButton(snapshot.data.isTbl, a.id):null,
                trailing: PopupMenuButton(
                  itemBuilder: (_) => <PopupMenuItem<String>>[
                    new PopupMenuItem(
                      child: const Text('Informations'),
                      value: '1',
                    ),
                    new PopupMenuItem(
                      child: const Text('Retirer de la playlist'),
                      value: '2',
                    )
                  ],
                  onSelected: (v) {

                    vibrate(FeedbackType.light);
                    if (v == '1')
                      showAudioDialog(context, a);
                    if (v == '2')
                      AudioRepository().deleteAudioQueueItem(a.id).then((_){
                        Scaffold.of(context).removeCurrentSnackBar();
                        Scaffold.of(context).showSnackBar(new SnackBar(
                          content: Text('Element retiré. Revenir en arrière pour rafraîchir la liste'),
                        ));
                      }).catchError((e){
                        print('${e.toString()}');
                      });
                  },
                ),
                dense: true,
                title: Text (a.title),
                subtitle: Text.rich(
                  TextSpan(
                    text: '${a.user.firstName} ${a.user.lastName} - ', // default text style
                    children: snapshot.hasData ?
                    <TextSpan>[
                      ((a.length - snapshot.data.listening.position)/60).floor() <= 0  ? TextSpan(text: 'Terminé', style: TextStyle(fontWeight: FontWeight.bold)):TextSpan(),
                      snapshot.data.listening.position != 0 && ((a.length - snapshot.data.listening.position)/60).floor() > 0 ? TextSpan(text: '${((a.length - snapshot.data.listening.position)/60).floor()} mn restantes'):TextSpan(),
                      snapshot.data.listening.position == 0 ? TextSpan(text: '${printDuration(a.length)} '):TextSpan(),
                    ]:
                    <TextSpan>[
                      TextSpan(text: 'Chargement ...')
                    ],
                  ),
                )
            );
          },
        )
    );
  }
}