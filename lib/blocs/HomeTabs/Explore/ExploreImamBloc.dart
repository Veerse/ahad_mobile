

import 'package:ahadmobile/blocs/HomeTabs/Explore/ExploreImamEvents.dart';
import 'package:ahadmobile/blocs/HomeTabs/Explore/ExploreImamStates.dart';
import 'package:ahadmobile/repository/AudioRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExploreImamBloc extends Bloc<ExploreImamEvent, ExploreImamState>{
  AudioRepository _audioRepository = new AudioRepository();

  @override
  ExploreImamState get initialState => ExploreImamInitial();

  @override
  Stream<ExploreImamState> mapEventToState(ExploreImamEvent event) async* {
    if(event is FetchExploreImam){
      try{
        yield ExploreImamLoading();
        var a = await _audioRepository.fetchAllAudiosOfImam(event.imam.id);

        yield ExploreImamLoaded(allAudios: a, imam: event.imam);
      } catch(error){
        yield ExploreImamLoadFailure(e: error);
      }
    }
  }

}