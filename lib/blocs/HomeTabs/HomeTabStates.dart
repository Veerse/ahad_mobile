
import 'package:ahadmobile/models/Announcement.dart';
import 'package:ahadmobile/models/Audio.dart';
import 'package:equatable/equatable.dart';

class HomeTabState extends Equatable{
  const HomeTabState();

  @override
  List<Object> get props => [];
}

class HomeTabInitial extends HomeTabState{}

class HomeTabLoading extends HomeTabState{}

class HomeTabLoaded extends HomeTabState{
  final Announcement announcement;
  final List<Audio> lastImamsAudios;
  final List<Audio> lastMosquesAudios;
  final Audio featuredAudio;

  const HomeTabLoaded({
    this.announcement,
    this.lastImamsAudios,
    this.lastMosquesAudios,
    this.featuredAudio});
}

class HomeTabLoadFailure extends HomeTabState{
  final Error e;
  const HomeTabLoadFailure({this.e});
}