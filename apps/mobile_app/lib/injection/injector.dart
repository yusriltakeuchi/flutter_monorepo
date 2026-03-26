import 'package:core/core.dart';
import 'package:mobile_app/routing/route.dart';
import 'package:user/domain/repositories/user_repository.dart';
import 'package:user/infrastructure/datasource/user_datasource.dart';
import 'package:user/infrastructure/repositories/user_repository_impl.dart';
import 'package:user/infrastructure/usecase/get_user_usecase.dart';
import 'package:user/presentation/bloc/user_bloc.dart';

Future<void> setupInjector() async {
  /// Route
  inject.registerSingleton<AppRouter>(AppRouter());

  /// Core api client
  inject.registerLazySingleton(() => ApiClient());

  /// Registering data source
  inject.registerLazySingleton<UserDataSource>(
      () => UserDataSource(inject<ApiClient>()),
  );

  /// Register repository
  inject.registerLazySingleton<UserRepository>(
        () => UserRepositoryImpl(
      inject<UserDataSource>(),
    ),
  );

  /// Register usecase
  inject.registerLazySingleton<GetUserUseCase>(
        () => GetUserUseCase(inject<UserRepository>()),
  );

  /// Register bloc
  inject.registerFactory<UserBloc>(() => UserBloc(
    inject<GetUserUseCase>(),
  ));
}
