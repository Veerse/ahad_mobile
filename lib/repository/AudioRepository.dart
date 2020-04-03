
import 'package:ahadmobile/apihelper/apihelper.dart';
import 'package:ahadmobile/models/Audio.dart';

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

  Future<List<Audio>> fetchAllAudios() async {
    var response = await _apiHelper.request("/audios", RequestType.GET);
    List<Audio> audios = (response as List).map((i)=>Audio.fromJson(i)).toList();
    return audios;
  }
}