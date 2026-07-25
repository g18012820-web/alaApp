import 'package:freezed_annotation/freezed_annotation.dart';

part 'paged_list.freezed.dart';

@Freezed(toJson: false, fromJson: false, genericArgumentFactories: true)
class PagedList<T> with _$PagedList<T> {
  const PagedList._();

  const factory PagedList({
    required List<T> data,
    @Default(null) Object? otherData,
    @Default(-99) int? next,
    @Default(-99) int? offset,
    @Default(-99) int? total,
  }) = _PagedList;

  bool get isLastPage => data.isEmpty || next == null;
}
