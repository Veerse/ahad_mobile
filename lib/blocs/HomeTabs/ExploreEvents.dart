
import 'package:equatable/equatable.dart';

abstract class ExploreEvent extends Equatable{
  const ExploreEvent();

  @override
  List<Object> get props => [];
}

class FetchExplore extends ExploreEvent{
  final int userId;
  FetchExplore({this.userId});
}