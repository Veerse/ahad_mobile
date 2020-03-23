
import 'package:ahadmobile/models/User.dart';
import 'package:equatable/equatable.dart';

abstract class ExploreImamEvent extends Equatable{
  const ExploreImamEvent();

  @override
  List<Object> get props => [];
}

class FetchExploreImam extends ExploreImamEvent{
  final int userId;
  final User imam;

  FetchExploreImam({
    this.userId,
    this.imam,
  });
}