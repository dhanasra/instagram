import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/app.dart';
import '../../../app/app_routes.dart';
import '../../../utils/constants.dart';
import '../bloc/splash_bloc.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (_)=>SplashBloc()..add(CheckAuth()),
      child: Scaffold(
        body: Center(
            child: BlocListener<SplashBloc,SplashState>(
                listener: (_,state){
                  if(state is Login){
                    const App().setNavigation(context, AppRoutes.landing);
                  } else{
                    const App().setNavigation(context, AppRoutes.home);
                  }
                },
                child:  Center(
                  child: Image.asset("${appAssets}app_logo.png", width: 80, height: 80)
                )
            )
        ),
      )
    );
  }
}

