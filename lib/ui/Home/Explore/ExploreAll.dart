
import 'package:ahadmobile/models/Audio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExploreAll extends StatelessWidget {

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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Center(
          child: ListView.builder(
            itemCount: allAudios.length,
            itemBuilder: (context, index){
              return Card(
                child: ListTile(
                  leading: IconButton(
                    onPressed: () => print('Taped'),
                    icon: Icon(Icons.play_arrow,)
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

}