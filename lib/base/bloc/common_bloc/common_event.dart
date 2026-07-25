import 'dart:async';

import '../../exception/app_exception.dart';
import '../base_bloc/base_event.dart';

sealed class CommonEvent extends BaseEvent {
  @override
  List<Object?> get props => [];
}

final class LoadingVisibilityEmitted extends CommonEvent {
  final bool isLoading;

  LoadingVisibilityEmitted({required this.isLoading});

  @override
  List<Object?> get props => [isLoading];
}

final class AddExceptionCommonEvent extends CommonEvent {
  final AppException exception;
  AddExceptionCommonEvent({required this.exception});

  @override
  List<Object?> get props => [exception];
}

final class ForceLogoutCommonEvent extends CommonEvent {
  final Completer<void> completer;

  ForceLogoutCommonEvent({required this.completer});
  @override
  List<Object?> get props => [completer];
}
