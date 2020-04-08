
import 'package:ahadmobile/models/Audio.dart';
import 'package:ahadmobile/models/AudioInfo.dart';
import 'package:ahadmobile/providers/UserModel.dart';
import 'package:ahadmobile/repository/AudioRepository.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';




class AudioModel extends ChangeNotifier {
  AudioRepository audioRepository = new AudioRepository();

  //   Questionable choice, but I store userId inside AudioModel because we need
  //  it when we POST a new Listening or when we GET initial listening position.
  int _userId;
  Audio _currentAudio;
  static AudioPlayer _audioPlayer = new AudioPlayer();
  Duration _audioDuration = new Duration(milliseconds: 0);
  Duration _currentPosition = new Duration(milliseconds: 0);

  set userId (id) => _userId = id;
  set audio (a) => _currentAudio = a;
  Audio get audio => _currentAudio;
  AudioPlayer get audioPlayer => _audioPlayer;
  Duration get audioDuration => _audioDuration;
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

    await audioRepository.fetchListening(_userId, _currentAudio.id).then((Listening onValue) async {
      await audioPlayer.play("https://veerse.xyz/audio/${_currentAudio.id}/download", isLocal: false, position: new Duration(seconds: onValue.position == null || onValue.position == _currentAudio.length ? 0:onValue.position)).then((v){
      }).catchError((e){
        print('Nok $e');
      });
    });


    audioPlayer.onAudioPositionChanged.listen((Duration  p) async {
      //    If we do p.inSeconds%20 == 0, we would send to much request to server
      //  (as seconds does 20.00X, 20.00Y, 20.00Z, ...). So we use milliseconds
      //  instead. We do p.inMilliseconds%20000 < 150 because p.inMilliseconds%20000 == 0
      //  will never be true, position goes forward too fast to be catch
      //  at this exact moment
      if (p.inMilliseconds%20000 < 150 && p.inSeconds > 0) {
        await audioRepository.postListening(new Listening(audioId: _currentAudio.id, userId: _userId, position: p.inSeconds, date: DateTime.now()));
      }
      _currentPosition = p;
      notifyListeners();
    });

    audioPlayer.onDurationChanged.listen((Duration  d) {
      _audioDuration = d;
      notifyListeners();
    });

    audioPlayer.onPlayerCompletion.listen((v) async{
      await audioRepository.postListening(new Listening(audioId: _currentAudio.id, userId: _userId, position: _currentAudio.length, date: DateTime.now()));
    });

    notifyListeners();

    if (Platform.isIOS) {
      print('iOS notification');
      await _audioPlayer.setNotification(
        title: _currentAudio.title,
        artist: _currentAudio.user.firstName,
        albumTitle: 'L\'labum',
        imageUrl: "https://veerse.xyz/user/${_currentAudio.user.id}/avatar",
        duration: _audioDuration,
        elapsedTime: _currentPosition
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

  void setCurrentPosition (Duration d) {
    this._currentPosition = d;
    notifyListeners();
  }

  void dismissNotification(){
    FlutterLocalNotificationsPlugin().cancelAll();
  }

  void wipeAudio(){
    this._currentAudio = null;
    notifyListeners();
  }
}