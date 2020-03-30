
import 'package:ahadmobile/providers/AudioModel.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class PlayerPage extends StatelessWidget {
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
                  image: NetworkImage('http://10.0.2.2:8095/user/${Provider.of<AudioModel>(context, listen: true).audio.user.id}/avatar'),
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
            SizedBox(height: 32),
            Text('Le titre de test', style: Theme.of(context).textTheme.title),
            SizedBox(height: 8),
            Text('Imam Hassan Iquioussen', style: Theme.of(context).textTheme.subtitle),
            FutureBuilder(
              future: Provider.of<AudioModel>(context, listen: true).audioPlayer.getDuration(),
              builder: (context, snapshot){
                if (snapshot.hasData){
                  return Slider(
                    onChanged: (d) => Provider.of<AudioModel>(context, listen: false).audioPlayer.seek(new Duration(milliseconds: d.toInt())),
                    value: Provider.of<AudioModel>(context, listen: true).getPosition,
                    min: 0,
                    max: double.parse(snapshot.data.toString()),
                  );
                } else {
                  return Container();
                }
              },
            ),
            SizedBox(height: 8),
            Text('${Provider.of<AudioModel>(context).getPosition}'),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  onPressed: () => Provider.of<AudioModel>(context, listen: false).playOrPause(),
                  icon: Consumer<AudioModel>(
                    builder: (context, audio, child){
                      switch (audio.audioPlayer.state ) {
                        case AudioPlayerState.PAUSED:
                          return Icon(Icons.play_arrow);
                          break;
                        case AudioPlayerState.PLAYING:
                          return Icon(Icons.pause);
                          break;
                        default:
                          return Text(audio.audioPlayer.state.toString());
                          break;
                      }
                    },
                  ),
                )
              ],
            )
          ],
        ),
      )
    );
  }


}