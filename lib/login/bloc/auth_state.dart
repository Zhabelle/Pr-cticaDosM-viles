part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthAwait extends AuthState {}
class AuthError extends AuthState {}
class AuthSuccess extends AuthState {}
class AuthOut extends AuthState {}
