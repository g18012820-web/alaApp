import 'package:flutter_bloc_template/base/helper/result.dart';
import 'package:flutter_bloc_template/base/use_case/base_use_case.dart';
import 'package:flutter_bloc_template/base/use_case/future_use_case.dart';
import 'package:flutter_bloc_template/domain/entity/course/promote_entity.dart';
import 'package:flutter_bloc_template/domain/repo/course_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class FetchPromoteListUseCase extends FutureUseCase<List<PromoteEntity>, NoParam?> {
  final CourseRepo _repo;

  FetchPromoteListUseCase(this._repo);

  @override
  Future<Result<List<PromoteEntity>>> invoke(NoParam? param) {
    return _repo.fetchPromotes();
  }
}
