part of 'favorites_bloc.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();
  
  @override
  List<Object> get props => [];
}

class FavoritesInitial extends FavoritesState {}
class GetFavsSuccess extends FavoritesState {
  final Map<String, dynamic> data;

  GetFavsSuccess({required this.data});

  @override
  List<Object> get props => [this.data];
}
class GetFavsError extends FavoritesState {}
class RemoveFavSuccess extends FavoritesState {}

class AddFavSuccess extends FavoritesState {}
class AddFavError extends FavoritesState {
  final bool alreadyFavved;

  AddFavError({required this.alreadyFavved});
  @override
  List<Object> get props => [this.alreadyFavved];
}
