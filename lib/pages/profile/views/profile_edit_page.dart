import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/app/app.dart';
import 'package:instagram/app/app_routes.dart';
import 'package:instagram/pages/profile/bloc/profile_bloc.dart';
import 'package:instagram/pages/profile/profile_view_model.dart';
import 'package:instagram/utils/globals.dart';
import 'package:instagram/utils/toaster.dart';

import '../../../bloc/image_bloc/image_bloc.dart';
import '../../../utils/constants.dart';
import '../../../widgets/button.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({Key? key}) : super(key: key);

  @override
  State<ProfileEditPage> createState() => _NamePageState();
}

class _NamePageState extends State<ProfileEditPage> {
  late ProfileViewModel viewModel;

  @override
  void initState() {
    viewModel = ProfileViewModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (_,state){
        if(state is ProfileUpdated){
          ScaffoldMessenger.of(context).showSnackBar(
              Toaster.snack(content: "Profile updated successfully")
          );
          const App().setNavigation(context, AppRoutes.home);
        }
      },
      child: Scaffold(
          appBar: AppBar(
            elevation: 2,
            title: const Text("Edit Profile"),
            centerTitle: false,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Form(
                key: viewModel.formKey,
                child: NameField(viewModel: viewModel)
            ),
          )
      ),
    );
  }
}


class NameField extends StatelessWidget {
  final ProfileViewModel viewModel;
  const NameField({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String? profilePic;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        const SizedBox(height: 24,),

        Align(
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: ()=>BlocProvider.of<ImageBloc>(context).add(GetImageEvent()),
            child: SizedBox(
              width: 90, height: 90,
              child: Stack(
                children: [

                  BlocBuilder<ImageBloc, ImageState>(
                    builder: (_,state){
                      if(state is ImageFetched){
                        profilePic = state.image.path;
                        return CircleAvatar(
                          radius: 45,
                          backgroundImage: FileImage(state.image),
                        );
                      }else{
                        if(Globals.photo!=null){

                          return CircleAvatar(
                            radius: 45,
                            backgroundImage: NetworkImage(Globals.photo!),
                          );
                        }else{
                          return const CircleAvatar(
                            radius: 45,
                            backgroundImage: AssetImage("${appAssets}man.png"),
                          );
                        }
                      }
                    },
                  ),
                  const Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(Icons.camera_alt, color: Colors.black38,),
                  )
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 24,),

        TextFormField(
          validator: (value){
            return value!=null && value.isEmpty
                ? "Name is required"
                : null;
          },
          onChanged: (val){
            viewModel.formKey.currentState?.validate();
          },
          decoration: const InputDecoration(
              hintText: "Enter your name",
              prefixIcon: Icon(Icons.person_outline_outlined)
          ),
          controller: viewModel.nameController,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600
          ),
        ),

        const SizedBox(height: 18),

        TextFormField(
          onChanged: (val){
            viewModel.formKey.currentState?.validate();
          },
          decoration: const InputDecoration(
              hintText: "Enter your bio",
              prefixIcon: Icon(Icons.book_outlined)
          ),
          controller: viewModel.bioController,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600
          ),
        ),

        const SizedBox(height: 32,),

        BlocBuilder<ProfileBloc, ProfileState>(
            builder: (_, state){
              return ButtonWL(
                  width: double.infinity,
                  isBlunt: true,
                  isLoading: state is Loading,
                  onPressed: (){
                    if (viewModel.formKey.currentState!.validate()) {
                      FocusScope.of(context).unfocus();
                      context.read<ProfileBloc>().add(UpdateProfileEvent(
                          name: viewModel.nameController.text,
                          bio: viewModel.bioController.text,
                          profilePic: profilePic
                      ));
                    }
                  },
                  label: "UPDATE"
              );
            }),
      ],
    );
  }
}
