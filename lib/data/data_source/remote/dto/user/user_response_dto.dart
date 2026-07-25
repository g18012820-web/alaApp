import 'package:json_annotation/json_annotation.dart';

part 'user_response_dto.g.dart';

@JsonSerializable()
class UserResponseDto {
  @JsonKey(name: "id")
  String? id;
  @JsonKey(name: "fullName")
  String? fullName;
  @JsonKey(name: "email")
  String? email;
  @JsonKey(name: "avatar")
  String? avatar;
  @JsonKey(name: "bio")
  String? bio;
  @JsonKey(name: "phoneNumber")
  String? phoneNumber;
  @JsonKey(name: "birthday")
  DateTime? birthday;
  @JsonKey(name: "location")
  String? location;
  @JsonKey(name: "role")
  String? role;

  UserResponseDto({
    this.id,
    this.fullName,
    this.email,
    this.avatar,
    this.bio,
    this.phoneNumber,
    this.birthday,
    this.location,
    this.role,
  });

  factory UserResponseDto.fromJson(Map<String, dynamic> json) => _$UserResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserResponseDtoToJson(this);
}
