import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:instagram/utils/globals.dart';


class ProfileViewModel {
  static late ProfileViewModel _instance;
  factory ProfileViewModel() {
    _instance = ProfileViewModel._internal();
    return _instance;
  }

  ProfileViewModel._internal(){
    init();
  }

  late TextEditingController nameController;
  late TextEditingController bioController;

  Position? position;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();


  void init(){
    nameController = TextEditingController()..text=Globals.name;
    bioController = TextEditingController()..text=Globals.bio;
  }

}