import 'package:flutter_bloc_template/data/data_source/remote/dto/course/course_response_dto.dart';
import 'package:flutter_bloc_template/domain/entity/course/tool_entity.dart';

abstract final class ToolMapper {
  static ToolEntity mapToEntity(ToolResponseDto? dto) {
    return ToolEntity(
      name: dto?.name ?? '',
      iconUrl: dto?.iconUrl ?? '',
    );
  }
}
