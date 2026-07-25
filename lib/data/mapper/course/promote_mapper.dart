import 'package:flutter_bloc_template/data/data_source/remote/dto/course/promote_response_dto.dart';
import 'package:flutter_bloc_template/domain/entity/course/promote_entity.dart';

abstract final class PromoteMapper {
  const PromoteMapper._();

  static PromoteEntity mapToEntity(PromoteResponseDto? dto) {
    return PromoteEntity(
      id: dto?.id ?? '',
      title: dto?.title ?? '',
      description: dto?.description ??'',
      discount: dto?.discount ?? '',
      isActive: dto?.isActive ?? false,
      expiryDate: DateTime.now(),
    );
  }
}
