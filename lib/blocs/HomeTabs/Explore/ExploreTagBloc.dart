

import 'package:ahadmobile/blocs/HomeTabs/Explore/ExploreTagEvents.dart';
import 'package:ahadmobile/blocs/HomeTabs/Explore/ExploreTagStates.dart';
import 'package:ahadmobile/repository/AudioRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExploreTagBloc extends Bloc<ExploreTagEvent, ExploreTagState>{
  AudioRepository _audioRepository = new AudioRepository();

  @override
  ExploreTagState get initialState => ExploreTagInitial();

  @override
  Stream<ExploreTagState> mapEventToState(ExploreTagEvent event) async* {
    if(event is FetchExploreTag){
      try{
        yield ExploreTagLoading();
        var a = await _audioRepository.fetchAllAudiosOfTag(event.tag.id);
        //var b = await _audioRepository.fetchTopAudiosOfTag(event.tag.id);

        yield ExploreTagLoaded(allAudios: a, topAudios: null, tag: event.tag);
      } catch(error){
        yield ExploreTagLoadFailure(e: error);
      }
    }
  }

}