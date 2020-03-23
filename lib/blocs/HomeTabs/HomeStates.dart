
import 'package:ahadmobile/models/Announcement.dart';
import 'package:ahadmobile/models/Audio.dart';
import 'package:equatable/equatable.dart';

class HomeState extends Equatable{
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState{

}

class HomeLoading extends HomeState{}

class HomeLoaded extends HomeState{
  final Announcement announcement;
  final Audio featuredAudio;
  final Audio randomAudio;
  final Audio lastListenedAudio; // Resume
  final List<Audio> audiosToFinish;

  const HomeLoaded({
    this.announcement,
    this.featuredAudio,
    this.randomAudio,
    this.lastListenedAudio,
    this.audiosToFinish
  });
}

class HomeLoadFailure extends HomeState{
  final Error e;
  const HomeLoadFailure({this.e});
}