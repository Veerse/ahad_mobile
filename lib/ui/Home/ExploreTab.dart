
import 'package:ahadmobile/models/Audio.dart';
import 'package:ahadmobile/models/User.dart';
import 'package:ahadmobile/providers/AudioModel.dart';
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
            onPressed: () => Provider.of<AudioModel>(context, listen: false).playOrPause(new Audio(id: 1, title: 'Audio un', user: new User(id: 1, firstName: 'Imam 1'))),
            child: Text('Audio box 1'),
          ),
          RaisedButton(
            onPressed: () => Provider.of<AudioModel>(context, listen: false).playOrPause(new Audio(id: 2, title: 'Audio deux', user: new User(id: 2, firstName: 'Imam 2'))),
            child: Text('Audio box 2'),
          ),
          RaisedButton(
            onPressed: () => Provider.of<AudioModel>(context, listen: false).playOrPause(),
            child: Text('Play button'),
          ),
          IconButton(
            onPressed: () => Provider.of<AudioModel>(context, listen: false).playOrPause(),
            icon: Consumer<AudioModel>(
              builder: (context, audio, child){
                return Icon(Icons.play_arrow);
              },
            ),
          )
        ],
      ),
    );
  }

}