import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/app.dart';
import '../../../app/app_routes.dart';
import '../../../bloc/image_bloc/image_bloc.dart';
import '../../../utils/constants.dart';
import '../../../utils/toaster.dart';
import '../../../widgets/button.dart';
import '../auth_view_model.dart';
import '../bloc/auth_bloc.dart';

class NamePage extends StatefulWidget {
  const NamePage({Key? key}) : super(key: key);

  @override
  State<NamePage> createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  late AuthViewModel viewModel;

  @override
  void initState() {
    viewModel = AuthViewModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (_,state){
        if (state is ProfileCreated) {
          const App().setNavigation(context,AppRoutes.home);
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(Toaster.snack(content: state.message));
        }
      },
      child: Scaffold(
          appBar: AppBar(

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
  final AuthViewModel viewModel;
  const NameField({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String? profilePic;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text("Profile",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),),
        const Text("Build your instagram profile",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: info),),

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
                        return const CircleAvatar(
                          radius: 45,
                          backgroundImage: AssetImage("${appAssets}man.png"),
                        );
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
          autofocus: true,
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
          autofocus: true,
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

        BlocBuilder<AuthBloc, AuthState>(
            builder: (_, state){
              return Align(
                alignment: Alignment.center,
                child: ButtonWL(
                    width: double.infinity,
                    isBlunt: true,
                    isLoading: state is AuthLoading,
                    onPressed: (){
                      if (viewModel.formKey.currentState!.validate()) {
                        FocusScope.of(context).unfocus();
                        context.read<AuthBloc>().add(CreateProfileEvent(
                            name: viewModel.nameController.text,
                            bio: viewModel.bioController.text,
                            profilePic: profilePic
                        ));
                      }
                    },
                    label: "CONTINUE"
                ),
              );
            }),
      ],
    );
  }
}
