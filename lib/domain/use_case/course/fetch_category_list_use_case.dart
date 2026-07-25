import 'package:flutter_bloc_template/base/helper/result.dart';
import 'package:flutter_bloc_template/base/use_case/base_use_case.dart';
import 'package:flutter_bloc_template/base/use_case/future_use_case.dart';
import 'package:flutter_bloc_template/domain/entity/course/category_entity.dart';
import 'package:flutter_bloc_template/domain/repo/course_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class FetchCategoryListUseCase extends FutureUseCase<List<CategoryEntity>, NoParam?> {
  final CourseRepo _repo;

  FetchCategoryListUseCase(this._repo);

  @override
  Future<Result<List<CategoryEntity>>> invoke(NoParam? param) {
    return _repo.fetchCategories();
  }
}
