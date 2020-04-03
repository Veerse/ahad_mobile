

import 'package:ahadmobile/models/Announcement.dart';
import 'package:ahadmobile/models/Audio.dart';
import 'package:equatable/equatable.dart';

class ExploreState extends Equatable{
  const ExploreState();

  @override
  List<Object> get props => [];
}

class ExploreInitial extends ExploreState{

}

class ExploreLoading extends ExploreState{}

class ExploreLoaded extends ExploreState{
  final List<Audio> allAudios;

  const ExploreLoaded({
    this.allAudios,
  });
}

class ExploreLoadFailure extends ExploreState{
  final Error e;
  const ExploreLoadFailure({this.e});
}