import 'package:config/config.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:user/domain/entities/user_entity.dart';

extension APIExtension on ApiClient {
  ApiDataSource<UserEntity> get user =>
      ApiDataSource<UserEntity>(this, UserEntity.fromJson);
}

class UserDataSource {
  final ApiClient apiClient;
  UserDataSource(this.apiClient);

  Future<Either<Failure, List<UserEntity>>> getUsers({Map<String, dynamic>? params}) async
    => apiClient.user.getList(Endpoint.users, queryParams: params);
}