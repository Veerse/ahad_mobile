
import 'package:ahadmobile/apihelper/apihelper.dart';
import 'package:ahadmobile/models/Announcement.dart';

class AnnouncementRepository {
  APIHelper _apiHelper = APIHelper();

  Future<Announcement> fetchAnnouncement() async {
    final response = await _apiHelper.request("/announcement", RequestType.GET);
    return Announcement.fromJson(response);
  }

}