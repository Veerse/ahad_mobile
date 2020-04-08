
import 'package:ahadmobile/models/Audio.dart';
import 'package:ahadmobile/providers/AudioModel.dart';
import 'package:ahadmobile/providers/UserModel.dart';
import 'package:ahadmobile/repository/AudioRepository.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;

String printDuration(int seconds) {
  Duration duration = new Duration(seconds: seconds);

  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}

class AudioItemList extends StatelessWidget {
  final Audio a;

  AudioItemList(this.a);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
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
        trailing: _ListenLaterButton(),
        dense: true,
        title: Text (a.title),
        subtitle: FutureBuilder(
          future: AudioRepository().fetchAudioInfo(Provider.of<UserModel>(context, listen:false).user.id, a.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text.rich(
                TextSpan(
                  text: '${a.user.firstName} ${a.user.lastName} - ', // default text style
                  children: <TextSpan>[
                    ((a.length - snapshot.data.listening.position)/60).floor() <= 0  ? TextSpan(text: 'Terminé', style: TextStyle(fontWeight: FontWeight.bold)):TextSpan(),
                    snapshot.data.listening.position != 0 && ((a.length - snapshot.data.listening.position)/60).floor() > 0 ? TextSpan(text: '${((a.length - snapshot.data.listening.position)/60).floor()} mn restantes'):TextSpan(),
                    snapshot.data.listening.position == 0 ? TextSpan(text: '${printDuration(a.length)}'):TextSpan(),
                  ],
                ),
              );
            } else {
              return SpinKitThreeBounce(
                color: Colors.grey,
                size: 15,
              );
            }
          },
        ),

      ),
    );
  }
}

class _ListenLaterButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ListenLaterState();

}

class _ListenLaterState extends State<_ListenLaterButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => print('Added to favorites'),
      icon: Icon(Icons.add),
    );
  }

}

void showAudioDialog(context, Audio a) {
  Vibrate.canVibrate.then((v){
    if (v == true){
      Vibrate.feedback(FeedbackType.light);
    }
  });

  slideDialog.showSlideDialog(
      context: context,
      child: Expanded(
        child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                //mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('${a.title}', style: Theme.of(context).textTheme.title, textAlign: TextAlign.justify,),
                  SizedBox(height: 8),
                  Text('${a.user.firstName} ${a.user.lastName}', style: Theme.of(context).textTheme.caption),
                  SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff7c94b6),
                      image: DecorationImage(
                        image: NetworkImage('https://veerse.xyz/user/${a.user.id}/avatar'),
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: 130,
                    width: 130,
                    alignment: Alignment.bottomRight,
                  ),
                  SizedBox(height: 32),
                  Text('${a.description}', textAlign: TextAlign.justify),
                  SizedBox(height: 32),
                  Text('${Audio.getAudioType(a)} d\'une durée de ${printDuration(a.length)} donné(e) le ${DateFormat('dd-MM-yyyy').format(a.audioDateGiven)}', style: Theme.of(context).textTheme.caption, textAlign: TextAlign.justify),
                  SizedBox(height: 4),
                  FutureBuilder(
                    future: AudioRepository().fetchListening(Provider.of<UserModel>(context, listen:false).user.id, a.id),
                    builder: (context, snapshot){
                      if (snapshot.hasData){
                        if (snapshot.data.position != 0 && snapshot.data.position.toString() != a.length.toString()) {
                          return Text('${((a.length - snapshot.data.position)/60).floor()} minute(s) restante(s) - Denière écoute ${DateFormat('dd-MM-yyyy').format(snapshot.data.date)}', style: Theme.of(context).textTheme.caption, textAlign: TextAlign.justify);
                        } else if (snapshot.data.position.toString() == a.length.toString()){
                          return Text('Audio terminé le ${DateFormat('dd-MM-yyyy').format(snapshot.data.date)}', style: Theme.of(context).textTheme.caption);
                        } else {
                          return Container();
                        }
                      } else {
                        return SpinKitThreeBounce(
                          color: Colors.grey,
                          size: 15,
                        );
                      }
                    },
                  ),
                  SizedBox(height: 32),
                  Consumer<AudioModel>(
                      builder: (context, audio, child){
                        return RaisedButton(
                          onPressed: () {
                            Vibrate.canVibrate.then((v){
                              if (v == true){
                                Vibrate.feedback(FeedbackType.light);
                              }
                            });
                            audio.playOrPause(a);
                          },
                          child: Text(
                              audio.audio != null &&
                                  audio.audio.id == audio.audio.id &&
                                  audio.audioPlayer.state == AudioPlayerState.PLAYING ?
                              'Pause':'Lire'
                          ),
                        );
                      }
                  )
                ],
              ),
            )
        ),
      )
  );
}

class FloatingActionPlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer <AudioModel> (
      builder: (context, audio, child){
        if (audio.audioPlayer.state != null && audio.audioPlayer.state != AudioPlayerState.STOPPED) {
          return GestureDetector(
            onLongPress: () {
              Vibrate.canVibrate.then((v){
                if (v == true){
                  Vibrate.feedback(FeedbackType.light);
                }
              });

              Navigator.pushNamed(context, '/player');
            },
            child: FloatingActionButton(
              onPressed: (){
                Vibrate.canVibrate.then((v){
                  if (v == true){
                    Vibrate.feedback(FeedbackType.light);
                  }
                });
                Provider.of<AudioModel>(context, listen: false).playOrPause();
              },
              child: Icon(audio.audioPlayer.state == AudioPlayerState.PLAYING ? Icons.pause:Icons.play_arrow, size: 32),
              //backgroundColor: Theme.of(context).primaryColor,
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}