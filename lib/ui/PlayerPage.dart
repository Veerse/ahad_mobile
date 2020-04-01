
import 'package:ahadmobile/providers/AudioModel.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayerPage extends StatelessWidget {

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
        body: Center(
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
                  borderRadius: BorderRadius.circular(8),
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
                      Text('${audio.audio.title}', style: Theme.of(context).textTheme.title),
                      SizedBox(height: 8),
                      Text('Imam ${audio.audio.user.firstName} ${audio.audio.user.lastName}'),
                      SizedBox(height: 8),

                    ],
                  );
                },
              ),
              Slider(
                onChangeStart: (p) => print('END $p'),
                onChangeEnd: (p) => Provider.of<AudioModel>(context, listen: false).audioPlayer.seek(new Duration(milliseconds: p.toInt())),
                onChanged: (p) => Provider.of<AudioModel>(context, listen: false).setCurrentPosition(new Duration(milliseconds: p.toInt())),
                value: Provider.of<AudioModel>(context, listen: false).currentPosition.inMilliseconds.toDouble(),
                min: 0,
                max: Provider.of<AudioModel>(context, listen: false).audioDuration.inMilliseconds.toDouble(),
              ),
              Text('${_printDuration(Provider.of<AudioModel>(context, listen: false).currentPosition)} : ${_printDuration(Provider.of<AudioModel>(context, listen: true).audioDuration)}'),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                      onPressed: () => Provider.of<AudioModel>(context, listen: false).playOrPause(),
                      icon: Icon(Provider.of<AudioModel>(context, listen: true).audioPlayer.state == AudioPlayerState.PLAYING ? Icons.pause:Icons.play_arrow)
                  )
                ],
              )
            ],
          ),
        )
    );
  }


}