import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/pages/auth/auth_view_model.dart';
import 'package:instagram/pages/auth/bloc/auth_bloc.dart';
import 'package:instagram/widgets/button.dart';
import 'package:instagram/widgets/google_button.dart';

import '../../../app/app.dart';
import '../../../app/app_routes.dart';
import '../../../utils/constants.dart';
import '../../../utils/toaster.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
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
        if(state is AuthSuccess){
          const App().setNavigation(context, AppRoutes.home);
        }else if (state is AuthType) {
          const App().setNavigation(
              context,
              state.isLogin
                  ? AppRoutes.signIn
                  : AppRoutes.signup, args: viewModel.emailController.text);
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(Toaster.snack(content: state.message));
        }
      },
      child: WillPopScope(
        onWillPop: ()async{
          const App().setBackNavigation(context);
          return false;
        },
        child: Scaffold(
          body: Form(
              key: viewModel.formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: EmailField(viewModel: viewModel),
              )
          ),
        ),
      ),
    );
  }
}

class EmailField extends StatelessWidget {
  final AuthViewModel viewModel;
  const EmailField({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ShaderMask(
            shaderCallback: (bounds) =>
                splashGradient.createShader(bounds),
            blendMode: BlendMode.srcIn,
            child: const Text("Instagram",
                style: TextStyle(
                    fontWeight: FontWeight.w800, fontSize: 28))),

        Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
          child: Image.asset("${appAssets}app_logo.png", width: 70,),
        ),

        const Text("Welcome User", style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: info
        ),),

        const SizedBox(height: 32,),

        TextFormField(
          keyboardType: TextInputType.emailAddress,
          autofocus: true,
          validator: (value){
            return value!=null && value.isEmpty
                ? "Email Address is required"
                : null;
          },
          onChanged: (val){
            viewModel.formKey.currentState?.validate();
          },
          decoration: const InputDecoration(
              hintText: "Enter Email Address",
              prefixIcon: Icon(Icons.email_outlined)
          ),
          controller: viewModel.emailController,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600
          ),
        ),

        const SizedBox(height: 32,),

        BlocBuilder<AuthBloc, AuthState>(
            builder: (_, state){
              return ButtonWL(
                  width: double.infinity,
                  isBlunt: true,
                  isLoading: state is AuthLoading,
                  onPressed: (){
                    if (viewModel.formKey.currentState!.validate()) {
                      FocusScope.of(context).unfocus();
                      context.read<AuthBloc>().add(
                          CheckIfLoginOrSignIn(
                              email: viewModel.emailController.text));
                    }
                  },
                  label: "CONTINUE"
              );
            }),

        const SizedBox(height: 12,),

        Row(
          children: const [
            Expanded(child: Divider(),),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text("OR"),
            ),
            Expanded(child: Divider(),),
          ],
        ),

        const SizedBox(height: 12,),

        GoogleButton(
            label: "Login with Google",
            onPressed: (){
              FocusScope.of(context).unfocus();
              context.read<AuthBloc>().add(GoogleAuthEvent());
            }
        )

      ],
    );
  }
}

