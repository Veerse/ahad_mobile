
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
    await audioPlayer.play("https://file-examples.com/wp-content/uploads/2017/11/file_example_MP3_1MG.mp3", isLocal: false).then((v){
      print('Playing $v');
    }).catchError((e){
      print('error $e');
    });



    audioPlayer.setNotification(
      title: 'Test audio',
      artist: 'The artist',
      albumTitle: 'The album',
      imageUrl: 'https://i.picsum.photos/id/59/200/200.jpg'
    ).then((v){
      print('Notification ok');
    }).catchError((e){
      print('error with setNotification $e');
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