import 'package:flutter_bloc_template/domain/entity/auth/auth_entity.dart';
import 'package:flutter_bloc_template/domain/use_case/auth/login_use_case.dart';

import '../../base/helper/result.dart';

abstract class AuthRepo {
  Future<Result<AuthEntity>> login(LoginRequest req);
}
