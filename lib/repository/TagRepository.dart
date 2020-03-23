
import 'dart:developer';

import 'package:ahadmobile/apihelper/apihelper.dart';
import 'package:ahadmobile/models/Tag.dart';

class TagRepository {
  static final TagRepository _singleton = TagRepository._internal();

  factory TagRepository() => _singleton;

  TagRepository._internal();

  final APIHelper _apiHelper = APIHelper();

  Future<List<Tag>> fetchAllTags() async {
    return await _apiHelper.request("/tags", RequestType.GET).then((r){
      return (r as List).map((i)=>Tag.fromJson(i)).toList();
    }).catchError((e){
      log(('Error when fetching list of tags ${e.toString()}'));
      throw e;
    });
  }

}