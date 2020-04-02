
import 'package:ahadmobile/blocs/HomeTabs/HomeTabEvents.dart';
import 'package:ahadmobile/blocs/HomeTabs/HomeTabStates.dart';
import 'package:ahadmobile/repository/AnnouncementRepository.dart';
import 'package:ahadmobile/repository/AudioRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeTabBloc extends Bloc<HomeTabEvent, HomeTabState>{
  AnnouncementRepository _announcementRepository = new AnnouncementRepository();
  AudioRepository _audioRepository = new AudioRepository();

  @override
  HomeTabState get initialState => HomeTabInitial();

  @override
  Stream<HomeTabState> mapEventToState(HomeTabEvent event) async* {
    if(event is FetchHomeTab){
      try{
        yield HomeTabLoading();
        var a = await _announcementRepository.fetchAnnouncement();
        //var b = await _audioRepository.fetchLastImamsAudiosOfUser(event.userId);
        var c = await _audioRepository.fetchFeaturedAudio();

        yield HomeTabLoaded(announcement: a, lastImamsAudios: null, lastMosquesAudios: null, featuredAudio: c);
        //yield HomeTabLoaded(announcement: a, lastImamsAudios: b, lastMosquesAudios: b, featuredAudio: c);
      } catch(error){
        yield HomeTabLoadFailure(e: error);
      }
    }
  }

}