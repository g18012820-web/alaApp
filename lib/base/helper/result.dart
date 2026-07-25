import 'package:flutter_bloc_template/base/exception/app_exception.dart';

sealed class Result<T> with SealedResult<T> {
  const Result();

  bool get isSuccessful => this is Ok<T>;

  const factory Result.ok(T value) = Ok._;

  const factory Result.failure(AppException error) = Failure._;
}

final class Ok<T> extends Result<T> {
  final T? data;

  const Ok._(this.data);
}

final class Failure<T> extends Result<T> {
  final Object? error;

  const Failure._(this.error);
}

mixin SealedResult<T> {
  R? when<R>({
    R Function(T? data)? ok,
    R Function(Object? error)? failure,
  }) {
    if (this is Ok<T?>) {
      return ok?.call((this as Ok).data);
    }
    if (this is Failure<T>) {
      return failure?.call((this as Failure<T>).error);
    }
    throw AppException('An error occurred', type: AppExceptionType.unknown);
  }
}
