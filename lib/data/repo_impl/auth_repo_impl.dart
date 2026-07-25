import 'package:flutter_bloc_template/base/repo/base_repo.dart';
import 'package:flutter_bloc_template/data/data_source/remote/service/auth_service.dart';
import 'package:flutter_bloc_template/domain/entity/auth/auth_entity.dart';
import 'package:flutter_bloc_template/domain/repo/auth_repo.dart';
import 'package:flutter_bloc_template/domain/use_case/auth/login_use_case.dart';
import 'package:injectable/injectable.dart';

import '../../base/helper/result.dart';

@LazySingleton(as: AuthRepo)
class AuthRepoImpl extends BaseRepository implements AuthRepo {
  final AuthService _authService;

  AuthRepoImpl(this._authService);

  @override
  Future<Result<AuthEntity>> login(LoginRequest req) {
    throw UnimplementedError();
  }
}
