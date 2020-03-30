
import 'package:ahadmobile/providers/AudioModel.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExploreTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          RaisedButton(
            onPressed: () => Provider.of<AudioModel>(context, listen: false).initializeAndPlay(),
            child: Text('Audio box'),
          ),
          RaisedButton(
            onPressed: () => Provider.of<AudioModel>(context, listen: false).playOrPause(),
            child: Text('Play button'),
          ),
          RaisedButton(

            onPressed: () => null,// Provider.of<AudioModel>(context, listen: false).stop(),
            child: Text('Stop'),
          ),
          IconButton(
            onPressed: () => Provider.of<AudioModel>(context, listen: false).playOrPause(),
            icon: Consumer<AudioModel>(
              builder: (context, audio, child){
                switch (audio.audioPlayer.state ) {
                  case AudioPlayerState.PAUSED:
                    return Icon(Icons.pause);
                    break;
                  case AudioPlayerState.PLAYING:
                    return Icon(Icons.play_arrow);
                    break;
                  default:
                    return Text(audio.audioPlayer.state.toString());
                    break;
                }
              },
            ),
          )
        ],
      ),
    );
  }

}