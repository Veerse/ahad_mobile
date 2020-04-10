
import 'package:ahadmobile/blocs/HomeTabs/LibraryEvents.dart';
import 'package:ahadmobile/blocs/HomeTabs/LibraryStates.dart';
import 'package:ahadmobile/repository/AudioRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState>{
  AudioRepository _audioRepository = new AudioRepository();

  @override
  LibraryState get initialState => LibraryInitial();

  @override
  Stream<LibraryState> mapEventToState(LibraryEvent event) async* {
    if(event is FetchLibrary){
      try{
        yield LibraryLoading();
        var a = await _audioRepository.fetchLastAudioOfUsersImams(event.userId);
        var b = await _audioRepository.fetchLastAudioOfUsersTags(event.userId);
        var c = await _audioRepository.fetchToBeListenedAudiosOfUser(event.userId);
        var d = await _audioRepository.fetchCurrentlyPlayingAudiosOfUser(event.userId);

        //yield LibraryLoaded(lastOfUsersImams: a, lastOfUsersTags: b, toBeListenedForUser: c, currentlyListeningOfUser: d);
        yield LibraryLoaded(lastOfUsersImams: a, lastOfUsersTags: b, toBeListenedForUser: c, currentlyListeningOfUser: d);
      } catch(error){
        yield LibraryLoadFailure(e: error);
      }
    }
  }
}

class _SeparationWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 16),
        Divider(),
        SizedBox(height: 16),
      ],
    );
  }
}

