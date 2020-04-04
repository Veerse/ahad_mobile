
import 'package:ahadmobile/models/Audio.dart';
import 'package:ahadmobile/models/User.dart';
import 'package:ahadmobile/providers/AudioModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchTab extends StatelessWidget {
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
            onPressed: () => Provider.of<AudioModel>(context, listen: false).playOrPause(new Audio(id: 3, title: 'Audio deux', user: new User(id: 3, firstName: 'Imam 2'))),
            child: Text('Audio box 2'),
          ),
          RaisedButton(
            onPressed: () => Provider.of<AudioModel>(context, listen: false).playOrPause(),
            child: Text('Play button'),
          ),
          RaisedButton(
            onPressed: () => Provider.of<AudioModel>(context, listen: false).dismissNotification(),
            child: Text('Dismiss all notifications'),
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