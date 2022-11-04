
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {

  final BuildContext context;

  ThemeBloc({required this.context}) : super(ThemeFetched(theme: "lightTheme")) {
    on<GetTheme>(onGetTheme);
    on<UpdateTheme>(onUpdateTheme);
    on<UpdateLanguage>(onUpdateLanguage);
  }

  void onGetTheme(GetTheme event, Emitter emit)async{
    emit(ThemeLoading());
    // UserData? data = await DB.getUserData();
    // Globals.app_theme = data!.appTheme;
    // emit(ThemeFetched(app_theme: data.appTheme));
  }

  void onUpdateTheme(UpdateTheme event, Emitter emit)async{
    emit(ThemeFetched(theme: event.theme));

    Map<String, Object?> updateData = {};
    updateData["appTheme"] = event.theme;
    // Globals.app_theme = event.app_theme;
    // await DB.updateProfile(updateData);
  }

  void onUpdateLanguage(UpdateLanguage event, Emitter emit)async{
    Map<String, Object?> updateData = {};
    updateData["appLang"] = event.lang;
    // Globals.language = event.lang;
    // await DB.updateProfile(updateData);
  }
}
