import 'package:equatable/equatable.dart';

class UserData extends Equatable {
  final String name;
  final String bio;
  final String? profilePic;

  const UserData({
    required this.name,
    required this.bio,
    this.profilePic
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'bio': bio,
      'profilePic': profilePic,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      name: map['name'] as String,
      bio: map['bio'] as String,
      profilePic: map['profilePic'] as String?,
    );
  }

  @override
  List<Object?> get props => [name, bio, profilePic];
}