
import 'package:ahadmobile/apihelper/apihelper.dart';
import 'package:ahadmobile/models/Audio.dart';
import 'package:ahadmobile/models/AudioInfo.dart';
import 'package:ahadmobile/ui/Common.dart';

class AudioRepository {
  APIHelper _apiHelper = APIHelper();

  Future<List<Audio>> fetchLastImamsAudiosOfUser(int userId) async {
    var response = await _apiHelper.request("/audio/lastimamaudios", RequestType.GET);
    List<Audio> audios = (response as List).map((i)=>Audio.fromJson(i)).toList();
    return audios;
  }

  Future<Audio> fetchFeaturedAudio() async{
    var response = await _apiHelper.request("/audio/featured", RequestType.GET);
    return Audio.fromJson(response);
  }

  Future<Audio> fetchRandomAudio() async{
    var response = await _apiHelper.request("/audio/random", RequestType.GET);
    return Audio.fromJson(response);
  }

  Future<Audio> fetchLastListenedAudio(int userId) async{
    final queryParameters = {
      'limit': 1.toString(),
      'sort' : 'date',
    };
    final uri = Uri.https('veerse.xyz', '/user/$userId/listenings', queryParameters);
    print('uri :${uri.toString()}');

    return await _apiHelper.request(uri.toString(), RequestType.GET_WITH_PARAMETERS).then((response){
      print('ok');
      // This endpoint returns a list. As we've set limit to 1, we will get
      // only one audio, therefore we return the elementAt(0)
      return (response as List).map((i)=>Audio.fromJson(i)).toList().elementAt(0);
    }).catchError((e){
      print(e.toString());
      return null;
    });
  }

  Future<List<Audio>> lastAudiosAdded() async {
    final queryParameters = {
      'sort': 'date',
      'limit': 5.toString(),
    };

    final uri = Uri.https('veerse.xyz', '/audios', queryParameters);
    var response = await _apiHelper.request(uri.toString(), RequestType.GET_WITH_PARAMETERS);

    List<Audio> audios = (response as List).map((i)=>Audio.fromJson(i)).toList();
    return audios;
  }

  Future<List<Audio>> fetchAllAudiosOfTag(int tagId) async {
    var response = await _apiHelper.request('/tag/$tagId/audios', RequestType.GET);

    List<Audio> audios = (response as List).map((i)=>Audio.fromJson(i)).toList();
    return audios;
  }

  Future<List<Audio>> fetchAllAudiosOfImam(int imamId) async {
    var response = await _apiHelper.request('/user/$imamId/audios', RequestType.GET);

    List<Audio> audios = (response as List).map((i)=>Audio.fromJson(i)).toList();
    return audios;
  }

  //    Listening and IsTBL.
  //    IsTBL : isToBeListened (to be listened later)
  //    Listening : the position of the audio (example: user is at position
  //  00:12:33 of audio A)
  Future<AudioInfo> fetchAudioInfo(int userId, int audioId) async {
    final queryParameters = {
      'userId': userId.toString(),
      'audioId':audioId.toString()
    };

    final uri = Uri.https('veerse.xyz', '/audioinfo', queryParameters);
    var response = await _apiHelper.request(uri.toString(), RequestType.GET_WITH_PARAMETERS);
    return AudioInfo.fromJson(response);
  }

  //    Listening : the position of the audio (example: user is at position
  //  00:12:33 of audio A)
  Future<Listening> fetchListening(int userId, int audioId) async {
    final queryParameters = {
      'userId': userId.toString(),
      'audioId':audioId.toString()
    };

    final uri = Uri.https('veerse.xyz', '/listening', queryParameters);
    var response = await _apiHelper.request(uri.toString(), RequestType.GET_WITH_PARAMETERS);
    return Listening.fromJson(response);
  }

  Future<void> postListening(Listening l) async {
    await _apiHelper.request("/listening", RequestType.POST, l.toJson()).catchError((e){
      // TODO : error to fix here : error when posting listening FormatException: Unexpected end of input (at character 1)
      //print('error when posting listening ${e.toString()}');
    });
  }

  Future<List<Audio>> fetchLastAudioOfUsersImams(int userId) async {
    final queryParameters = {
      'limit': 4.toString(),
      'sort': 'audio_date_added'
    };
    final uri = Uri.https('veerse.xyz', '/user/$userId/imams/audios', queryParameters);
    var response = await _apiHelper.request(uri.toString(), RequestType.GET_WITH_PARAMETERS);

    if(response != null)
      return (response as List).map((i)=>Audio.fromJson(i)).toList();
    else
      return null;
  }

  Future<List<Audio>> fetchLastAudioOfUsersTags(int userId) async {
    final queryParameters = {
      'limit': 4.toString(),
      'sort': 'audio_date_added'
    };
    final uri = Uri.https('veerse.xyz', '/user/$userId/tags/audios', queryParameters);
    var response = await _apiHelper.request(uri.toString(), RequestType.GET_WITH_PARAMETERS);
    if (response != null) {
      return (response as List).map((i)=>Audio.fromJson(i)).toList();
    } else {
      return null;
    }
  }

  Future<List<Audio>> fetchCurrentlyPlayingAudiosOfUser(int userId) async {
    var response = await _apiHelper.request('/user/$userId/listenings', RequestType.GET);

    if (response != null) {
      return (response as List).map((i)=>Audio.fromJson(i)).toList();
    } else {
      return null;
    }
  }

  Future<List<Audio>> fetchLastCurrentlyPlayingAudiosOfUser(int userId) async {
    final queryParameters = {
      'limit': 4.toString(),
      'order': 'position',
    };
    final uri = Uri.https('veerse.xyz', '/user/$userId/listenings', queryParameters);
    var response = await _apiHelper.request(uri.toString(), RequestType.GET_WITH_PARAMETERS);

    if (response != null) {
      return (response as List).map((i)=>Audio.fromJson(i)).toList();
    } else {
      return null;
    }
  }

  Future<List<Audio>> fetchToBeListenedAudiosOfUser(int userId) async {
    final queryParameters = {
      'userId': userId.toString(),
    };
    final uri = Uri.https('veerse.xyz', '/audioqueue', queryParameters);
    var response = await _apiHelper.request(uri.toString(), RequestType.GET_WITH_PARAMETERS);

    if (response != null) {
      return (response as List).map((i)=>Audio.fromJson(i)).toList();
    } else {
      return null;
    }
  }

  Future<void> postAudioQueueItem (ListeningQueueItem item) async {
    await _apiHelper.request('/audioqueue', RequestType.POST, item.toJson());
  }

  Future<void> deleteAudioQueueItem (int userId, int audioId) async {
    final queryParameters = {
      'userId': userId.toString(),
      'audioId':audioId.toString(),
    };
    final uri = Uri.https('veerse.xyz', '/audioqueue', queryParameters);

    await _apiHelper.request(uri.toString(), RequestType.DELETE_WITH_PARAMETERS);
  }

  Future<List<Audio>> fetchTopAudiosOfImam(int imamId) async {
    final queryParameters = {
      'sort': 'top',
      'limit': '3',
    };

    final uri = Uri.https('veerse.xyz', '/user/$imamId/audios', queryParameters);
    var response = await _apiHelper.request(uri.toString(), RequestType.GET_WITH_PARAMETERS);

    if (response != null) {
      return (response as List).map((i)=>Audio.fromJson(i)).toList();
    } else {
      return null;
    }
  }

  Future<List<Audio>> fetchTopAudiosOfTag(int tagId) async {
    final queryParameters = {
      'sort': 'top',
      'limit': '3',
    };

    final uri = Uri.https('veerse.xyz', '/tag/$tagId/audios', queryParameters);
    var response = await _apiHelper.request(uri.toString(), RequestType.GET_WITH_PARAMETERS);

    if (response != null) {
      return (response as List).map((i)=>Audio.fromJson(i)).toList();
    } else {
      return null;
    }
  }
}