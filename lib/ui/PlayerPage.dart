
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
                  image: NetworkImage('https://veerse.xyz/user/${Provider.of<AudioModel>(context, listen: true).audio.user.id}/avatar'),
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
            Text('${Provider.of<AudioModel>(context, listen: true).audio.title}', style: Theme.of(context).textTheme.title),
            SizedBox(height: 8),
            Text('${Provider.of<AudioModel>(context, listen: true).audio.user.firstName}', style: Theme.of(context).textTheme.subtitle),
            SizedBox(height: 8),
            Text('Duration : ${Provider.of<AudioModel>(context, listen: true).audioPlayer.getDuration()}'),
            FutureBuilder(
              future: Provider.of<AudioModel>(context, listen: true).audioPlayer.getDuration(),
              builder: (context, snapshot){
                if (snapshot.hasData){
                  return Text('${snapshot.data}');
                } else {
                  return Text('aucune idée gros');
                }
              },
            ),
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