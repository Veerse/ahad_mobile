
import 'package:ahadmobile/apihelper/apihelper.dart';
import 'package:ahadmobile/models/Tag.dart';

class TagRepository {
  static final TagRepository _singleton = TagRepository._internal();

  factory TagRepository() => _singleton;

  TagRepository._internal();

  final APIHelper _apiHelper = APIHelper();

  Future<List<Tag>> fetchAllTags() async {
    var response = await _apiHelper.request("/tags", RequestType.GET);
    List<Tag> tags = (response as List).map((i)=>Tag.fromJson(i)).toList();
    return tags;
  }

}