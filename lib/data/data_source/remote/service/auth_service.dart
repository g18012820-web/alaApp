import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../domain/use_case/auth/login_use_case.dart';
import '../dto/api_response.dart';
import '../dto/auth/login_response_dto.dart';

part 'auth_service.g.dart';

@RestApi()
@lazySingleton
abstract class AuthService {
  @factoryMethod
  factory AuthService(Dio dio) = _AuthService;

  @POST('/login')
  Future<ApiResponse<LoginResponseDto>> login(@Body() LoginRequest req);
}