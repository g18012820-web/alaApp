import 'package:freezed_annotation/freezed_annotation.dart';
part 'category_response_dto.freezed.dart';
part 'category_response_dto.g.dart';

@freezed
class CategoryResponseDto with _$CategoryResponseDto {
  const factory CategoryResponseDto({
    String? id,
    String? name,
  }) = _CategoryResponseDto;

  factory CategoryResponseDto.fromJson(Map<String, Object?> json) => _$CategoryResponseDtoFromJson(json);
}
