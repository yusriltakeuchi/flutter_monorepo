
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:user/domain/entities/user_entity.dart';
import 'package:user/domain/repositories/user_repository.dart';

class GetUserUseCase {
  final UserRepository _userRepository;

  GetUserUseCase(this._userRepository);

  Future<Either<Failure, List<UserEntity>>> call({Map<String, dynamic>? params}) async {
    return await _userRepository.getUsers(params: params);
  }
}