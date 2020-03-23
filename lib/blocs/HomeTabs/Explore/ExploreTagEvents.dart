
import 'package:ahadmobile/models/Tag.dart';
import 'package:equatable/equatable.dart';

abstract class ExploreTagEvent extends Equatable{
  const ExploreTagEvent();

  @override
  List<Object> get props => [];
}

class FetchExploreTag extends ExploreTagEvent{
  final int userId;
  final Tag tag;

  FetchExploreTag({
    this.userId,
    this.tag
  });
}