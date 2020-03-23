
import 'package:ahadmobile/models/Audio.dart';
import 'package:equatable/equatable.dart';

class LibraryState extends Equatable{
  const LibraryState();

  @override
  List<Object> get props => [];
}

class LibraryInitial extends LibraryState{

}

class LibraryLoading extends LibraryState{}

class LibraryLoaded extends LibraryState {

  final List<Audio> lastOfUsersTags;
  final List<Audio> lastOfUsersImams;
  final List<Audio> currentlyListeningOfUser;
  final List<Audio> toBeListenedForUser;


  const LibraryLoaded({this.lastOfUsersTags, this.lastOfUsersImams,
    this.currentlyListeningOfUser, this.toBeListenedForUser});
}

class LibraryLoadFailure extends LibraryState{
  final Error e;
  const LibraryLoadFailure({this.e});
}