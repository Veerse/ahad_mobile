
import 'package:ahadmobile/models/Audio.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

import 'package:flutter_media_notification/flutter_media_notification.dart';


class AudioModel extends ChangeNotifier {

  Audio audio;

  Audio get getAudio => audio;

  void setAudio(Audio u) {
    this.audio = u;
    notifyListeners();
  }

  AudioPlayer audioPlayer = AudioPlayer();

  bool _isPlaying = false;


  bool get isPlaying => _isPlaying;

  double _currentPosition;

  double get getPosition => _currentPosition;

  void initializeAndPlay(Audio a) async {
    this.audio = a;

    await audioPlayer.play("http://93.6.197.182:8095/audio/${a.id}/download", isLocal: false).then((v){
      print('Playing $v');
    }).catchError((e){
      print('error $e');
    });

    _isPlaying = true;

    audioPlayer.onAudioPositionChanged.listen((Duration d)  {
      _currentPosition = d.inMilliseconds.toDouble();
      notifyListeners();
    });

    var currentOs = Platform.operatingSystem;

    if(currentOs == 'android') {
      print('the droid');
      MediaNotification.setListener('pause', (){
        this.playOrPause();
      });
      MediaNotification.setListener('play', (){
        this.playOrPause();
      });
      MediaNotification.showNotification(
        title: 'Le test',
        author: 'Auteur',
        isPlaying: _isPlaying ? true:false,
      );
    }

    if(currentOs == 'ios') {
      print('ios');
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

    notifyListeners();
  }

  void playOrPause() async {
    if (audioPlayer.state == AudioPlayerState.PAUSED) {
      await audioPlayer.resume();
      _isPlaying = true;
      notifyListeners();
      return;
    }
    if (audioPlayer.state == AudioPlayerState.PLAYING) {
      _isPlaying = false;
      await audioPlayer.pause();
      notifyListeners();
      return;
    }
  }

  void stop() async {
    await audioPlayer.stop();
  }

  void wipeAudio(){
    this.audio = new Audio();
    notifyListeners();
  }


}