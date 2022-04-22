import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(FavoritesInitial()) {
    on<GetFavsEvent>(getFavs);
    on<RemoveFavEvent>(removeFav);
    on<AddFavEvent>(addFav);
  }

  FutureOr<void> getFavs(event, emit) async{
    emit(FavoritesInitial());
    try {
      Map<String, dynamic>? docs = (await FirebaseFirestore.instance.collection("user").doc(FirebaseAuth.instance.currentUser!.uid).get()).data();
      if(docs == null) throw Error();
      emit(GetFavsSuccess(data: docs));
    } catch (e) {
        emit(GetFavsError());
    }
  }

  FutureOr<void> removeFav(RemoveFavEvent event, Emitter<FavoritesState> emit) async{
    emit(FavoritesInitial());
    try {
      final userDocRef = FirebaseFirestore.instance.collection("user").doc(FirebaseAuth.instance.currentUser!.uid);
      Map<String, dynamic>? docs = (await userDocRef.get()).data();
      if(docs == null) throw Error();
      List<dynamic> favs = docs["favorites"];
      List<dynamic> newFavs = [];
      for (var fav in favs) {
        if(!mapEquals(event.data, fav)){
          newFavs.add(fav);
        }
      }
      Map<String, dynamic> mapa = {"favorites":newFavs};
      await userDocRef.update(mapa);
      emit(RemoveFavSuccess());
      emit(GetFavsSuccess(data: mapa));
    } catch (e) {
      print(e);
      emit(GetFavsError());
    }
  }

  FutureOr<void> addFav(AddFavEvent event, Emitter<FavoritesState> emit) async{
    emit(FavoritesInitial());
    try {
      final userDocRef = FirebaseFirestore.instance.collection("user").doc(FirebaseAuth.instance.currentUser!.uid);
      Map<String, dynamic>? doc = (await userDocRef.get()).data();
      if(doc == null) throw Error();
      List<dynamic> favs = doc["favorites"];
      for (var fav in favs) {
        if(mapEquals(event.data, fav)){
          emit(AddFavError(alreadyFavved: true));
          return;
        }
      }
      favs.add(event.data);
      await userDocRef.update({"favorites": favs});
      emit(AddFavSuccess());
    } catch (e) {
      emit(AddFavError(alreadyFavved: false));
    }
  }
}
