import 'package:freezed_annotation/freezed_annotation.dart';
part 'login_response_dto.freezed.dart';
part 'login_response_dto.g.dart';

@freezed
class LoginResponseDto with _$LoginResponseDto {
  const factory LoginResponseDto({
    String? token,
  }) = _LoginResponseDto;

  factory LoginResponseDto.fromJson(Map<String, Object?> json) =>
      _$LoginResponseDtoFromJson(json);
}
