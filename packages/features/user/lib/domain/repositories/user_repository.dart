
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:user/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, List<UserEntity>>> getUsers({Map<String, dynamic>? params});
}