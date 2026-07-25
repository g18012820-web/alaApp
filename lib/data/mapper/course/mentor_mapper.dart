import 'package:flutter_bloc_template/data/data_source/remote/dto/course/mentor_response_dto.dart';
import 'package:flutter_bloc_template/domain/entity/course/mentor_entity.dart';

abstract final class MentorMapper {
  static MentorEntity mapToEntity(MentorResponseDto? dto) {
    return MentorEntity(
      id: dto?.id ?? '',
      name: dto?.name ?? '',
      title: dto?.title ?? '',
      avatarUrl: dto?.avatarUrl ?? '',
    );
  }
}
