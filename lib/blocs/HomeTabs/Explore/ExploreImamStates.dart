

import 'package:ahadmobile/models/Audio.dart';
import 'package:ahadmobile/models/User.dart';
import 'package:equatable/equatable.dart';

class ExploreImamState extends Equatable{
  const ExploreImamState();

  @override
  List<Object> get props => [];
}

class ExploreImamInitial extends ExploreImamState{

}

class ExploreImamLoading extends ExploreImamState{}

class ExploreImamLoaded extends ExploreImamState{
  final List<Audio> allAudios;
  final User imam;

  const ExploreImamLoaded({
    this.allAudios,
    this.imam
  });
}

class ExploreImamLoadFailure extends ExploreImamState{
  final Error e;
  const ExploreImamLoadFailure({this.e});
}