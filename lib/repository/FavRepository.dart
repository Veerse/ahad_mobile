
import 'dart:developer';

import 'package:ahadmobile/apihelper/apihelper.dart';
import 'package:ahadmobile/apihelper/customexception.dart';
import 'package:ahadmobile/models/Favs.dart';
import 'package:ahadmobile/providers/UserModel.dart';

class FavRepository {
  APIHelper _apiHelper = APIHelper();

  Future<bool> fetchTagIsFav (int tagId) async {
    int userId = UserModel().user.id;

    return await _apiHelper.request('/user/$userId/favoritetag/$tagId', RequestType.GET).then((v){
      return true;
    }).catchError((e){
      log('Error when fetching if tag $tagId is faved by user $userId : ${e.toString()} ee ${e}');
      throw e;
    });
  }

  Future<void> createTagFav(FavTag f) async {
    await _apiHelper.request('/user/${f.userId}/favoritetags', RequestType.POST, f).catchError((e){
      log('Error when creating tag ${f.tagId} fav for user ${f.userId} : ${e.toString()}');
      throw e;
    });
  }

  Future<void> deleteFavTag(FavTag f) async {
    final queryParameters = {
      'tagId': f.tagId.toString(), // Imam
    };
    final uri = Uri.https('veerse.xyz', '/user/${f.userId}/favoritetags', queryParameters);

    await _apiHelper.request(uri.toString(), RequestType.DELETE_WITH_PARAMETERS).catchError((e){
      log('Error when deleting tag ${f.tagId} for user ${f.userId} : ${e.toString()}');
      throw e;
    });
  }

  Future<bool> fetchImamIsFav (int imamId) async {
    int userId = UserModel().user.id;

    return await _apiHelper.request('/user/$userId/favoriteimam/$imamId', RequestType.GET).then((v){
      return true;
    }).catchError((e){
      log('Error when fetching if imam $imamId is faved by user $userId : ${e.toString()}');
      throw e;
    });
  }

  Future<void> createImamFav(FavImam f) async {
    await _apiHelper.request('/user/${f.userId}/favoriteimams', RequestType.POST, f).catchError((e){
      log('Error when creating imam ${f.imamId} fav for user ${f.userId} : ${e.toString()}');
      throw e;
    });
  }

  Future<void> deleteImamFav(FavImam f) async {
    final queryParameters = {
      'imamId': f.imamId.toString(), // Imam
    };
    final uri = Uri.https('veerse.xyz', '/user/${f.userId}/favoriteimams', queryParameters);

    return await _apiHelper.request(uri.toString(), RequestType.DELETE_WITH_PARAMETERS).catchError((e){
      log('Error when deleting imam ${f.imamId} of user ${f.userId} : ${e.toString()}');
      throw e;
    });
  }
}