

import 'package:ahadmobile/blocs/HomeTabs/ExploreEvents.dart';
import 'package:ahadmobile/blocs/HomeTabs/ExploreStates.dart';
import 'package:ahadmobile/repository/AnnouncementRepository.dart';
import 'package:ahadmobile/repository/AudioRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState>{
  AnnouncementRepository _announcementRepository = new AnnouncementRepository();
  AudioRepository _audioRepository = new AudioRepository();

  @override
  ExploreState get initialState => ExploreInitial();

  @override
  Stream<ExploreState> mapEventToState(ExploreEvent event) async* {
    if(event is FetchExplore){
      try{
        yield ExploreLoading();
        var a = await _audioRepository.fetchAllAudios();


        yield ExploreLoaded(allAudios: a);
      } catch(error){
        yield ExploreLoadFailure(e: error);
      }
    }
  }

}