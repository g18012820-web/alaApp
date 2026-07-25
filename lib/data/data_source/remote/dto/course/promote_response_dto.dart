import 'package:freezed_annotation/freezed_annotation.dart';
part 'promote_response_dto.freezed.dart';
part 'promote_response_dto.g.dart';

@freezed
class PromoteResponseDto with _$PromoteResponseDto {
  const factory PromoteResponseDto({
    String? id,
    String? title,
    String? description,
    String? discount,
    bool? isActive,
    String? expiryDate,
  }) = _PromoteResponseDto;

  factory PromoteResponseDto.fromJson(Map<String, Object?> json) => _$PromoteResponseDtoFromJson(json);
}
