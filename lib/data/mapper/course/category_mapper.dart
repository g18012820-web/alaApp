import 'package:flutter_bloc_template/data/data_source/remote/dto/course/category_response_dto.dart';
import 'package:flutter_bloc_template/domain/entity/course/category_entity.dart';

abstract final class CategoryMapper {
  CategoryMapper._();

  static CategoryEntity mapToEntity(CategoryResponseDto? dto) {
    return CategoryEntity(
      id: dto?.id ?? '',
      name: dto?.name ?? '',
    );
  }
}
