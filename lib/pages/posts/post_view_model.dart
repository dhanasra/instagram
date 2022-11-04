import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';


class PostViewModel {
  static late PostViewModel _instance;
  factory PostViewModel() {
    _instance = PostViewModel._internal();
    return _instance;
  }

  PostViewModel._internal(){
    init();
  }

  late TextEditingController textController;
  Position? position;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();


  void init(){
    textController = TextEditingController();
  }

}