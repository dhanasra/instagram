
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instagram/database/firebase.dart';
import 'package:instagram/utils/globals.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<CheckIfLoginOrSignIn>(onCheckIfLoginOrSignIn);
    on<SignupEvent>(onSignup);
    on<LoginEvent>(onLogin);
    on<GoogleAuthEvent>(onGoogleSignIn);
    on<CreateProfileEvent>(onCreateProfile);
    on<ForgotPasswordEvent>(forgotPassword);
  }

  void onCheckIfLoginOrSignIn(CheckIfLoginOrSignIn event, Emitter emit) async {
    emit(AuthLoading());
    try{
      var result = await Auth().firebaseAuth.fetchSignInMethodsForEmail(event.email);
      emit(AuthType(isLogin: result.isNotEmpty));
    }on FirebaseAuthException catch(e){
      String message = getErrorMessage(e.code, param: "Email address");
      emit(AuthFailure(message: message));
    }
  }

  void onSignup(SignupEvent event, Emitter emit) async {
    emit(AuthLoading());
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: event.email.trim(), password: event.password.trim()
      ).then((value) => emit(AuthSuccess()));
    }on FirebaseAuthException catch(e){
      String message = getErrorMessage(e.code, param: event.email.trim().isEmpty ? "Email address" : "Password");
      emit(AuthFailure(message: message));
    }
  }

  void onLogin(LoginEvent event, Emitter emit) async {
    emit(AuthLoading());
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: event.email.trim(), password: event.password.trim()
      ).then((value) => emit(AuthSuccess()));
    }on FirebaseAuthException catch(e){
      String message = getErrorMessage(e.code, param: event.email.trim().isEmpty ? "Email address" : "Password");
      emit(AuthFailure(message: message));
    }
  }

  void onGoogleSignIn(GoogleAuthEvent event, Emitter emit) async{
    emit(AuthLoading());
    try{

      final GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      var userData = {
        "name": userCredential.user!.displayName,
        "bio": "",
        "profilePic": userCredential.user!.photoURL,
        "id": userCredential.user!.uid
      };

      Globals.name = userCredential.user!.displayName!;
      Globals.photo = userCredential.user!.photoURL;

      try {
        await DB().fireStore.collection(FirestorePath.userData).doc(userCredential.user!.uid).set(userData);
        emit(ProfileCreated());
      }catch(e){
        emit(AuthFailure(message: e.toString()));
      }
      emit(AuthSuccess());
    }on FirebaseAuthException catch(e){
      emit(AuthFailure(message: getErrorMessage(e.code)));
    }on PlatformException catch(e){
      emit(AuthFailure(message: getErrorMessage(e.code)));
    }
  }

  void onCreateProfile(CreateProfileEvent event, Emitter emit) async {
    emit(AuthLoading());
    String id = FirebaseAuth.instance.currentUser!.uid;
    String? profilePicture;

    if(event.profilePic!=null){
      profilePicture = await uploadImage(id,event.profilePic!);
    }

    var userData = {
      "name": event.name,
      "bio": event.bio,
      "profilePic": profilePicture,
      "id": id};

    try {
      await DB().fireStore.collection(FirestorePath.userData).doc(id).set(userData);
      emit(ProfileCreated());
    }catch(e){
      emit(AuthFailure(message: e.toString()));
    }

  }

  Future<String> uploadImage(String uid, String path) async {
    Reference reference = FirebaseStorage.instance.ref().child(uid).child("profilePic").child(path.split('/').last);
    await reference.putFile(File(path));
    return Future.value(await reference.getDownloadURL());
  }

  void forgotPassword(ForgotPasswordEvent event, Emitter emit) async{
    emit(AuthLoading());
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: event.email);
      emit(AuthSuccess());
    }on FirebaseException catch(e){
      emit(AuthFailure(message: getErrorMessage(e.code)));
    }
  }

  String getErrorMessage(String errorCode, {String? param}){
    switch(errorCode){
      case "mismatch": return "password & confirm password does not match";
      case "unknown": return "$param is empty!";
      case "user-not-found": return "Sorry buddy, The email address not found";
      case "invalid-email": return "Please enter the valid email address";
      case "email-already-in-use": return "The given email address is already registered.";
      case "wrong-password": return "Wrong password";
      case "account-exists-with-different-credential": return "Email already associated with another account";
      case "weak-password": return "Password is too easy. Password should contain minimum 8 letters";
      case "operation-not-allowed": case "user-disabled": return "Something went wrong try different email address";
      default: return "Sorry buddy, Something went wrong. Try again later!";
    }
  }
}
