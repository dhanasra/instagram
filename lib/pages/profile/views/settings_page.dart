import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/bloc/app_theme/theme_bloc.dart';
import 'package:instagram/pages/profile/bloc/profile_bloc.dart';
import 'package:instagram/utils/globals.dart';
import 'package:instagram/utils/toaster.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 2,
          title: const Text("Settings"),
          centerTitle: false,
        ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (_,state){
          if(state is MailSent){
            ScaffoldMessenger.of(context).showSnackBar(
              Toaster.snack(content: "Verification mail sent successfully!")
            );
          }
        },
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                BlocBuilder<ThemeBloc, ThemeState>(
                    builder: (_,state){
                      var theme = Globals.theme;
                      if(state is ThemeFetched){
                        theme = state.theme;
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Change Theme", style: TextStyle(
                              fontSize: 16
                          ),),

                          Switch(
                              value: theme=="darkTheme",
                              onChanged: (val){
                                BlocProvider.of<ThemeBloc>(context).add(UpdateTheme(theme:val ? "darkTheme" : "lightTheme"));
                              }
                          )
                        ],
                      );
                    }),

                const Divider(height: 32,),

                GestureDetector(
                  onTap: ()=>context.read<ProfileBloc>().add(VerifyEmail()),
                  child: Container(
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Verify Email", style: TextStyle(
                            fontSize: 16
                        ),),
                        Icon(Icons.arrow_forward_ios)
                      ],
                    ),
                  ),
                ),

                const Divider(height: 32,),
              ],
            ),
          ))
    );
  }
}
