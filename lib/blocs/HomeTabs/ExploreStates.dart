

import 'package:ahadmobile/models/Audio.dart';
import 'package:ahadmobile/models/Tag.dart';
import 'package:ahadmobile/models/User.dart';
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
  final List<Audio> lastAudiosAdded;
  final List<Tag> allTags;
  final List<User> allImams;

  const ExploreLoaded({
    this.lastAudiosAdded,
    this.allTags,
    this.allImams,
  });
}

class ExploreLoadFailure extends ExploreState{
  final Error e;
  const ExploreLoadFailure({this.e});
}