

import 'package:ahadmobile/blocs/HomeTabs/ExploreEvents.dart';
import 'package:ahadmobile/blocs/HomeTabs/ExploreStates.dart';
import 'package:ahadmobile/repository/AudioRepository.dart';
import 'package:ahadmobile/repository/TagRepository.dart';
import 'package:ahadmobile/repository/UserRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState>{
  AudioRepository _audioRepository = new AudioRepository();
  TagRepository _tagRepository = new TagRepository();
  UserRepository _userRepository = new UserRepository();

  @override
  ExploreState get initialState => ExploreInitial();

  @override
  Stream<ExploreState> mapEventToState(ExploreEvent event) async* {
    if(event is FetchExplore){
      try{
        yield ExploreLoading();
        var a = await _audioRepository.lastAudiosAdded();
        var b = await _tagRepository.fetchAllTags();
        var c = await _userRepository.fetchAllImams();

        yield ExploreLoaded(lastAudiosAdded: a, allTags: b, allImams: c);
      } catch(error){
        yield ExploreLoadFailure(e: error);
      }
    }
  }

}