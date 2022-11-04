
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instagram/database/modal/user_data.dart';
import 'package:instagram/utils/globals.dart';

import '../../../database/firebase.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<GetProfile>(onGetProfile);
    on<UpdateProfileEvent>(onUpdateProfile);
    on<VerifyEmail>(onVerifyEmail);
  }

  void onVerifyEmail(VerifyEmail event, Emitter emit) async{
    await Auth().firebaseAuth.currentUser!.sendEmailVerification().then((value){
      emit(MailSent());
    });
  }

  void onGetProfile(GetProfile event, Emitter emit) async{

    var uid = Auth().firebaseAuth.currentUser!.uid;

    Map<String, dynamic> userData = {};
    await DB().fireStore.collection(FirestorePath.userData).doc(uid).get().then(
            (DocumentSnapshot doc) { userData = doc.data() as Map<String, dynamic>; }
    );
    emit(ProfileFetched(userData: UserData.fromMap(userData)));
  }

  void onUpdateProfile(UpdateProfileEvent event, Emitter emit) async{
    emit(Loading());

    var uid = Auth().firebaseAuth.currentUser!.uid;

    var userData={
      "name":event.name,
      "bio":event.bio
    };

    if(event.profilePic!=null){
      String profilePicture = await uploadImage(uid,event.profilePic!);
      userData["profilePic"] = profilePicture;
      Globals.photo = profilePicture;
    }

    await DB().fireStore.collection(FirestorePath.userData).doc(uid)
      .update(userData).then((value){
        Globals.name = event.name;
        Globals.bio = event.bio;
      emit(ProfileUpdated());
    });

  }

  Future<String> uploadImage(String uid, String path) async {
    Reference reference = FirebaseStorage.instance.ref().child(uid).child("profilePic").child(path.split('/').last);
    await reference.putFile(File(path));
    return Future.value(await reference.getDownloadURL());
  }

}
