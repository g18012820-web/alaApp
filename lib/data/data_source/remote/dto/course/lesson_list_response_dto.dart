import 'package:flutter_bloc_template/data/data_source/remote/dto/course/lesson_response_dto.dart';

class LessonListResponseDto {
  final List<LessonResponseDto> lessons;
  

  LessonListResponseDto({required this.lessons});

  factory LessonListResponseDto.fromJson(List<dynamic> json) {
    return LessonListResponseDto(
      lessons: json.map((item) => LessonResponseDto.fromJson(item)).toList(),
    );
  }

  List<Map<String, dynamic>> toJson() {
    return lessons.map((lesson) => lesson.toJson()).toList();
  }
}
