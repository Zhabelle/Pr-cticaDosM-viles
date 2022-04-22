part of 'record_bloc.dart';

abstract class RecordState extends Equatable {
  const RecordState();
  
  @override
  List<Object> get props => [];
}

class RecordInitial extends RecordState {}

class RecordFinished extends RecordState {}
class RecordStarting extends RecordState {}
class RecordGotError extends RecordState {}
class RecordGetSuccess extends RecordState {
  final Map<String, dynamic> data;

  RecordGetSuccess({required this.data});

  @override
  List<Object> get props => [this.data];
}
