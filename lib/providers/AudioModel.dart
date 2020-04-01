
import 'dart:math';

import 'package:ahadmobile/models/Audio.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';




class AudioModel extends ChangeNotifier {

  Audio _currentAudio;
  static AudioPlayer _audioPlayer = new AudioPlayer();
  Duration _currentPosition = new Duration(milliseconds: 0);

  Audio get audio => _currentAudio;
  AudioPlayer get audioPlayer => _audioPlayer;
  Duration get currentPosition => _currentPosition;

  void playOrPause([Audio a]) async {
    if (a == null) {
      if (_currentAudio == null) {
        return;
      } else {
        _playOrPause();
        notifyListeners();
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
    await audioPlayer.play("https://veerse.xyz/audio/${_currentAudio.id}/download", isLocal: false).then((v){
      print('Playing $v');
    }).catchError((e){
      print('Nok $e');
    });

    audioPlayer.onAudioPositionChanged.listen((Duration  p) {
      //print('Current position: $p');
        //setState(() => position = p);
      _currentPosition = p;
      notifyListeners();
    });

    notifyListeners();

    if (Platform.isIOS) {
      print('iOS notification');
      await _audioPlayer.setNotification(
          title: _currentAudio.title,
          artist: _currentAudio.user.firstName,
          albumTitle: 'L\'labum',
          imageUrl: "https://veerse.xyz/user/${_currentAudio.user.id}/avatar"
      );
    }

    if (Platform.isAndroid && 1 == 2) {
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
      var initializationSettingsAndroid = AndroidInitializationSettings("ic_launcher");

      var initializationSettings = InitializationSettings(
          initializationSettingsAndroid, null);
      await flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: null);


      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        '0', 'AhChanad', 'Ahad notifications',
        importance: Importance.Max, priority: Priority.High,
        playSound: false, style: AndroidNotificationStyle.Media, channelShowBadge: false,
        visibility: NotificationVisibility.Public, autoCancel: false,
      );

      var platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, null);

      await flutterLocalNotificationsPlugin.show(
          0, '${_currentAudio.title}', '${_currentAudio.user.firstName}', platformChannelSpecifics,
          payload: 'item x');
    }
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

  void dismiss(){
    FlutterLocalNotificationsPlugin().cancelAll();
  }

  void wipeAudio(){
    this._currentAudio = null;
    notifyListeners();
  }
}