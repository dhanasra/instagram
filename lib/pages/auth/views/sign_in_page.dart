import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/app.dart';
import '../../../app/app_routes.dart';
import '../../../utils/constants.dart';
import '../../../utils/toaster.dart';
import '../../../widgets/button.dart';
import '../auth_view_model.dart';
import '../bloc/auth_bloc.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
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
        if (state is AuthSuccess) {
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
                child: PasswordField(viewModel: viewModel)
            ),
          )
      ),
    );
  }
}


class PasswordField extends StatelessWidget {
  final AuthViewModel viewModel;
  const PasswordField({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String email = ModalRoute.of(context)!.settings.arguments as String;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text("Login",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),),
        const Text("Login to your instagram account",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: info),),

        const SizedBox(height: 24,),

        ValueListenableBuilder(
            valueListenable: viewModel.passwordVisibleState,
            builder: (_,__,___){
              return TextFormField(
                autofocus: true,
                onChanged: (val){
                  viewModel.formKey.currentState?.validate();
                },
                validator: (value){
                  return value!=null && value.isEmpty
                      ? "Password is required"
                      : null;
                },
                decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: GestureDetector(
                      onTap: ()=>viewModel.passwordVisibleState.value=!viewModel.passwordVisibleState.value,
                      child: viewModel.passwordVisibleState.value
                          ? const Icon(Icons.remove_red_eye) : const Icon(Icons.remove_red_eye_outlined),
                    )
                ),
                obscureText: viewModel.passwordVisibleState.value,
                controller: viewModel.passwordController,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600
                ),
              );
            }
        ),

        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
              onPressed: ()=>const App().setNavigation(context, AppRoutes.forgotPassword),
              child: const Text("Forgot password?")
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
                        context.read<AuthBloc>().add(
                            LoginEvent(
                                email: email,
                                password: viewModel.passwordController.text
                            ));
                      }
                    },
                    label: "LOGIN"
                ),
              );
            }),
      ],
    );
  }
}
