part of 'subtask_bloc.dart';

abstract class SubtaskState extends Equatable {
  const SubtaskState();
}

class SubtaskInitial extends SubtaskState {
  @override
  List<Object> get props => [];
}
