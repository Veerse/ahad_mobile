

import 'package:ahadmobile/models/Audio.dart';
import 'package:ahadmobile/models/Tag.dart';
import 'package:equatable/equatable.dart';

class ExploreTagState extends Equatable{
  const ExploreTagState();

  @override
  List<Object> get props => [];
}

class ExploreTagInitial extends ExploreTagState{

}

class ExploreTagLoading extends ExploreTagState{}

class ExploreTagLoaded extends ExploreTagState{
  final List<Audio> allAudios;
  final List<Audio> topAudios;
  final Tag tag;

  const ExploreTagLoaded({
    this.allAudios,
    this.topAudios,
    this.tag
  });
}

class ExploreTagLoadFailure extends ExploreTagState{
  final Error e;
  const ExploreTagLoadFailure({this.e});
}