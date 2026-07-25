import 'package:flutter_bloc_template/data/data_source/remote/dto/user/user_response_dto.dart';
import 'package:flutter_bloc_template/domain/entity/user/user_entity.dart';

abstract final class UserMapper {
  static UserEntity mapToEntity(UserResponseDto? dto) {
    return UserEntity(
      id: dto?.id ?? '',
      fullName: dto?.fullName ?? '',
      email: dto?.email ?? '',
      avatar: dto?.avatar ?? '',
      bio: dto?.bio ?? '',
      phoneNumber: dto?.phoneNumber ?? '',
      birthday: dto?.birthday ?? DateTime.now(),
      location: dto?.location ?? '',
      role: dto?.role ?? '',
    );
  }
}
