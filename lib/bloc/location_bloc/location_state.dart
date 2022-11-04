part of 'location_bloc.dart';

@immutable
abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationFetching extends LocationState {}

class LocationFetched extends LocationState {
  final Position position;

  LocationFetched({required this.position});
}

class LocationPermissionDenied extends LocationState{}

class LocationGetFailed extends LocationState {}

class LocationServiceDisabled extends LocationState {}