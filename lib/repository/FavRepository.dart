
import 'package:ahadmobile/apihelper/apihelper.dart';
import 'package:ahadmobile/models/Favs.dart';

class FavRepository {
  APIHelper _apiHelper = APIHelper();

  Future<bool> fetchTagIsFaved (int tagId, int userId) async {
    var r = await _apiHelper.request('/user/$userId/favoritetag/$tagId', RequestType.GET).then((v){
      return true;
    }).catchError((e){
      if (!e.toString().contains("FormatException")) // TODO : fix this f** error "FormatException: Unexpected end of input (at character 1)"
        throw e;
    });
    return r;
  }

  Future<void> createTagFav(FavTag f) async {
    await _apiHelper.request('/user/${f.userId}/favoritetags', RequestType.POST, f);
  }

  Future<void> deleteFavTag(FavTag f) async {
    final queryParameters = {
      'tagId': f.tagId.toString(), // Imam
    };
    final uri = Uri.https('veerse.xyz', '/user/${f.userId}/favoritetags', queryParameters);

    await _apiHelper.request(uri.toString(), RequestType.DELETE_WITH_PARAMETERS);
  }

  Future<bool> fetchImamIsFaved (int tagId, int userId) async {
    var r = await _apiHelper.request('/user/$userId/favoriteimam/$tagId', RequestType.GET).then((v){
      return true;
    }).catchError((e){
      if (!e.toString().contains("FormatException")) // TODO : fix this f** error "FormatException: Unexpected end of input (at character 1)"
        throw e;
    });
    return r;
  }

  Future<void> createImamFav(FavImam f) async {
    await _apiHelper.request('/user/${f.userId}/favoriteimams', RequestType.POST, f);
  }

  Future<void> deleteImamFav(FavImam f) async {
    final queryParameters = {
      'imamId': f.imamId.toString(), // Imam
    };
    final uri = Uri.https('veerse.xyz', '/user/${f.userId}/favoriteimams', queryParameters);

    await _apiHelper.request(uri.toString(), RequestType.DELETE_WITH_PARAMETERS);
  }
}