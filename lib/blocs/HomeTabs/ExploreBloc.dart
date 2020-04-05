

import 'package:ahadmobile/blocs/HomeTabs/ExploreEvents.dart';
import 'package:ahadmobile/blocs/HomeTabs/ExploreStates.dart';
import 'package:ahadmobile/repository/AudioRepository.dart';
import 'package:ahadmobile/repository/TagRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState>{
  AudioRepository _audioRepository = new AudioRepository();
  TagRepository _tagRepository = new TagRepository();

  @override
  ExploreState get initialState => ExploreInitial();

  @override
  Stream<ExploreState> mapEventToState(ExploreEvent event) async* {
    if(event is FetchExplore){
      try{
        yield ExploreLoading();
        var a = await _audioRepository.fetchAllAudios();
        var b = await _tagRepository.fetchAllTags();

        yield ExploreLoaded(allAudios: a, allTags: b);
      } catch(error){
        yield ExploreLoadFailure(e: error);
      }
    }
  }

}