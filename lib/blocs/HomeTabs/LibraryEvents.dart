
import 'package:equatable/equatable.dart';

abstract class LibraryEvent extends Equatable{
  const LibraryEvent();

  @override
  List<Object> get props => [];
}

class FetchLibrary extends LibraryEvent{
  FetchLibrary();
}