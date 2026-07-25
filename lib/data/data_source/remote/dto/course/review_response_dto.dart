import 'package:freezed_annotation/freezed_annotation.dart';
part 'review_response_dto.freezed.dart';
part 'review_response_dto.g.dart';

@freezed
class ReviewResponseDto with _$ReviewResponseDto {
  const factory ReviewResponseDto({
    String? id,
    String? courseId,
    String? userId,
    double? rating,
    String? comment,
    String? createdAt,
  }) = _ReviewResponseDto;

  factory ReviewResponseDto.fromJson(Map<String, Object?> json) => _$ReviewResponseDtoFromJson(json);
}
