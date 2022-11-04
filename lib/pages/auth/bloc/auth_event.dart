part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class GoogleAuthEvent extends AuthEvent{}

class CheckIfLoginOrSignIn extends AuthEvent {
  final String email;
  CheckIfLoginOrSignIn({
    required this.email
  });
}

class ForgotPasswordEvent extends AuthEvent{
  final String email;

  ForgotPasswordEvent({
    required this.email
  });

}

class LoginEvent extends AuthEvent{
  final String email;
  final String password;

  LoginEvent({
    required this.email,
    required this.password
  });

}

class CreateProfileEvent extends AuthEvent{
  final String name;
  final String bio;
  final String? profilePic;
  CreateProfileEvent({
    required this.name,
    required this.bio,
    this.profilePic
  });
}

class SignupEvent extends AuthEvent{
  final String email;
  final String password;

  SignupEvent({
    required this.email,
    required this.password
  });
}
