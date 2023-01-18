import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageCubit extends Cubit<Locale> {
  final String lang;

  LanguageCubit(this.lang) : super(Locale(lang));

  void selectEngLanguage() {
    emit(Locale('en'));
  }

  void selectArabicLanguage() {
    emit(Locale('ar'));
  }
}
