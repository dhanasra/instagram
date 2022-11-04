import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {

  static Auth? _instance;
  FirebaseAuth firebaseAuth;

  Auth._({required this.firebaseAuth});

  factory Auth() {
    _instance ??= Auth._(firebaseAuth: FirebaseAuth.instance);
    return _instance!;
  }
}

class FirestorePath{

  static const String userData = "Users";
  static const String post = "Posts";

}

class DB {

  static DB? _instance;
  FirebaseFirestore fireStore;

  DB._({required this.fireStore});

  factory DB() {
    _instance ??= DB._(fireStore: FirebaseFirestore.instance);
    return _instance!;
  }
}