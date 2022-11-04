import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/database/modal/user_data.dart';
import 'package:instagram/utils/globals.dart';

import '../../../database/firebase.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {

  SplashBloc() : super(SplashInitial()) {
    on<CheckAuth>(_onCheckAuth);
  }

  void _onCheckAuth(CheckAuth event, Emitter emit)async{

    User? user = Auth().firebaseAuth.currentUser;
    await Future.delayed(const Duration(seconds: 3), () async{

      if(user!=null){
        //Get user data and save globally
        var uid = Auth().firebaseAuth.currentUser!.uid;
        Map<String, dynamic> userData = {};
        await DB().fireStore.collection(FirestorePath.userData).doc(uid).get().then(
                (DocumentSnapshot doc) { userData = doc.data() as Map<String, dynamic>; }
        );
        var user = UserData.fromMap(userData);

        Globals.name = user.name;
        Globals.photo = user.profilePic;
        Globals.bio = user.bio;

        emit(Home());
      }else{
        emit(Login());
      }

    });
  }

}
