
import 'package:ahadmobile/models/Audio.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';

class AudioModel extends ChangeNotifier {
  Audio audio;

  AudioPlayer audioPlayer = AudioPlayer();

  Audio get getAudio => audio;

  var audioUri = "http://93.6.197.182:8095/audio/1/download";

  void setAudio(Audio u) {
    this.audio = u;
    //await _player.setUrl("http://93.6.197.182:8095/${u.id}/download", isLocal: false);
    notifyListeners();
  }

  void play() async {
    await audioPlayer.play("http://93.6.197.182:8095/audio/1/download", isLocal: false).then((v){
      print('Playing $v');
    }).catchError((e){
      print('error $e');
    });
  }

  void pause() async {

    await audioPlayer.pause().then((v){
      audioPlayer.getCurrentPosition().then((d){
        print('Duration : $d');
      });
    }).catchError((e){
      print('Error on pause $e');
    });
  }

  void stop() async {
    await audioPlayer.stop();
  }

  void wipeAudio(){
    this.audio = new Audio();
    notifyListeners();
  }
}