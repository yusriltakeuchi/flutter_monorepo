// Created on 26-03-2026 10:32 by yurapsanjani

import 'package:bloc/bloc.dart';
import 'package:core/utils/manager/shared_manager.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'theme_state.dart';

part 'theme_bloc.freezed.dart';

class ThemeBloc extends Cubit<ThemeState> {
  ThemeBloc() : super(const ThemeState.initial());

  Future<void> getTheme() async {
    emit(const ThemeState.loading());
    try {
      final shared = SharedManager<String>();
      final theme = await shared.read('theme');
      if (theme == null) {
        emit(const ThemeState.loaded(mode: ThemeMode.system));
      } else {
        emit(
          ThemeState.loaded(
            mode: ThemeMode.values.firstWhere((e) => e.toString() == theme),
          ),
        );
      }
    } catch (e) {
      emit(const ThemeState.error('Failed to get theme'));
    }
  }

  Future<void> setTheme(ThemeMode mode) async {
    emit(const ThemeState.loading());
    try {
      final shared = SharedManager<String>();
      await shared.store('theme', mode.toString());
      emit(ThemeState.loaded(mode: mode));
    } catch (e) {
      emit(const ThemeState.error('Failed to set theme'));
    }
  }
}
