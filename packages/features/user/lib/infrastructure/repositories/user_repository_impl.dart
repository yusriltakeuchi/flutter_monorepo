
import 'package:core/network/error_handler.dart';
import 'package:dartz/dartz.dart';
import 'package:user/domain/entities/user_entity.dart';
import 'package:user/domain/repositories/user_repository.dart';
import 'package:user/infrastructure/datasource/user_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource _userDataSource;
  UserRepositoryImpl(this._userDataSource);

  @override
  Future<Either<Failure, List<UserEntity>>> getUsers({Map<String, dynamic>? params})
    => _userDataSource.getUsers(params: params);

}