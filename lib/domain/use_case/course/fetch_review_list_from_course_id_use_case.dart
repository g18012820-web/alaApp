import 'package:flutter_bloc_template/base/helper/result.dart';
import 'package:flutter_bloc_template/base/use_case/future_use_case.dart';
import 'package:flutter_bloc_template/domain/entity/course/review_entity.dart';
import 'package:flutter_bloc_template/domain/repo/course_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
final class FetchReviewListFromCourseIdUseCase extends FutureUseCase<List<ReviewEntity>, String> {
  final CourseRepo _repo;

  FetchReviewListFromCourseIdUseCase(this._repo);

  @override
  Future<Result<List<ReviewEntity>>> invoke(String param) {
    return _repo.fetchReviewListFromCourseId(param);
  }
}
