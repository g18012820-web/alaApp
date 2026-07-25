import 'package:json_annotation/json_annotation.dart';
part 'pagination_response.g.dart';

@JsonSerializable()
class PaginationResponse {
  int? currentPage;
  int? totalPages;
  int? pageSize;
  int? totalItems;

  PaginationResponse({
    this.currentPage,
    this.totalPages,
    this.pageSize,
    this.totalItems,
  });

  factory PaginationResponse.fromJson(Map<String, dynamic> json) => _$PaginationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationResponseToJson(this);
}