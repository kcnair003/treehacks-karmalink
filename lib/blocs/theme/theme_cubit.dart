import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:oil_finder/themes.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(lightTheme);

  void toggle() {
    if (state == lightTheme) {
      emit(darkTheme);
    } else {
      emit(lightTheme);
    }
  }
}
