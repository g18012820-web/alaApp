import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

import '../../../../base/helper/message_parser.dart';
import 'pagination_response.dart';
part 'api_response.g.dart';

@JsonSerializable(explicitToJson: true, genericArgumentFactories: true)
class ApiResponse<T> {
  final int statusCode;
  @JsonKey(fromJson: MessageParser.parse)
  final List<String>? message;
  final String? error;
  final T? data;
  final PaginationResponse? pagination;

  const ApiResponse({
    required this.statusCode,
    this.message,
    this.error,
    this.data,
    this.pagination,
  });

  bool isSuccess() => statusCode >= HttpStatus.ok && statusCode < HttpStatus.multipleChoices;

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) => _$ApiResponseFromJson<T>(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T) toJsonT) => _$ApiResponseToJson<T>(this, toJsonT);
}
