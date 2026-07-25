import 'package:flutter_bloc_template/data/data_source/remote/dto/course/lesson_response_dto.dart';
import 'package:flutter_bloc_template/domain/entity/course/lesson_entity.dart';
import 'package:flutter_bloc_template/domain/entity/course/lesson_type.dart';

abstract final class LessonMapper {
  const LessonMapper._();

  static LessonEntity mapToEntity(LessonResponseDto? dto) {
    return LessonEntity(
      id: dto?.id ?? '',
      title: dto?.title ?? '',
      duration: dto?.duration ?? 0,
      videoUrl: dto?.videoUrl ?? '',
      isFree: dto?.isFree ?? false,
      type: LessonType.fromKey(dto?.type),
      order: dto?.order ?? 0,
      isLocked: dto?.isLocked ?? false,
      scheduledAt: dto?.scheduledAt != null ? DateTime.tryParse(dto!.scheduledAt!) : null,
    );
  }
}
