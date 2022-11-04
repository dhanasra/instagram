part of 'posts_bloc.dart';

@immutable
abstract class PostsEvent {}

class GetPosts extends PostsEvent {}

class UploadPost extends PostsEvent {
  final String text;
  final Uint8List? imageData;
  final List<String>? images;
  final Position? position;

  UploadPost({ this.imageData, required this.text, this.position, this.images});
}

class DeletePost extends PostsEvent {
  final String docId;
  DeletePost({required this.docId});
}

class PostsReceivedEvent extends PostsEvent {
  final List<Post> posts;

  PostsReceivedEvent({required this.posts});
}
