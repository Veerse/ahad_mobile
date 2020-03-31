
import 'package:ahadmobile/models/Audio.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;



class AudioModel extends ChangeNotifier {

  Audio audio;
  bool _isPlaying = false;

  Audio get getAudio => audio;
  bool get isPlaying => _isPlaying;

  void setAudio(Audio u) {
    this.audio = u;
    notifyListeners();
  }

  void initializeAndPlay(Audio a) async {
    this.audio = a;

    notifyListeners();
  }

  void playOrPause() async {

  }

  void wipeAudio(){
    this.audio = null;
    notifyListeners();
  }
}