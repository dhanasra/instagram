part of 'posts_bloc.dart';

@immutable
abstract class PostsState {}

class PostsInitial extends PostsState {}

class PostsLoading extends PostsState {}

class PostsFailed extends PostsState {}

class PostsFetched extends PostsState {
  final List<Post> posts;

  PostsFetched({required this.posts});
}

class Uploading extends PostsState {}

class Uploaded extends PostsState {}

class UploadFailure extends PostsState {}
