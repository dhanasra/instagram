part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

class GetProfile extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent{
  final String name;
  final String bio;
  final String? profilePic;
  UpdateProfileEvent({
    required this.name,
    required this.bio,
    this.profilePic
  });
}

class VerifyEmail extends ProfileEvent{}
