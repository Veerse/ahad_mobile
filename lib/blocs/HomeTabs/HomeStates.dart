
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
  final List<Audio> lastImamsAudios;
  final List<Audio> lastMosquesAudios;
  final Audio featuredAudio;

  const HomeLoaded({
    this.announcement,
    this.lastImamsAudios,
    this.lastMosquesAudios,
    this.featuredAudio});
}

class HomeLoadFailure extends HomeState{
  final Error e;
  const HomeLoadFailure({this.e});
}