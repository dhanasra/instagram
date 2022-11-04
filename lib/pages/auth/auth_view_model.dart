import 'package:flutter/material.dart';


class AuthViewModel {
  static late AuthViewModel _instance;
  factory AuthViewModel() {
    _instance = AuthViewModel._internal();
    return _instance;
  }

  AuthViewModel._internal(){
    init();
  }

  ValueNotifier passwordVisibleState = ValueNotifier<bool>(true);

  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController nameController;
  late TextEditingController bioController;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void init(){
    emailController = TextEditingController();
    passwordController = TextEditingController();
    nameController = TextEditingController();
    bioController = TextEditingController();
  }

}