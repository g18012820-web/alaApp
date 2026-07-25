import 'package:flutter_bloc_template/base/bloc/base_bloc/base_event.dart';

sealed class LoginEvent extends BaseEvent {
  @override
  List<Object?> get props => [];
}

final class LoginEmailChangedEvent extends LoginEvent {
  final String value;

  LoginEmailChangedEvent(this.value);

  @override
  List<Object?> get props => [value];
}

final class LoginPasswordChangedEvent extends LoginEvent {
  final String value;

  LoginPasswordChangedEvent(this.value);

  @override
  List<Object?> get props => [value];
}

final class RememberMeToggledEvent extends LoginEvent {
  final bool isRemembered;
  RememberMeToggledEvent(this.isRemembered);
}

final class LoginSubmittedEvent extends LoginEvent {}
