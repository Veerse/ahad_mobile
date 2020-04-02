
import 'package:equatable/equatable.dart';

abstract class HomeTabEvent extends Equatable{
  const HomeTabEvent();

  @override
  List<Object> get props => [];
}

class FetchHomeTab extends HomeTabEvent{
  final int userId;
  FetchHomeTab({this.userId});
}