
import 'package:ahadmobile/blocs/HomeTabs/HomeEvents.dart';
import 'package:ahadmobile/blocs/HomeTabs/HomeStates.dart';
import 'package:ahadmobile/repository/AnnouncementRepository.dart';
import 'package:ahadmobile/repository/AudioRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState>{
  AnnouncementRepository _announcementRepository = new AnnouncementRepository();
  AudioRepository _audioRepository = new AudioRepository();

  @override
  HomeState get initialState => HomeInitial();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if(event is FetchHome){
      try{
        yield HomeLoading();
        var a = await _announcementRepository.fetchAnnouncement();
        //var b = await _audioRepository.fetchLastImamsAudiosOfUser(event.userId);
        var c = await _audioRepository.fetchFeaturedAudio();
        var d = await _audioRepository.fetchRandomAudio();
        var e = await _audioRepository.fetchLastListenedAudio(event.userId);

        yield HomeLoaded(announcement: a, lastImamsAudios: null, lastMosquesAudios: null, featuredAudio: c, randomAudio: d, lastListenedAudio: e);
        //yield HomeTabLoaded(announcement: a, lastImamsAudios: b, lastMosquesAudios: b, featuredAudio: c);
      } catch(error){
        yield HomeLoadFailure(e: error);
      }
    }
  }

}