part of 'favorites_bloc.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object> get props => [];
}

class GetFavsEvent extends FavoritesEvent {}
class RemoveFavEvent extends FavoritesEvent {
  final Map<String, dynamic> data;

  RemoveFavEvent({required this.data});

  @override
  List<Object> get props => [this.data];
}
class AddFavEvent extends FavoritesEvent{
  final Map<String, dynamic> data;

  AddFavEvent({required this.data});

  @override
  List<Object> get props => [this.data];
}
