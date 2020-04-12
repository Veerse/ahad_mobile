
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
        var b = await _audioRepository.fetchFeaturedAudio();
        var c = await _audioRepository.fetchRandomAudio();
        var d = await _audioRepository.fetchLastListenedAudio(event.userId);
        var e = await _audioRepository.fetchLastCurrentlyPlayingAudiosOfUser(event.userId);

        yield HomeLoaded(announcement: a, featuredAudio: b, randomAudio: c, lastListenedAudio: d, audiosToFinish: e);
      } catch(error){
        yield HomeLoadFailure(e: error);
      }
    }
  }

}