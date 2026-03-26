// Created on 26-03-2026 13:27 by yurapsanjani

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:user/domain/entities/user_entity.dart';
import 'package:user/infrastructure/usecase/get_user_usecase.dart';

part 'user_state.dart';

part 'user_bloc.freezed.dart';

class UserBloc extends Cubit<UserState> {
  final GetUserUseCase _getUserUseCase;
  UserBloc(this._getUserUseCase) : super(const UserState.initial());

  Future<void> fetchUsers() async {
    emit(const UserState.loading());
    try {
      final result = await _getUserUseCase();
      result.fold(
        (failure) => emit(UserState.error(failure.message)),
        (users) => emit(UserState.loaded(
          users: users,
          page: 1,
          hasReachedMax: true,
          onLoadMore: false,
        )),
      );
    } catch (e) {
      emit(UserState.error(e.toString()));
    }
  }

  Future<void> loadMore() async {
    state.maybeWhen(
      orElse: () {},
      loaded: (users, page, hasReachedMax, onLoadMore) async {
        emit(UserState.loaded(
          users: users,
          page: page,
          hasReachedMax: hasReachedMax,
          onLoadMore: true,
        ));

        if (hasReachedMax) {
          emit(UserState.loaded(
            users: users,
            page: page,
            hasReachedMax: true,
            onLoadMore: false,
          ));
          return;
        }

        final filter = {'page': page};
        final result = await _getUserUseCase.call(params: filter);
        result.fold(
          (error) => emit(UserState.error(error.message)),
          (data) {
            if (data.isEmpty) {
              emit(UserState.loaded(
                users: users,
                page: page,
                hasReachedMax: true,
                onLoadMore: false,
              ));
            } else {
              emit(UserState.loaded(
                users: users + data,
                page: page + 1,
                hasReachedMax: false,
                onLoadMore: false,
              ));
            }
          },
        );
      },
    );
  }
}
