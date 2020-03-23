
import 'dart:developer';

import 'package:ahadmobile/apihelper/apihelper.dart';
import 'package:ahadmobile/models/Announcement.dart';

class AnnouncementRepository {
  APIHelper _apiHelper = APIHelper();

  Future<Announcement> fetchAnnouncement() async {
    return await _apiHelper.request("/announcement", RequestType.GET).then((r){
      return Announcement.fromJson(r);
    }).catchError((e){
      log(('Error when fetching announcement ${e.toString()}'));
      throw e;
    });
  }
}