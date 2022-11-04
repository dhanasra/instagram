import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final List<dynamic> image;
  final String text;
  final Map<String, dynamic>? position;
  final String uid;
  final String postId;
  final String name;
  final String? profilePic;
  final int dateTime;

  const Post({
    required this.image,
    required this.text,
    required this.uid,
    required this.name,
    required this.postId,
    required this.position,
    required this.profilePic,
    required this.dateTime
  });

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'text': text,
      'uid': uid,
      'name': name,
      'position': position,
      'photo': profilePic,
      'dateTime': dateTime
    };
  }

  static List<Post> getPostsList(List<Map<String,dynamic>> data){
    return data.map((e) => Post.fromMap(e)).toList();
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      image: map['image'] as List<dynamic>,
      text: map['text'] as String,
      uid: map['uid'] as String,
      name: map['name'] as String,
      postId: map['postId'] as String,
      dateTime: map['dateTime'] as int,
      position: map['position'] as Map<String, dynamic>?,
      profilePic: map['photo'] as String?,
    );
  }

  @override
  List<Object?> get props => [image, text, uid];
}