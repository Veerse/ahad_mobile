
import 'dart:math';

import 'package:ahadmobile/models/Audio.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;



class AudioModel extends ChangeNotifier {

  Audio _currentAudio;
  static AudioPlayer _audioPlayer = new AudioPlayer();

  Audio get audio => _currentAudio;
  AudioPlayer get audioPlayer => _audioPlayer;

  void playOrPause([Audio a]) async {
    if (a == null) {
      if (_currentAudio == null) {
        return;
      } else {
        _playOrPause();
        return;
      }
    }

    if(a != null && _currentAudio == null){
      _currentAudio = a;
      _initializeAndPlay();
      notifyListeners();
      return;
    }

    if(a.id != _currentAudio.id) {
      _currentAudio = a;
      _initializeAndPlay();
      notifyListeners();
      return;
    }

    if(a.id == _currentAudio.id) {
      _playOrPause();
      notifyListeners();
      return;
    }
  }

  // When playing a new audio
  void _initializeAndPlay() async {
    await audioPlayer.play("http://93.6.197.182:8095/audio/${_currentAudio.id}/download", isLocal: false).then((v){
      print('Playing $v');
    }).catchError((e){
      print('Nok $e');
    });
  }

  // When playing or pausing current audio
  void _playOrPause() async {
    switch (_audioPlayer.state) {
      case AudioPlayerState.PLAYING:
        await _audioPlayer.pause();
        break;
      case AudioPlayerState.PAUSED:
        await _audioPlayer.resume();
        break;
      default:
        break;
    }
  }

  void wipeAudio(){
    this._currentAudio = null;
    notifyListeners();
  }
}