part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileFetched extends ProfileState {
  final UserData userData;
  ProfileFetched({required this.userData});
}

class Loading extends ProfileState {}

class ProfileUpdated extends ProfileState {}

class MailSent extends ProfileState{}

