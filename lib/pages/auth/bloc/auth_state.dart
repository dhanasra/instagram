part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class ProfileCreated extends AuthState {}

class AuthType extends AuthState {
  final bool isLogin;
  AuthType({
    required this.isLogin
  });
}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure({required this.message});
}

