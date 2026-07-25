import 'package:flutter_bloc_template/base/helper/result.dart';
import 'package:flutter_bloc_template/base/use_case/base_use_case.dart';
import 'package:flutter_bloc_template/base/use_case/future_use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class LogoutUseCase extends FutureUseCase<dynamic, NoParam?> {
  @override
  Future<Result> invoke(NoParam? param) {
    throw UnimplementedError();
  }
}
