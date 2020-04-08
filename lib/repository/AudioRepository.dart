
import 'package:ahadmobile/apihelper/apihelper.dart';
import 'package:ahadmobile/models/Audio.dart';
import 'package:ahadmobile/models/AudioInfo.dart';

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
      'userId': userId.toString(),
    };
    final uri = Uri.https('veerse.xyz', '/audio/lastlistened', queryParameters);
    print('uri :${uri.toString()}');

    var response = await _apiHelper.request(uri.toString(), RequestType.GET_WITH_PARAMETERS);
    return Audio.fromJson(response);
  }

  Future<List<Audio>> fetchAllAudios() async {
    var response = await _apiHelper.request("/audios", RequestType.GET);
    List<Audio> audios = (response as List).map((i)=>Audio.fromJson(i)).toList();
    return audios;
  }

  Future<List<Audio>> fetchAllAudiosOfTag(int tagId) async {
    final queryParameters = {
      'tagId': tagId.toString(),
    };
    final uri = Uri.https('veerse.xyz', '/audios', queryParameters);
    var response = await _apiHelper.request(uri.toString(), RequestType.GET_WITH_PARAMETERS);

    List<Audio> audios = (response as List).map((i)=>Audio.fromJson(i)).toList();
    return audios;
  }

  Future<List<Audio>> fetchAllAudiosOfImam(int imamId) async {
    final queryParameters = {
      'imamId': imamId.toString(),
    };
    final uri = Uri.https('veerse.xyz', '/audios', queryParameters);
    var response = await _apiHelper.request(uri.toString(), RequestType.GET_WITH_PARAMETERS);

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
    print(response);
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
}