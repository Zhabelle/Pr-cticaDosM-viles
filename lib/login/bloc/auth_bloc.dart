import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prados/auth/user_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserAuthProvider _auth = UserAuthProvider();
  AuthBloc() : super(AuthInitial()) {
    on<GoogleAuthEvent>((event, emit) async{
      emit(AuthAwait());
      try {
        await _auth.googleSignIn();
        emit(AuthSuccess());
      } catch (e) {
        emit(AuthError());
      }
    });
  
    on<RemoveAuthEvent>((event, emit) async{
      if(FirebaseAuth.instance.currentUser!.isAnonymous){
        await _auth.fbSignOut();
      }else{
        await _auth.googleSignOut();
        await _auth.fbSignOut();
      }
      emit(AuthOut());
    });
  
    on<VerifyAuthEvent>((event, emit) {
      if(_auth.isAuthenticated())
        emit(AuthSuccess());
      else
        emit(AuthError());
    });
  }
}
