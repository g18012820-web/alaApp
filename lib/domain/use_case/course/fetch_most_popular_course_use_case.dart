import 'package:flutter_bloc_template/base/helper/result.dart';
import 'package:flutter_bloc_template/base/use_case/base_use_case.dart';
import 'package:flutter_bloc_template/base/use_case/future_use_case.dart';
import 'package:flutter_bloc_template/domain/entity/course/course_entity.dart';
import 'package:flutter_bloc_template/domain/repo/course_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class FetchMostPopularCourseUseCase extends FutureUseCase<List<CourseEntity>, NoParam?> {
  final CourseRepo _repo;

  FetchMostPopularCourseUseCase(this._repo);

  @override
  Future<Result<List<CourseEntity>>> invoke(NoParam? param) {
    return _repo.fetchMostPopularCourse();
  }
}
