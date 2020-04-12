
import 'package:ahadmobile/common/theme.dart';
import 'package:ahadmobile/models/Audio.dart';
import 'package:ahadmobile/providers/AudioModel.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlayerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PlayerPageState();

}

class _PlayerPageState extends State<PlayerPage> {

  bool _isHoldingSlider = false;
  double _newDuration = 0.0;

  String _printDuration(Duration duration) {
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
    return Scaffold(
        body: Stack(
          children: <Widget>[
            CustomPaint(
              child: Container(
                height: Theme.of(context).brightness == ThemeData.dark().brightness ? 0:500,
              ),
              painter: PlayerCurves(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xff7c94b6),
                        image: DecorationImage(
                          image: NetworkImage('https://veerse.xyz/user/${Provider.of<AudioModel>(context, listen: false).audio.user.id}/avatar'),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                          color: Colors.white,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      height: 250,
                      width: 250,
                      alignment: Alignment.bottomRight,
                    ),
                    Consumer<AudioModel>(
                      builder: (context, audio, child){
                        return Column(
                          children: <Widget>[
                            SizedBox(height: 32),
                            Text('${audio.audio.title}', style: Theme.of(context).textTheme.title, textAlign: TextAlign.center),
                            SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(context, '/explore/imam/details', arguments: audio.audio.user),
                              child: Text('${audio.audio.user.firstName} ${audio.audio.user.lastName}'),
                            ),
                            SizedBox(height: 8),
                          ],
                        );
                      },
                    ),
                    Slider(
                      onChangeStart: (p) {
                        setState(() {
                          Provider.of<AudioModel>(context, listen: false).audioPlayer.pause();
                          _isHoldingSlider = true;
                        });
                      },
                      onChangeEnd: (p) {
                        Provider.of<AudioModel>(context, listen: false).audioPlayer.seek(new Duration(seconds: _newDuration.toInt())).then((v){
                          setState(() {
                            _isHoldingSlider = false;
                            Provider.of<AudioModel>(context, listen: false).audioPlayer.resume();
                          });
                        });
                      },
                      onChanged: (p) {
                        setState(() {
                          _newDuration = p;
                        });
                      },
                      value: _isHoldingSlider ? _newDuration:Provider.of<AudioModel>(context, listen: true).currentPosition.inSeconds.toDouble(),
                      min: 0,
                      max: Provider.of<AudioModel>(context, listen: false).audioDuration.inSeconds.toDouble(),
                    ),
                    Text('${_isHoldingSlider ? _printDuration(Duration(seconds: _newDuration.toInt())):_printDuration(Provider.of<AudioModel>(context, listen: false).currentPosition)} : ${_printDuration(Provider.of<AudioModel>(context, listen: true).audioDuration)}'),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                            onPressed: () {
                              var newDuration = new Duration();

                              var currentPos = Provider.of<AudioModel>(context, listen: false).currentPosition.inSeconds;
                              if (currentPos - 10 <=  0) {
                                newDuration = new Duration(seconds: 0);
                              } else {
                                newDuration = new Duration(seconds: currentPos - 10);
                              }
                              Provider.of<AudioModel>(context, listen: false).audioPlayer.seek(newDuration);
                            },
                            icon: Icon(Icons.undo, size: 30)
                        ),
                        SizedBox(width: 16),
                        IconButton(
                            onPressed: () {
                              Vibrate.canVibrate.then((v){
                                if (v == true){
                                  Vibrate.feedback(FeedbackType.light);
                                }
                              });
                              Provider.of<AudioModel>(context, listen: false).playOrPause();
                            },
                            icon: Icon(
                                Provider.of<AudioModel>(context, listen: true).audioPlayer.state == AudioPlayerState.PLAYING ? Icons.pause:Icons.play_arrow,
                                size: 32
                            )
                        ),
                        SizedBox(width: 16),
                        IconButton(
                          onPressed: () {
                            var newDuration = new Duration();

                            var audioDuration = Provider.of<AudioModel>(context, listen: false).audioDuration.inSeconds;
                            var currentPos = Provider.of<AudioModel>(context, listen: false).currentPosition.inSeconds;
                            if (currentPos + 10 >=  audioDuration) {
                              newDuration = new Duration(seconds: audioDuration);
                            } else {
                              newDuration = new Duration(seconds: currentPos + 10);
                            }
                            Provider.of<AudioModel>(context, listen: false).audioPlayer.seek(newDuration);
                          },
                          icon: Icon(Icons.forward_10, size: 30),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Consumer<AudioModel>(
                      builder: (context, audio, child){
                        if (audio.audio.audioDateGiven != null && audio.audio.description != null) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("${audio.audio.description}", textAlign: TextAlign.justify),
                              SizedBox(height: 8),
                              Text('${Audio.getAudioType(audio.audio)} donné le ${DateFormat('dd-MM-yyyy').format(audio.audio.audioDateGiven)}', style: Theme.of(context).textTheme.caption),
                              SizedBox(height: 16),
                              Row(
                                  children: audio.audio.tags.map((t) => GestureDetector(
                                    onTap: () => Navigator.pushNamed(context, '/explore/tag/details', arguments: t),
                                    child: Text('#${t.tagName.toLowerCase()}  ', style: Theme.of(context).textTheme.caption),
                                  )).toList()
                              )
                            ],
                          );
                        } else {
                          return Container();
                        }
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        )
    );
  }
}