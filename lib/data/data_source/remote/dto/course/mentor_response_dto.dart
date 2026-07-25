import 'package:freezed_annotation/freezed_annotation.dart';
part 'mentor_response_dto.freezed.dart';
part 'mentor_response_dto.g.dart';

@freezed
class MentorResponseDto with _$MentorResponseDto {
  const factory MentorResponseDto({
    String? id,
    String? name,
    String? title,
    String? avatarUrl,
  }) = _MentorResponseDto;

  factory MentorResponseDto.fromJson(Map<String, Object?> json) => _$MentorResponseDtoFromJson(json);
}
