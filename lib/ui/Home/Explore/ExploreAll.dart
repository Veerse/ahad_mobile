
import 'package:ahadmobile/models/Audio.dart';
import 'package:ahadmobile/models/Listening.dart';
import 'package:ahadmobile/providers/AudioModel.dart';
import 'package:ahadmobile/providers/UserModel.dart';
import 'package:ahadmobile/repository/AudioRepository.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ExploreAll extends StatelessWidget {

  final AudioRepository _audioRepository = new AudioRepository();

  String _printDuration(int seconds) {
    Duration duration = new Duration(seconds: seconds);

    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }



    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    final List<Audio> allAudios = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Tous les audios'),
      ),
      floatingActionButton: Consumer <AudioModel> (
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
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Center(
          child: ListView.builder(
            itemCount: allAudios.length,
            itemBuilder: (context, index){
              return Card(
                child: ListTile(
                  onLongPress: () {
                    Vibrate.canVibrate.then((v){
                      if (v == true){
                        Vibrate.feedback(FeedbackType.light);
                      }
                    });
                    _showAudioDialog(context, allAudios.elementAt(index));
                    },
                  leading: IconButton(
                      onPressed: () {
                        Vibrate.canVibrate.then((v){
                          if (v == true){
                            Vibrate.feedback(FeedbackType.light);
                          }
                        });
                        Provider.of<AudioModel>(context, listen: false).playOrPause(allAudios.elementAt(index));
                      },
                      icon: Icon(
                        Provider.of<AudioModel>(context, listen: true).audio != null &&
                        Provider.of<AudioModel>(context, listen: true).audio.id == allAudios.elementAt(index).id &&
                        Provider.of<AudioModel>(context, listen: true).audioPlayer.state == AudioPlayerState.PLAYING
                        ? Icons.pause:Icons.play_arrow,)
                  ),
                  trailing: IconButton(
                    onPressed: () => print('Added to favorites'),
                    icon: Icon(Icons.add),
                  ),
                  dense: true,
                  title: Text (allAudios.elementAt(index).title),
                  subtitle: Text('${allAudios.elementAt(index).user.firstName} ${allAudios.elementAt(index).user.lastName} - ${_printDuration(allAudios.elementAt(index).length)}'),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showAudioDialog(context, Audio a) {
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
                    Text('${Audio.getAudioType(a)} d\'une durée de ${_printDuration(a.length)} donné(e) le ${DateFormat('dd-MM-yyyy').format(a.audioDateGiven)}', style: Theme.of(context).textTheme.caption, textAlign: TextAlign.justify),
                    SizedBox(height: 4),
                    FutureBuilder(
                      future: _audioRepository.fetchListening(Provider.of<UserModel>(context, listen:false).user.id, a.id),
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
                          onPressed: () => audio.playOrPause(a),
                          child: Text(
                              Provider.of<AudioModel>(context, listen: true).audio != null &&
                              Provider.of<AudioModel>(context, listen: true).audio.id == audio.audio.id &&
                              Provider.of<AudioModel>(context, listen: true).audioPlayer.state == AudioPlayerState.PLAYING ?
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
}