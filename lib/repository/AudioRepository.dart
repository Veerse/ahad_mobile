
import 'dart:developer';

import 'package:ahadmobile/apihelper/apihelper.dart';
import 'package:ahadmobile/models/Audio.dart';
import 'package:ahadmobile/models/AudioInfo.dart';
import 'package:ahadmobile/providers/UserModel.dart';

class AudioRepository {
  APIHelper _apiHelper = APIHelper();

  Future<List<Audio>> fetchLastImamsAudiosOfUser() async {
    int userId = UserModel().user.id;

    return await _apiHelper.request("/audio/lastimamaudios", RequestType.GET).then((v){
      return (v as List).map((i)=>Audio.fromJson(i)).toList();
    }).catchError((e){
      print('Error when fetching last imams audios of user ${e.toString()}');
      throw e;
    });
  }

  Future<Audio> fetchFeaturedAudio() async{
    return await _apiHelper.request("/audio/featured", RequestType.GET).then((v){
      return Audio.fromJson(v);
    }).catchError((e){
      print('Error when fetching featured audio ${e.toString()}');
      throw e;
    });
  }

  Future<Audio> fetchRandomAudio() async{
    return await _apiHelper.request("/audio/random", RequestType.GET).then((v){
      return Audio.fromJson(v);
    }).catchError((e){
      print('Error when fetching random audio ${e.toString()}');
      throw e;
    });
  }

  Future<Audio> fetchLastListenedAudio() async{
    final queryParameters = {
      'limit': 1.toString(),
      'sort' : 'date',
    };

    int userId = UserModel().user.id;

    final uri = Uri.https('veerse.xyz', '/user/$userId/listenings/audios', queryParameters);

    return await _apiHelper.request(uri.toString(), RequestType.GET_WITH_PARAMETERS).then((r){
      if (r == null) return null;
      // This endpoint returns a list. As we've set limit to 1, we will get
      // only one audio, therefore we return the elementAt(0)
      return (r as List).map((i)=>Audio.fromJson(i)).toList().elementAt(0);
    }).catchError((e){
      log('Error when fetching last listened audio : ${e.toString()}');
      return null;
    });
  }

  Future<List<Audio>> lastAudiosAdded() async {
    final queryParameters = {
      'sort': 'date',
      'limit': 5.toString(),
    };

    final uri = Uri.https('veerse.xyz', '/audios', queryParameters);
    return await _apiHelper.request(uri.toString(), RequestType.GET_WITH_PARAMETERS).then((r){
      return (r as List).map((i)=>Audio.fromJson(i)).toList();
    }).catchError((e){
      print('Error when fetching last audios added : ${e.toString()}');
      throw e;
    });
  }

  Future<List<Audio>> fetchAllAudiosOfTag(int tagId) async {
    return await _apiHelper.request('/tag/$tagId/audios', RequestType.GET).then((v){
      return (v as List).map((i)=>Audio.fromJson(i)).toList();
    }).catchError((e){
      print('Error when fetching audios of tag $tagId : ${e.toString()}');
      throw e;
    });
  }

  Future<List<Audio>> fetchAllAudiosOfImam(int imamId) async {
    return await _apiHelper.request('/user/$imamId/audios', RequestType.GET).then((v){
      return (v as List).map((i)=>Audio.fromJson(i)).toList();
    }).catchError((e){
      print('Error when fetching audios of imam $imamId : ${e.toString()}');
      throw e;
    });
  }

  //    Listening and IsTBL.
  //    IsTBL : isToBeListened (to be listened later)
  //    Listening : the position of the audio (example: user is at position
  //  00:12:33 of audio A)
  Future<AudioInfo> fetchAudioInfo(int audioId) async {
    final queryParameters = {
      'audioId':audioId.toString()
    };

    int userId = UserModel().user.id;

    final uri = Uri.https('veerse.xyz', '/user/$userId/audios/$audioId/status', queryParameters);
    return await _apiHelper.request(uri.toString(), RequestType.GET_WITH_PARAMETERS).then((r){
      return AudioInfo.fromJson(r);
    }).catchError((e){
      log('Error when fetching audio info for audio $audioId for user $userId : ${e.toString()}');
      throw e;
    });
  }

  //    Listening : the position of the audio (example: user is at position
  //  00:12:33 of audio A)
  Future<Listening> fetchListening(int audioId) async {
    final queryParameters = {
      'audioId':audioId.toString()
    };

    int userId = UserModel().user.id;

    final uri = Uri.https('veerse.xyz', '/user/$userId/listening', queryParameters);
    return await _apiHelper.request(uri.toString(), RequestType.GET_WITH_PARAMETERS).then((r){
      return Listening.fromJson(r);
    }).catchError((e){
      log('Error when fetching listening for user $userId for audio $audioId : ${e.toString()}');
      throw e;
    });
  }

  Future<void> postListening(Listening l) async {
    await _apiHelper.request("/listening", RequestType.POST, l.toJson()).catchError((e){
      print('Error when posting listening : ${e.toString()}');
    });
  }

  Future<List<Audio>> fetchLastAudioOfUsersImams() async {
    final queryParameters = {
      'limit': 4.toString(),
      'sort': 'audio_date_added'
    };

    int userId = UserModel().user.id;

    final uri = Uri.https('veerse.xyz', '/user/$userId/imams/audios', queryParameters);

    return await _apiHelper.request(uri.toString(), RequestType.GET_WITH_PARAMETERS).then((r){
      if(r == null) return null;
      return (r as List).map((i)=>Audio.fromJson(i)).toList();
    }).catchError((e){
      print('Error when fetching last audio of user $userId\'s imams : ${e.toString()}');
      throw e;
    });
  }

  Future<List<Audio>> fetchLastAudioOfUsersTags() async {
    final queryParameters = {
      'limit': 4.toString(),
      'sort': 'audio_date_added'
    };

    int userId = UserModel().user.id;

    final uri = Uri.https('veerse.xyz', '/user/$userId/tags/audios', queryParameters);

    return await _apiHelper.request(uri.toString(), RequestType.GET_WITH_PARAMETERS).then((r){
      if (r == null)  return null;
      return (r as List).map((i)=>Audio.fromJson(i)).toList();
    }).catchError((e){
      print('Error when fetching last audio of user $userId\'s tags : ${e.toString()}');
      throw e;
    });
  }

  Future<List<Audio>> fetchCurrentlyPlayingAudiosOfUser() async {
    int userId = UserModel().user.id;

    return await _apiHelper.request('/user/$userId/listenings/audios', RequestType.GET).then((r){
      if(r == null) return null;
      return (r as List).map((i)=>Audio.fromJson(i)).toList();
    }).catchError((e){
      log('Error when fetching currently playing audios of user $userId : ${e.toString()}');
      throw e;
    });
  }

  Future<List<Audio>> fetchLastCurrentlyPlayingAudiosOfUser() async {
    final queryParameters = {
      'limit': 4.toString(),
      'order': 'position',
    };

    int userId = UserModel().user.id;

    final uri = Uri.https('veerse.xyz', '/user/$userId/listenings/audios', queryParameters);
    return await _apiHelper.request(uri.toString(), RequestType.GET_WITH_PARAMETERS).then((r){
      if (r == null)  return null;
      return (r as List).map((i)=>Audio.fromJson(i)).toList();
    }).catchError((e){
      log('Error when fetching last currently playing audios of user');
      throw e;
    });
  }

  Future<List<Audio>> fetchToBeListenedAudiosOfUser() async {
    int userId = UserModel().user.id;
    final queryParameters = {
      'userId': userId.toString(),
    };

    final uri = Uri.https('veerse.xyz', '/user/$userId/audioqueue/audios', queryParameters);
    return await _apiHelper.request(uri.toString(), RequestType.GET_WITH_PARAMETERS).then((r){
      if (r == null)  return null;
      return (r as List).map((i)=>Audio.fromJson(i)).toList();
    }).catchError((e){
      log('Error when fetching audios to be listenned by user $userId');
      throw e;
    });
  }

  Future<void> postAudioQueueItem (ListeningQueueItem item) async {
    await _apiHelper.request('/audioqueue', RequestType.POST, item.toJson()).catchError((e){
      log('Error in postAudioQueueItem : (POST) /audioqueue ${e.toString()}');
      throw e;
    });
  }

  Future<void> deleteAudioQueueItem (int audioId) async {
    final queryParameters = {
      'audioId':audioId.toString(),
    };

    int userId = UserModel().user.id;

    final uri = Uri.https('veerse.xyz', '/user/$userId/audioqueue', queryParameters);

    await _apiHelper.request(uri.toString(), RequestType.DELETE_WITH_PARAMETERS).catchError((e){
      log('Error in deleteAudioQueueItem : (DELETE) /user/$userId/audioqueue : ${e.toString()}');
      throw e;
    });
  }

  Future<List<Audio>> fetchTopAudiosOfImam(int imamId) async {
    final queryParameters = {
      'sort': 'top',
      'limit': '3',
    };

    final uri = Uri.https('veerse.xyz', '/user/$imamId/audios', queryParameters);

    return await _apiHelper.request(uri.toString(), RequestType.GET_WITH_PARAMETERS).then((r){
      if (r == null)  return null;
      return (r as List).map((i)=>Audio.fromJson(i)).toList();
    }).catchError((e){
      log('Error when fetching top audios of imam $imamId : ${e.toString()}');
      throw e;
    });
  }

  Future<List<Audio>> fetchTopAudiosOfTag(int tagId) async {
    final queryParameters = {
      'sort': 'top',
      'limit': '3',
    };

    final uri = Uri.https('veerse.xyz', '/tag/$tagId/audios', queryParameters);
    return await _apiHelper.request(uri.toString(), RequestType.GET_WITH_PARAMETERS).then((r){
      if (r == null)  return null;
      return (r as List).map((i)=>Audio.fromJson(i)).toList();
    }).catchError((e){
      log('Error when fetching top audios of tag $tagId');
      throw e;
    });
  }
}