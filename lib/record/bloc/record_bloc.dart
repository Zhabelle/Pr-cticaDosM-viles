import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:record/record.dart';
import 'package:http/http.dart';

part 'record_event.dart';
part 'record_state.dart';

class RecordBloc extends Bloc<RecordEvent, RecordState> {
  RecordBloc() : super(RecordInitial()) {
    on<RecordStartEvent>(getRecording);
  }


  FutureOr<void> getRecording(event, emit) async{
    emit(RecordStarting());
    const s = String.fromEnvironment("AudDApiKey");
    if(s.isEmpty){
      emit(RecordGotError());
      return;
    }
    final Record record = Record();
    try {
      bool result = await record.hasPermission();
      if(!result) throw Error();
      await record.start();
      await Future.delayed(Duration(seconds: 6));
      String? path = await record.stop();
      if(path == null) throw Error();
      File f = new File(path);
      final audio = base64Encode(f.readAsBytesSync());
      String url = "https://api.audd.io/";
      final Response res = await post(Uri.parse(url), body: {
        'audio': audio,
        'api_token': s,
        'return': 'apple_music,spotify'
      });
      final body = jsonDecode(res.body)["result"];
      // log(res.body.toString());
      final mapa = {
        "artist": body["artist"],
        "title": body["title"],
        "album": body["spotify"]["album"]["images"][0]["url"],
        "urlPage": body["song_link"],
        "albumName": body["album"],
        "releaseDate": body["release_date"],
        "spotify": body["spotify"]["external_urls"]["spotify"],
        "apple": body["apple_music"],
      };
      // log(mapa.toString());
      emit(RecordGetSuccess(data: mapa));
    } catch (e) {
      print(e);
      emit(RecordGotError());
    }
  }
}
