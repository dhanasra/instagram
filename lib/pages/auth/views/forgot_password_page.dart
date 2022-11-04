import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/app.dart';
import '../../../app/app_routes.dart';
import '../../../utils/constants.dart';
import '../../../utils/toaster.dart';
import '../../../widgets/button.dart';
import '../auth_view_model.dart';
import '../bloc/auth_bloc.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
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
          const App().restart(context);
          ScaffoldMessenger.of(context).showSnackBar(Toaster.snack(content:"Forgot password link sent to your email."));
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
                child: ForgotPasswordField(viewModel: viewModel)
            ),
          )
      ),
    );
  }
}


class ForgotPasswordField extends StatelessWidget {
  final AuthViewModel viewModel;
  const ForgotPasswordField({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text("Forgot Password ?",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),),
        const Text("Reset your instagram account password",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: info),),

        const SizedBox(height: 24,),

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
              return Align(
                alignment: Alignment.center,
                child: ButtonWL(
                    width: double.infinity,
                    isBlunt: true,
                    isLoading: state is AuthLoading,
                    onPressed: (){
                      if (viewModel.formKey.currentState!.validate()) {
                        FocusScope.of(context).unfocus();
                        BlocProvider.of<AuthBloc>(context).add(
                            ForgotPasswordEvent(email: viewModel.emailController.text));
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
