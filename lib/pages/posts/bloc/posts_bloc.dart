import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:instagram/database/firebase.dart';
import 'package:instagram/database/modal/post.dart';
import 'package:instagram/utils/globals.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  PostsBloc() : super(PostsInitial()) {
    on<UploadPost>(onUploadPost);
    on<GetPosts>(onGetPosts);
    on<DeletePost>(onDeletePost);
    on<PostsReceivedEvent>(onPostsReceived);
  }

  void onDeletePost(DeletePost event, Emitter emit)async{
    await DB().fireStore.collection(FirestorePath.post).doc(event.docId).delete();
  }

  void onGetPosts(GetPosts event, Emitter emit) async{
    emit(PostsLoading());
    try{
      var querySnapShotStream = DB().fireStore.collection(FirestorePath.post).orderBy("dateTime",descending: true).snapshots();

      Stream queryStream = querySnapShotStream.map((event) =>  event.docs.map((e) {
        var docMap = e.data();
        docMap["postId"] = e.id;
        return docMap;
      }).toList());

      queryStream.listen((posts) {
        add(PostsReceivedEvent(posts: Post.getPostsList(posts)));
      });

    }catch(e){
      emit(PostsFailed());
    }
  }

  void onPostsReceived(PostsReceivedEvent event, Emitter emit){
    emit(PostsFetched(posts: event.posts));
  }

  void onUploadPost(UploadPost event, Emitter emit)async{
    emit(Uploading());
    try{
      String id = FirebaseAuth.instance.currentUser!.uid;

      List<String> images=[];
      if(event.imageData!=null) {

        images.add(await uploadImage(id, event.imageData!));
      }else{
        images = await uploadFiles(id, event.images!);
      }

      Map<String, double>? position;

      if(event.position!=null){
        position = {
          "latitude":event.position!.latitude,
          "longitude":event.position!.longitude
        };
      }

      var post = {
        "image":images,
        "text":event.text,
        "uid":id,
        "position": position,
        "name":Globals.name,
        "photo":Globals.photo,
        "dateTime": DateTime.now().millisecondsSinceEpoch
      };


      await DB().fireStore.collection(FirestorePath.post).add(post);

      emit(Uploaded());
    }catch(e){
      emit(UploadFailure());
    }
  }

  Future<List<String>> uploadFiles(uid, List<String> images) async {
    var imageUrls = await Future.wait(images.map((image) => uploadImagePaths(uid,image)));
    return imageUrls;
  }

  Future<String> uploadImagePaths(String uid,String imagePath) async {
    Reference reference = FirebaseStorage.instance
        .ref()
        .child(uid).child("$uid-${DateTime.now().millisecondsSinceEpoch}");
    await reference.putFile(File(imagePath));
    return Future.value(await reference.getDownloadURL());
  }

  Future<String> uploadImage(String uid, Uint8List imageData) async {
    Reference reference = FirebaseStorage.instance.ref()
        .child(uid).child("$uid-${DateTime
        .now()
        .millisecondsSinceEpoch}");
    await reference.putData(imageData);
    return Future.value(await reference.getDownloadURL());
  }
}
