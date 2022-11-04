import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/app/app.dart';
import 'package:instagram/app/app_routes.dart';
import 'package:instagram/database/firebase.dart';
import 'package:instagram/pages/profile/bloc/profile_bloc.dart';
import 'package:instagram/utils/constants.dart';
import 'package:instagram/widgets/button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        automaticallyImplyLeading: false,
        title: const Text("Profile"),
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: (){
                const App().setNavigation(context, AppRoutes.settings);
              },
              splashRadius: 26,
              icon: const Icon(Icons.settings_outlined,size: 24,)
          ),
          IconButton(
              onPressed: (){
                const App().setNavigation(context, AppRoutes.editProfile);
              },
              splashRadius: 26,
              icon: const Icon(Icons.edit_outlined,size: 24,)
          )
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (_,state){
          if(state is ProfileFetched){
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if(state.userData.profilePic!=null)
                      CircleAvatar(
                        radius: 58,
                        backgroundImage: NetworkImage(state.userData.profilePic!),
                      ),
                    if(state.userData.profilePic==null)
                      const CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage("${appAssets}man.png"),
                      ),

                    const SizedBox(height: 24,),

                    Text(state.userData.name,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),

                    const SizedBox(height: 12,),

                    Text(state.userData.bio,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),

                    const Divider(height: 88,),

                    ButtonWL(
                        isLoading: false,
                        onPressed: (){
                          Auth().firebaseAuth.signOut().then((value){
                            const App().restart(context);
                          });
                        },
                        label: "LOGOUT"
                    )
                  ]
              ),
            );
          }else{
            return Container(
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(color: promptColor,),
              ),
            );
          }
        },
      ),
    );
  }
}


