import 'package:flutter_bloc_template/base/helper/result.dart';
import 'package:flutter_bloc_template/base/use_case/base_use_case.dart';
import 'package:flutter_bloc_template/base/use_case/future_use_case.dart';
import 'package:flutter_bloc_template/domain/entity/user/user_entity.dart';
import 'package:flutter_bloc_template/domain/repo/user_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class FetchProfileUseCase extends FutureUseCase<UserEntity, NoParam?> {
  final UserRepo _repo;

  FetchProfileUseCase(this._repo);

  @override
  Future<Result<UserEntity>> invoke(NoParam? param) {
    return _repo.fetchProfile();
  }
}
