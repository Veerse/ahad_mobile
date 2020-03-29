
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
            onPressed: () => Provider.of<AudioModel>(context, listen: false).play(),
            child: Text('Play'),
          ),
          RaisedButton(
            onPressed: () => Provider.of<AudioModel>(context, listen: false).pause(),
            child: Text('Pause'),
          ),
          RaisedButton(
            onPressed: () => Provider.of<AudioModel>(context, listen: false).stop(),
            child: Text('Stop'),
          )
        ],
      ),
    );
  }

}