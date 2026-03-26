// Created on 26-03-2026 10:32 by yurapsanjani

part of 'theme_bloc.dart';

@freezed
class ThemeState with _$ThemeState {
  const factory ThemeState.initial() = _ThemeInitialState;
  const factory ThemeState.loading() = _GetThemeLoadingState;
  const factory ThemeState.error(String message) = _GetThemeErrorState;
  const factory ThemeState.loaded({required ThemeMode mode}) =
      _GetThemeLoadedState;
}
