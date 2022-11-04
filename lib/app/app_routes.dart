import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/bloc/image_bloc/image_bloc.dart';
import 'package:instagram/bloc/location_bloc/location_bloc.dart';
import 'package:instagram/pages/auth/bloc/auth_bloc.dart';
import 'package:instagram/pages/auth/views/forgot_password_page.dart';
import 'package:instagram/pages/auth/views/landing_page.dart';
import 'package:instagram/pages/auth/views/name_page.dart';
import 'package:instagram/pages/auth/views/sign_in_page.dart';
import 'package:instagram/pages/auth/views/sign_up_page.dart';
import 'package:instagram/pages/home/cubit/home_cubit.dart';
import 'package:instagram/pages/home/views/home_page.dart';
import 'package:instagram/pages/image_edit/views/image_edit_page.dart';
import 'package:instagram/pages/posts/bloc/posts_bloc.dart';
import 'package:instagram/pages/profile/bloc/profile_bloc.dart';
import 'package:instagram/pages/profile/views/profile_edit_page.dart';
import 'package:instagram/pages/profile/views/settings_page.dart';
import 'package:instagram/pages/splash/bloc/splash_bloc.dart';
import 'package:instagram/pages/splash/views/splash_page.dart';

import '../pages/posts/views/post_create_page.dart';

class AppRoutes {

  static const String splash = 'splash';

  //authentication
  static const String landing = 'landing';
  static const String signup = 'auth/signup';
  static const String signIn = 'auth/signIn';
  static const String name = 'auth/name';
  static const String forgotPassword = 'auth/forgotPassword';
  static const String initLoading = 'auth/init_loading';

  //home
  static const String home = 'home';

  //posts
  static const String posts = 'posts';
  static const String imageEdit = 'image/edit';
  static const String createPost = 'posts/create';

  //profile
  static const String profile = 'profile';
  static const String editProfile = 'profile/edit';
  static const String settings = 'profile/settings';


  Route getRoutes(RouteSettings routeSettings) {
    return MaterialPageRoute(
        settings: routeSettings, builder: (BuildContext context) => getWidget(context, routeSettings.name!));
  }

  getWidget(BuildContext context, String appRouteName){
    switch(appRouteName) {
      case settings: return BlocProvider(
          create: (_)=>ProfileBloc(), child: const SettingsPage());
      case editProfile: return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_)=>ImageBloc()),
            BlocProvider(create: (_)=>ProfileBloc()),
          ], child: const ProfileEditPage());
      case createPost: return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_)=>PostsBloc()),
            BlocProvider(create: (_)=>LocationBloc())
          ], child: const PostCreatePage());
      case imageEdit: return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_)=>PostsBloc())
          ], child: const ImageEditPage());
      case home: return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_)=>HomeCubit()),
            BlocProvider(create: (_)=>ImageBloc())
          ], child: const HomePage());
      case signup: return BlocProvider(
          create: (_)=>AuthBloc(), child: const SignupPage());
      case signIn: return BlocProvider(
          create: (_)=>AuthBloc(), child: const SignInPage());
      case forgotPassword: return BlocProvider(
          create: (_)=>AuthBloc(), child: const ForgotPasswordPage());
      case name: return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_)=>AuthBloc()),
            BlocProvider(create: (_)=>ImageBloc()),
          ],
          child: const NamePage());
      case landing: return BlocProvider(
        create: (_)=>AuthBloc(), child: const LandingPage());
      case splash: return BlocProvider(
          create: (_)=>SplashBloc(), child: const SplashPage());
      default: return Container();
    }
  }

}